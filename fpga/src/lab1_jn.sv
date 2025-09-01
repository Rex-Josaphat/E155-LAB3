// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/28/2025

// This codebase represents modules to test Development Board hardware by lighting on-board LEDs and showing oscillation
// as well as operating a 7-segment LED display, all using 4 DIP switches installed on the board


// Top master module to handle input and output allocations to the relevant submodules
module top (
        input logic reset,
        input logic [3:0] swDIP,
        output logic [2:0] BoardLed,
        output logic [6:0] SegDisp);

        // Run output to On-Board Leds
        OnBoardLEDCtrl OnBrdCtrl (reset, swDIP, BoardLed);
        
        // Run output to 7-segment Display
        SevenSegDispCtrl DispCtrl (reset, swDIP, SegDisp);
endmodule


////////////////////////On-Board Led Control////////////////////////

// This Module controlls specific on-board LEDs in respose to the states of the 4 DIP switches.
// 2 LEDs will light up following the switch states, while the 3rd one blinks at 2.4 Hz

module OnBoardLEDCtrl(
        input logic reset,
        input logic [3:0] swDIP,
        output logic [2:0] BoardLed);

        // Light up 2 LEDs
        assign BoardLed[0] = swDIP[0] ^ swDIP[1]; // LED1: XOR Operation Behaviour
        assign BoardLed[1] = swDIP[3] & swDIP[3]; // LED2: AND Operation Behaviour

        // Blink LED3 at 2.4Hz
        logic int_osc;
        logic led_pow; // For tracking BoardLed[2] state
        logic [24:0] counter;

        // Internal high-speed oscillator
        HSOSC hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

        // Counter
        always_ff @(posedge int_osc) begin
            if(reset == 0) begin
                counter <= 0; led_pow <= 0;
            end
            
            else if (counter == 10000000) begin
                counter <= 0;
                BoardLed[2] <= ~led_pow; // Assign LED output
            end

            else counter <= counter + 1;
        end
endmodule


////////////////////////7-Segment LED Display Control////////////////////////
// This Module controlls the 7 segment display in response to the states of the 4 DIP switches.
// The interpreted hex value will be diplayed accurately using the segments of the diplay

module SevenSegDispCtrl(
        input logic reset,
        input logic [3:0] swDIP,
        output logic [6:0] SegDisp);

        always_comb begin
            case (swDIP)
                4'h0 : SegDisp = 7'b1000000;
                4'h1 : SegDisp = 7'b1111001;
                4'h2 : SegDisp = 7'b0100100;
                4'h3 : SegDisp = 7'b0110000;
                4'h4 : SegDisp = 7'b0011001;
                4'h5 : SegDisp = 7'b0010010;
                4'h6 : SegDisp = 7'b0000010;
                4'h7 : SegDisp = 7'b1111000;
                4'h8 : SegDisp = 7'b0000000;
                4'h9 : SegDisp = 7'b0011000;
                4'ha : SegDisp = 7'b0001000;
                4'hb : SegDisp = 7'b0000011;
                4'hc : SegDisp = 7'b1000110;
                4'hd : SegDisp = 7'b0100001;
                4'he : SegDisp = 7'b0000110;
                4'hf : SegDisp = 7'b0001110;

                default: SegDisp = 7'b1111111; // Default OFF
            endcase            
        end
endmodule