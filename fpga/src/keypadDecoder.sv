// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module decodes keypad inputs, leveraging FSM logic. It understands the correct key input
// and stores it to be sent to update the displays.

module keypadDecoder (
        input logic clk, 
        input logic reset, // Active LOW asynchronous reset
        input logic col0, col1, col2, col3,
        output logic [3:0] key);

        typedef enum logic [3:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11} statetype;
        statetype state, nextstate;

        // Internal Logic
        logic keyPress
        logic row0, row1, row2, row3 

        keyPress = col0 | col1 | col2 | col3; // Check if any key on the keypad is pressed

        // State register
        always_ff @(posedge clk, posedge reset ) begin
            if(reset) state <= S0;
            else state <= nextstate;
        end
        
        // FSM State Logic
        always_comb begin
            case (state)
                S0:  if(keyPress) nextstate <= S1; // First row (1, 2, 3, A)
                     else    nextstate <= S3;

                S1:  if(keyPress) nextstate <= S2; 
                     else    nextstate <= S3; 

                S2:  if(keyPress) nextstate <= S2;
                     else    nextstate <= S3; 

                S3:  if(keyPress) nextstate <= S4; // Second row (4, 5, 6, B)
                     else    nextstate <= S6; 

                S4:  if(keyPress) nextstate <= S5;
                     else    nextstate <= S6; 

                S5:  if(keyPress) nextstate <= S5;
                     else    nextstate <= S6; 

                S6:  if(keyPress) nextstate <= S7; // Second row (7, 8, 9, C)
                     else    nextstate <= S9; 

                S7:  if(keyPress) nextstate <= S8;
                     else    nextstate <= S9; 

                S8:  if(keyPress) nextstate <= S8;
                     else    nextstate <= S9; 

                S9:  if(keyPress) nextstate <= S10; // Second row (E, 0, F, D)
                     else    nextstate <= S0; 

                S10: if(keyPress) nextstate <= S11;
                     else    nextstate <= S0; 

                S11: if(keyPress) nextstate <= S11;
                     else    nextstate <= S1; 
 
                default: nextstate <= S0;
            endcase
        end

        // Row Logic
        assign row0 = (state == S0) | (state == S1) | (state == S2);
        assign row1 = (state == S3) | (state == S4) | (state == S5);
        assign row2 = (state == S6) | (state == S7) | (state == S8);
        assign row3 = (state == S9) | (state == S10) | (state == S11);

        // Key Logic
        if(col0) begin
            if      (row0) key = 4'b0001; // 1
            else if (row1) key = 4'b0010; // 2
            else if (row2) key = 4'b0011; // 3
            else if (row3) key = 4'b1010; // A
        end

        else if(col0) begin
            if      (row0) key = 4'b0100; // 4
            else if (row1) key = 4'b0101; // 5
            else if (row2) key = 4'b0110; // 6
            else if (row3) key = 4'b1011; // B
        end

        else if(col0) begin
            if      (row0) key = 4'b0111; // 7
            else if (row1) key = 4'b1000; // 8
            else if (row2) key = 4'b1001; // 9
            else if (row3) key = 4'b1100; // C
        end

        else if(col0) begin
            if      (row0) key = 4'b1110; // E
            else if (row1) key = 4'b0000; // 0
            else if (row2) key = 4'b1111; // F
            else if (row3) key = 4'b1101; // D
        end

endmodule