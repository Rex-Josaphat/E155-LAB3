// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module receives the column input and scans rows to determine exactly
// which row was acivated. These values are then sent to the decoding module 
// to figure out which key was pressed
        
module keypadScanner(
        input logic clk, 
        input logic reset, // Active LOW asynchronous reset
        input logic [3:0] col,
        output logic [3:0] row, // Register rows
        output logic en); // Logic enabler to acknowledge a keypress is comfirmed

        typedef enum logic [3:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11} statetype;
        statetype state, nextstate;

        // Internal Logic
        logic keyPress;
        logic scan; // Enabler determining the rate of scanning rows
        logic [24:0] counter;

        keyPress = col[0] ^ col[1] ^ col[2] ^ col[3]; // Check if any key on the keypad is pressed but ensure only one is pressed

        always_ff @(posedge clk, negedge reset) begin
            if(!reset) begin
                scan <= 0; counter <= 0;
            end else if (counter == 12_000 - 1) begin // Scan each row at 1kHz, eliminates debouncing
                    counter <= 0;
                    scan <= 1;
            end else begin
                    counter <= counter +1; scan <= 0;
            end
        end

        // State register
        always_ff @(posedge clk, negedge reset) begin
            if(!reset) state <= S0;
            else if (scan) state <= nextstate; // Only switch states at the defined rate
        end
        
        // FSM State Logic
        always_comb begin
            case (state)
                S0:  if(keyPress) nextstate <= S1; // row[0]
                     else         nextstate <= S3;

                S1:  if(keyPress) nextstate <= S2; 
                     else         nextstate <= S3; 

                S2:  if(keyPress) nextstate <= S2;
                     else         nextstate <= S3; 

                S3:  if(keyPress) nextstate <= S4; // row[1]
                     else         nextstate <= S6; 

                S4:  if(keyPress) nextstate <= S5;
                     else         nextstate <= S6; 

                S5:  if(keyPress) nextstate <= S5;
                     else         nextstate <= S6; 

                S6:  if(keyPress) nextstate <= S7; // row[2]
                     else         nextstate <= S9; 

                S7:  if(keyPress) nextstate <= S8;
                     else         nextstate <= S9; 

                S8:  if(keyPress) nextstate <= S8;
                     else         nextstate <= S9; 

                S9:  if(keyPress) nextstate <= S10; // row[3]
                     else         nextstate <= S0; 

                S10: if(keyPress) nextstate <= S11;
                     else         nextstate <= S0; 

                S11: if(keyPress) nextstate <= S11;
                     else         nextstate <= S0; 
 
                default:          nextstate <= S0;
            endcase
        end

        // Row Logic
        assign row[0] = (state == S0) | (state == S1) | (state == S2);
        assign row[1] = (state == S3) | (state == S4) | (state == S5);
        assign row[2] = (state == S6) | (state == S7) | (state == S8);
        assign row[3] = (state == S9) | (state == S10) | (state == S11);

        assign en  = (state == S1) | (state == S4) | (state == S7) | (state == S10); // Enabler ON

endmodule