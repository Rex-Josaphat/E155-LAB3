// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/2/2025

// This is the top module for this lab. It takes in reset and switch inputs 
// and proceeds to instantiate the module for controlling the on-board lEDs
// (blinking and logic) and the one controlling the 7-segment display

module top (
    input logic reset,
    input logic [3:0] swDIP,
    output logic [2:0] BoardLed,
    output logic [6:0] SegDisp);

    // Instantiate module to control LEDs
    onBoardLEDCtrl ledLogic(reset, swDIP, BoardLed);

    // Instantiate module to control 7-segment display
    sevenSegDispCtrl segDispLogic(swDIP, SegDisp);

endmodule
