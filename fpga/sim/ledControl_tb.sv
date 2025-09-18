// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/6/2025

// This codebase represents the testbench to simulate and determine if the codebase prompts the hardware to react as desired/expected

`timescale 1ns/1ps // Defines time unit as 1ns and time precision as 1ps
module ledControl_tb();
        logic clk, reset;
        logic [3:0] sw1, sw2;
        logic [1:0] onSeg; 
        logic [3:0] sevenSegIn;
        
        // instantiate device under test
        ledControl #(.SWITCH_COUNT(1)) dut(.clk(clk), .reset(reset), .sw1(sw1), .sw2(sw2), .onSeg(onSeg), .sevenSegIn(sevenSegIn));

        // generate clock
        always
        	begin	
        		clk=1; #0.1; // run a much faster clock to be able to see switching in testbench
        		clk=0; #0.1;
        	end

        // Pulse the reset at start of tests 
        initial begin
            reset = 0;         
            #0.2; // Delay for full clock cycle
            reset = 1;
        end

        /////// Check LED Sum //////
        // There are 256 (16^2) possible combinations of the two displays.
        initial begin
            // Initialize inputs
            sw1 = 4'b0000; sw2 = 4'b0000;

            @(posedge clk);
            for (int a = 0; a < 16; a++) begin
                for(int b = 0; b < 16; b++) begin
                    sw1 = a[3:0];
                    sw2 = b[3:0];

                    #0.4;  // Hold input for 2 clock cycles, the time it takes to switch enablers

                end
            end
        end
endmodule