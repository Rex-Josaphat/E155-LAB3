// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/1/2025

// This Module controlls the 7 segment display in response to the states of the 4 DIP switches.
// The interpreted hex value will be diplayed accurately using the segments of the diplay

module sevenSegDispCtrl(
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