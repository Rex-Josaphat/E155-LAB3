// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This is the top module for this lab. It takes in reset and switch inputs 
// and proceeds to instantiate the module responsible for perfoming the time-multiplexing
// and controlling LEDs. It also handles 

module lab3_JN( 
        input logic reset,
        input logic [3:0] col_async,
        output logic [3:0] rowScan,
        output logic [1:0] onSeg,
        output logic [6:0] segDisp);

        // Internal Logic
        logic clk; // oscillator clk
        logic [3:0] col; // Synchronized column input
        logic [3:0] row;
        logic [3:0] sevenSegIn; // seven-segment display input
        logic [3:0] sw1, sw2; // switches
        logic en;
        
        // Internal high-speed oscillator
        HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk)); // 48 MHz

        // Instantiate the input Synchronizing module
        synchronizer sync(clk, reset, col_async, col);

        // Instantiate the keypad scanner module
        keypadScanner keyScan(clk, reset, col, rowScan, row, en);

        // Instnatiate keypress decoding module
        keypadDecoder keyDec(clk, reset, en, row, col, sw1, sw2);

        // Instantiate the LED control and time-multiplexing module
        ledControl ledLogic(clk, reset, sw1, sw2, onSeg, sevenSegIn);

        // Instantiate module to control 7-segment display
        sevenSegDispCtrl segDispLogic(sevenSegIn, segDisp);

endmodule
