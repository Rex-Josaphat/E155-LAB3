// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/28/2025

// This codes represents modules to test Development Board hardware by lighting on-board LEDs and showing oscillation
// as well as operating a 7-segment LED display, all using 4 DIP switches installed on the board


// Top master module to handle input and output allcations to the submodules
module top (
        input logic reset,
        input logic [3:0] swDIP,
        output logic [2:0] BoardLed,
        output logic [6:0] SegDisp);

        // Run output to On-Board Leds
        OnBoardLED_Ctrl OnBrdCtrl (reset, swDIP, BoardLed);

        // Run output to 7-segment Display
        Seven_SegDisp 7Disp (reset, swDIP, SegDisp);

endmodule


////////////////////////On-Board Led Control////////////////////////

// This Module controlls specific on-board in respose to the states of any of the 4 DIP switches.
// 2 LEDs will light up following the switch states, while the 3rd one blinks at 2.4 Hz

module OnBoardLED_Ctrl(
        input logic reset,
        input logic [3:0] swDIP,
        output logic [2:0] BoardLed);

        // Light up 2 LEDs
        assign BoardLed[0] = swDIP[0] ^ swDIP[1]; // XOR Operation Behaviour
        assign BoardLed[1] = swDIP[3] & swDIP[3]; // AND Operation Behaviour

        // Blink LED at 2.4Hz
        logic int_osc;
        logic [24:0] counter;

        // Internal high-speed oscillator
        HSOSC #(.CLKHF_DIV(2'b01)) 
            hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

        // Counter
        always_ff @(posedge int_osc, posedge reset) begin
            if(reset == 0)  counter <= 0;
            else            counter <= counter + 2; // Set counter increment to 2 gives ~2.8Hz
        end

        // Assign LED output
        assign BoardLed[2] = counter[24];

endmodule


////////////////////////7 Segment LED Display Control////////////////////////
// This Module controlls specific on-board in respose to the states of any of the 4 DIP switches.
// 2 LEDs will light up following the switch states, while the 3rd one blinks at 2.4 Hz
