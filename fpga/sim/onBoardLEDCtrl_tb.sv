// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/29/2025

// This codebase represents the testbench to simulate and determine if the codebase prompts the hardware to react as desired/expected

`timescale 1ns/1ns // Defines time unit as 1ns and time precision as 1ps
module onBoardLEDCtrl_tb();
		logic clk, reset;
		logic [3:0] swDIP;
		logic [2:0] BoardLed, BoardLedExpected;
		logic [31:0] vectornum, errors;
		logic [6:0] testvectors[10000:0];
       
        // instantiate device under test
        onBoardLEDCtrl dut(reset, swDIP, BoardLed);

        // generate clock
        always
        	begin	
        		clk=1; #5; 
        		clk=0; #5;
        	end

        // at start of test, load vectors and pulse reset
        initial
        	begin
        		$readmemb("onBoardLEDCtrl_tv.tv", testvectors);

    			vectornum = 0; 
    			errors = 0; 

    			reset = 1; #22; 
    			reset = 0;
    		end

        // apply test vectors on rising edge of clk
        always @(posedge clk) begin
        	begin
        		#1; {swDIP, BoardLedExpected} = testvectors[vectornum];
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

        		vectornum = vectornum + 1;

        		if (testvectors[vectornum] === 7'bx) begin
        			$display("%d tests completed with %d errors", vectornum, errors);
        			$stop;
        		end
        	end
		end
endmodule