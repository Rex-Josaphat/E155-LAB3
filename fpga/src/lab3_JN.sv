// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This is the top module for this lab. It takes in reset and switch inputs 
// and proceeds to instantiate the module responsible for perfoming the time-multiplexing
// and controlling LEDs. It also handles 

module top( 
        input logic reset,
        input logic [3:0] sw1, sw2,
        output logic [1:0] onSeg,
        output logic [4:0] segSum,
        output logic [6:0] segDisp);

        // Internal Logic
        logic [3:0] sevenSegIn;
        logic int_osc;
        
        // Internal high-speed oscillator
        HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc)); // 48 MHz

        // Instantiate the LED control and time-multiplexing module
        ledControl ledLogic(int_osc, reset, sw1, sw2, onSeg, segSum, sevenSegIn);

        // Instantiate module to control 7-segment display
        sevenSegDispCtrl segDispLogic(sevenSegIn, segDisp);

endmodule
