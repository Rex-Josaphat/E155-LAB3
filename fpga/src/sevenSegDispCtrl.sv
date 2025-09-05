// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/5/2025

// This Module controlls the 7 segment display in response to the states of 4 DIP switches.
// The interpreted hex value will be diplayed accurately using the segments of the diplay

module sevenSegDispCtrl(
        input logic [3:0] sevenSegIn,
        output logic [6:0] segDisp);

        always_comb begin
            case (sevenSegIn)
                4'h0 : segDisp = 7'b1000000;
                4'h1 : segDisp = 7'b1111001;
                4'h2 : segDisp = 7'b0100100;
                4'h3 : segDisp = 7'b0110000;
                4'h4 : segDisp = 7'b0011001;
                4'h5 : segDisp = 7'b0010010;
                4'h6 : segDisp = 7'b0000010;
                4'h7 : segDisp = 7'b1111000;
                4'h8 : segDisp = 7'b0000000;
                4'h9 : segDisp = 7'b0010000;
                4'ha : segDisp = 7'b0001000;
                4'hb : segDisp = 7'b0000011;
                4'hc : segDisp = 7'b1000110;
                4'hd : segDisp = 7'b0100001;
                4'he : segDisp = 7'b0000110;
                4'hf : segDisp = 7'b0001110;

                default: segDisp = 7'b1111111; // Default OFF
            endcase            
        end
endmodule