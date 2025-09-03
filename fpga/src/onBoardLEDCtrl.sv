// Josaphat Ngoga
// jngoga@g.hmc.edu
// 8/28/2025

// This is the top module to test Development Board hardware by lighting on-board LEDs and showing oscillation.
// 2 LEDs will light up following the switch states, while the 3rd one blinks at 2.4 Hz

// Top master module to handle input and output allocations to the relevant submodules
module onBoardLEDCtrl (
        input logic reset,
        input logic [3:0] swDIP,
        output logic [2:0] BoardLed);

        ///////////////////////on-board LED control//////////////////////////////
        // Light up 2 LEDs
        assign BoardLed[0] = swDIP[0] ^ swDIP[1]; // LED1: XOR Operation Behaviour
        assign BoardLed[1] = swDIP[3] & swDIP[2]; // LED2: AND Operation Behaviour

        // Blink 3rd LED at 2.4Hz
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
            
            else if (counter == 10000000) begin // Counter to 10^7 ticks
                counter <= 0;
                led_pow <= ~led_pow; 
            end

            else counter <= counter + 1;
        end

        assign BoardLed[2] = led_pow; // Toggle LED
endmodule