// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module takes in switch inputs and clk and also handles the multiplexing determining which of the
// segment displays gets to be on. It also has the 4-bit adder that calculates the sum of the two input 
// digits and lights up the external LEDs. 

module ledControl #(parameter  int SWITCH_COUNT = 100_000)( 
        input logic clk, reset,
        input logic [3:0] sw1, sw2,
        output logic [1:0] onSeg, // Segment enablers, onSeg[0]: Left Display, onSeg[1]: Right Display, 
        output logic [4:0] segSum,
        output logic [3:0] sevenSegIn);

        // Internal Logic
        logic seg_en; // Selector for which segment goes on
        logic [24:0] counter;
        logic [3:0] next_sw; // This for pre-loading switch input and avoid bleeding displays

        // Sum of displayed digits
        assign segSum = sw1 + sw2;

        ////////////// Time-multiplexing logic ///////////////
        // Counter to allow switching
        always_ff @(posedge clk) begin
            if(reset == 0) begin
                counter <= 0; seg_en <= 0;
            end
                else if (counter == SWITCH_COUNT-1) begin // Switch every 1*10^5 cycles (~2 ms)
                counter <= 0;
                seg_en <= ~seg_en; 
            end
            else counter <= counter + 1;
        end
        
        //////////////// 7-segment display input and enabler logic //////////////////
        always_comb begin
            next_sw = (seg_en == 0) ? sw1 : sw2; // Preload the next digit data
            if (counter < 500) begin // This is a blank stage to ensure both displays are off before we switch and send new data (10us)
                onSeg = 2'b00; // Turn off all segments
                sevenSegIn = next_sw; // Send chosen data to Segment display 

            end else begin
                onSeg = (seg_en == 0) ? 2'b10 : 2'b01; // Turn on a selected segment
                sevenSegIn = next_sw; // Send chosen data to Segment display
            end
        end

endmodule
