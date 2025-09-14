// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module receives the activated row and column and decodes it to detemine the 
// hexadecimal value pressed.

module keypadDecoder (
        input logic clk, reset,
        input logic en,
        input logic [3:0] row, col,
        output logic [3:0] sw1, sw2);

        // Internal Logic
        logic [3:0] key; // Hold the value of the detected key, necessary for switching
        logic en_hold ; // store current value of en
        logic en_rise; // store rising edge valid/not. Prevents display shwitching every cycle

        // Detect rising edge of valid key press and only register it once
        always_ff @(posedge clk or negedge reset) begin
            if (!reset) begin
                en_hold <= 1'b0;
            end else begin
                en_hold <= en;
            end
        end

        assign en_rise = en & ~en_hold; // rising edge detect

        // Number Switching Logic
        always_ff @(posedge clk) begin
            if (!reset) begin
                sw1 <= 4'b0000;
                sw2 <= 4'b0000;
            end else if (en_rise) begin
                sw2 <= sw1; // Assign the display to the previous value
                sw1 <= key;
            end
        end
        
        // Keypad Version 1
        always_comb begin
            case ({row, col})
                8'b0001_0001 : key = 4'hA;   
                8'b0001_0010 : key = 4'h0;
                8'b0001_0100 : key = 4'hB;
                8'b0001_1000 : key = 4'hF;
                
                8'b0010_0001 : key = 4'h7;
                8'b0010_0010 : key = 4'h8;
                8'b0010_0100 : key = 4'h9;
                8'b0010_1000 : key = 4'hE;
                
                8'b0100_0001 : key = 4'h4;
                8'b0100_0010 : key = 4'h5;
                8'b0100_0100 : key = 4'h6;
                8'b0100_1000 : key = 4'hD;
                
                8'b1000_0001 : key = 4'h1;
                8'b1000_0010 : key = 4'h2;
                8'b1000_0100 : key = 4'h3;
                8'b1000_1000 : key = 4'hC;
                
                default: key = 4'hF; // Default F
            endcase
        end

        // Keypad Version 2
        // always_comb begin
        //     case ({row, col})
        //         8'b0001_0001 : key = 4'h1;   
        //         8'b0001_0010 : key = 4'h2;
        //         8'b0001_0100 : key = 4'h3;
        //         8'b0001_1000 : key = 4'hA;
                
        //         8'b0010_0001 : key = 4'h4;
        //         8'b0010_0010 : key = 4'h5;
        //         8'b0010_0100 : key = 4'h6;
        //         8'b0010_1000 : key = 4'hB;
                
        //         8'b0100_0001 : key = 4'h7;
        //         8'b0100_0010 : key = 4'h8;
        //         8'b0100_0100 : key = 4'h9;
        //         8'b0100_1000 : key = 4'hC;
                
        //         8'b1000_0001 : key = 4'hE;
        //         8'b1000_0010 : key = 4'h0;
        //         8'b1000_0100 : key = 4'hF;
        //         8'b1000_1000 : key = 4'hD;
                
        //         default: key = 4'hF; // Default F
        //     endcase
        // end

endmodule