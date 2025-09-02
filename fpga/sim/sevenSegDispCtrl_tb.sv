// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/1/2025

// This is a testbench to simulate and determine if the 7-segment display reacts as desired/expected

`timescale 1ns/1ns // Defines time unit as 1ns and time precision as 1ns
module sevenSegDispCtrl_tb();
		logic clk, reset;
		logic [3:0] swDIP;
		logic [6:0] SegDisp, SegDispExpected;
		logic [31:0] vectornum, errors;
		logic [10:0] testvectors[10000:0];
       
        // instantiate device under test
        sevenSegDispCtrl dut(swDIP, SegDisp);

        // generate clock
        always
        	begin	
        		clk=1; #5; 
        		clk=0; #5;
        	end

        // at start of test, load vectors and pulse reset
        initial
        	begin
        		$readmemb("sevenSegDispCtrl_tv.tv", testvectors);

    			vectornum = 0; 
    			errors = 0; 

    			reset = 1; #22; 
    			reset = 0;
    		end

        // apply test vectors on rising edge of clk
        always @(posedge clk) begin
        	begin
        		#1; {swDIP, SegDispExpected} = testvectors[vectornum];
        	end
		end

        // check results on falling edge of clk
        always @(negedge clk) begin

        	if (~reset) begin // skip during reset
				if (SegDisp !== SegDispExpected) begin // check 7-segment display result
        			$display("Error: inputs = %b", {swDIP});
        			$display(" outputs = %b  (%b expected)", SegDisp, SegDispExpected);
        			errors = errors + 1;
				end

        		vectornum = vectornum + 1;

        		if (testvectors[vectornum] === 11'bx) begin
        			$display("%d tests completed with %d errors", vectornum, errors);
        			$stop;
        		end
        	end
		end
endmodule