// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/29/2025

// This codebase represents the testbench to simulate and determine if the codebase prompts the hardware to react as desired/expected

module testbench();
		logic clk, reset;
		logic [3:0] swDIP;
		logic [2:0] BoardLed, BoardLedExpected;
		logic [6:0] SegDisp, SegDispExpected;
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
        		$readmemb("lab1_tv.tv", testvectors);

    			vectornum = 0; 
    			errors = 0; 

    			reset = 1; #22; 
    			reset = 0;
    		end

        // apply test vectors on rising edge of clk
        always @(posedge clk) begin
        	begin
        		#1; {swDIP, BoardLedExpected, SegDispExpected} = testvectors[vectornum];
        	end
		end

        // check results on falling edge of clk
        always @(negedge clk) begin

        	if (~reset) begin // skip during reset
        		if (BoardLed !== BoardLedExpected) begin // check on-board LED result
        			$display("Error: inputs = %b", {swDIP});
        			$display(" outputs = %b  (%b expected)", BoardLed, BoardLedExpected);
        			errors = errors + 1;
        		end 
				
				if (SegDisp !== SegDispExpected) begin // check 7-segment display result
        			$display("Error: inputs = %b", {swDIP});
        			$display(" outputs = %b  (%b expected)", SegDisp, SegDispExpected);
        			errors = errors + 1;
				end

        		vectornum = vectornum + 1;

        		if (testvectors[vectornum] === 14'bx) begin
        			$display("%d tests completed with %d errors", vectornum, errors);
        			$stop;
        		end
        	end
		end
endmodule