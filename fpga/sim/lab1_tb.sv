// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/29/2025

// This codebase represents the testbench to simulate and determine if the codebase prompts the hardware to react as desired/expected

module testbench();
		logic clk, reset;
		logic [3:0] swDIP;
		// logic [2:0] BoardLed, BoardLed_expected;
		// logic [6:0] SegDisp, SegDisp_expected;
		logic [2:0] BoardLed;
		logic [6:0] SegDisp;
		logic [9:0] expected;
		logic [31:0] vectornum, errors;
		logic [13:0] testvectors[10000:0];
       
        // instantiate device under test
        top dut(reset, swDIP, BoardLed, SegDisp);

        // generate clock
        always
        	begin	
        		clk=1; #5; 
        		clk=0; #5;
        	end

        // at start of test, load vectors and pulse reset
        initial
        	begin
        		$readmemb("lab1SIM.tv", testvectors);

    			vectornum = 0; 
    			errors = 0; 

    			reset = 1; #22; 
    			reset = 0;
    		end

        // apply test vectors on rising edge of clk
        always @(posedge clk)
        	begin
        		#1; 
        		{swDIP, expected} = testvectors[vectornum];
        	end

        // check results on falling edge of clk
        always @(negedge clk)

        	if (~reset) begin // skip during reset
        		if ({BoardLed, SegDisp} !== expected) begin // check result
        			$display("Error: inputs = %b", {swDIP});
        			$display(" outputs = %b %b %b %b %b %b %b %b %b %b (%b expected)",
        			BoardLed, SegDisp, expected);
					
        			errors = errors + 1;
        		end

        		vectornum = vectornum + 1;

        		if (testvectors[vectornum] === 14'bx) begin
        			$display("%d tests completed with %d errors", vectornum, errors);
        			$stop;
        		end
        	end
endmodule