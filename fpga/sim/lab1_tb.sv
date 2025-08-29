// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/29/2025

// This codebase represents the testbench to simulate and determine if the codebase promps the hardware to react as expected

module testbench();
		logic clk, reset;
		logic n, s ,e, w, win, die;
		logic [1:0] expected;
		logic [31:0] vectornum, errors;
		logic [5:0] testvectors[10000:0];
       
        // instantiate device under test
        adventure dut(clk, reset, n, s ,e, w, win, die);

        // generate clock
        always
        	begin
        		clk=1; #5; 
        		clk=0; #5;
        	end

        // at start of test, load vectors and pulse reset
        initial
        	begin
        		$readmemb("adventure.tv", testvectors);

    			vectornum = 0; 
    			errors = 0; 

    			reset = 1; #22; 
    			reset = 0;
    		end

        // apply test vectors on rising edge of clk
        always @(posedge clk)
        	begin
        		#1; 
        		{n, s, e, w, expected} = testvectors[vectornum];
        	end

        // check results on falling edge of clk
        always @(negedge clk)

        	if (~reset) begin // skip during reset
        		if ({win, die} !== expected) begin // check result
        			$display("Error: inputs = %b", {n, s, e, w});
        			$display(" outputs = %b %b (%b expected)",
        			win, die, expected);
        			errors = errors + 1;
        		end

        		vectornum = vectornum + 1;

        		// Set Rest after game ends
        		if (win || die) begin
        			reset = 1; #1;
        			reset = 0;
        		end

        		if (testvectors[vectornum] === 6'bx) begin
        			$display("%d tests completed with %d errors", vectornum, errors);
        			$stop;
        		end
        	end
endmodule