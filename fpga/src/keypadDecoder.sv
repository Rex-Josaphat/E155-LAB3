// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module receives the activated row and column and decodes it to detemine the 
// hexadecimal value pressed.

module keypadDecoder (
        input logic [3:0] row, col,
        output logic [3:0] key);

        // Keypad Version 1
        always_comb begin
            case ({row, col})
                8'b0001_0001 : key = 4'hA;   
                8'b0001_0010 : key = 4'h9;
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