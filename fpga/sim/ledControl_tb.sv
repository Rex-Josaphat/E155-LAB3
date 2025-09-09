// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/6/2025

// This codebase represents the testbench to simulate and determine if the codebase prompts the hardware to react as desired/expected

`timescale 1ns/1ps // Defines time unit as 1ns and time precision as 1ns
module ledControl_tb();
        logic clk, reset;
        logic [3:0] sw1, sw2;
        logic [1:0] onSeg; 
        logic [4:0] segSum, segSumExpected;
        logic [3:0] sevenSegIn;
        
        // instantiate device under test
        ledControl #(.SWITCH_COUNT(1)) dut(.clk(clk), .reset(reset), .sw1(sw1), .sw2(sw2), .onSeg(onSeg), .segSum(segSum), .sevenSegIn(sevenSegIn));

        // generate clock
        always
        	begin	
        		clk=1; #0.1; // run a much faster clock to be able to see switching in testbench
        		clk=0; #0.1;
        	end

        // Pulse the reset at start of tests 
        initial begin
            reset = 0;         
            #0.2;
            reset = 1;
        end

        /////// Check LED Sum //////
        // There are 256 (16^2) possible combinations of the two displays. Here I run as much as 12 cases only
        initial begin
            sw1 = 4'b0000; sw2 = 4'b0101; segSumExpected = 5'b00101; #0.4; // Hold input for 2 clock cycles
            assert (segSum == segSumExpected) else $error("Expected sum = 5: %b. Got %b", segSum, segSumExpected);

            sw1 = 4'b0001; sw2 = 4'b1000; segSumExpected = 5'b01001; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 9: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1001; sw2 = 4'b0010; segSumExpected = 5'b01011; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 11: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1110; sw2 = 4'b0011; segSumExpected = 5'b10001; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 17: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0100; sw2 = 4'b1010; segSumExpected = 5'b01110; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 14: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0101; sw2 = 4'b0101; segSumExpected = 5'b01010; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 10: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1101; sw2 = 4'b0110; segSumExpected = 5'b10011; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 19: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0111; sw2 = 4'b1011; segSumExpected = 5'b10010; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 18: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1000; sw2 = 4'b0111; segSumExpected = 5'b01111; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 15: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1111; sw2 = 4'b1110; segSumExpected = 5'b11101; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 29: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1101; sw2 = 4'b1010; segSumExpected = 5'b10111; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 23: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1011; sw2 = 4'b1100; segSumExpected = 5'b10111; #0.4;
            assert (segSum == segSumExpected) else $error("Expected sum = 23: %b. Got %b", segSum, segSumExpected);

            // $finish;
        end
endmodule