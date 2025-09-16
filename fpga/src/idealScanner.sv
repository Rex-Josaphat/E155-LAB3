// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module receives the column input and scans rows to determine exactly
// which row was acivated. These values are then sent to the decoding module 
// to figure out which key was pressed
        
module keypadScanner(
        input logic clk, // 240Hz
        input logic reset, // Active LOW asynchronous reset
        input logic [3:0] col, // Synchronized column input
        output logic [3:0] rowScan, // Power the rows
        output logic [3:0] row, // Register row for comfirmed press
        output logic en); // Logic enabler to acknowledge a keypress is comfirmed

        typedef enum logic [3:0] { S0, S1, S2, // row 0
                                   S3, S4, S5, // row 1
                                   S6, S7, S8, // row 2
                                   S9, S10, S11 // row 3
                                   
        } statetype;

        statetype state, nextstate;

        // Internal Logic
        logic keyPress;
        logic [2:0] debounce_counter; // 3-bit counter for debouncing
        logic stable_keypress;

        assign keyPress = (col != 0) && ((col & (col -1)) == 0); // Check if any key on the keypad is pressed but ensure only one is pressed

        // Debouncing logic
        always_ff @(posedge clk, negedge reset) begin
            if(!reset) begin
                debounce_counter <= 0;
                stable_keypress <= 0;
            end else begin
                if (keyPress) begin
                    if (debounce_counter == 3'b111) begin // 8 consecutive cycles
                        stable_keypress <= 1;
                    end else begin
                        debounce_counter <= debounce_counter + 1;
                        stable_keypress <= 0;
                    end
                end else begin
                    debounce_counter <= 0;
                    stable_keypress <= 0;
                end
            end
        end

        // State register
        always_ff @(posedge clk, negedge reset) begin
            if(!reset) state <= S0;
            else state <= nextstate; // Only switch states at the defined rate
        end
        
        // FSM State Logic
        always_comb begin
            case (state)
                S0:  if(stable_keypress) nextstate = S1; // row[0]
                     else         nextstate = S3;

                S1:  if(stable_keypress) nextstate = S2; 
                     else         nextstate = S3; 

                S2:  if(stable_keypress) nextstate = S2;
                     else         nextstate = S3; 

                S3:  if(stable_keypress) nextstate = S4; // row[1]
                     else         nextstate = S6; 

                S4:  if(stable_keypress) nextstate = S5;
                     else         nextstate = S6; 

                S5:  if(stable_keypress) nextstate = S5;
                     else         nextstate = S6; 

                S6:  if(stable_keypress) nextstate = S7; // row[2]
                     else         nextstate = S9; 

                S7:  if(stable_keypress) nextstate = S8;
                     else         nextstate = S9; 

                S8:  if(stable_keypress) nextstate = S8;
                     else         nextstate = S9; 

                S9:  if(stable_keypress) nextstate = S10; // row[3]
                     else         nextstate = S0; 

                S10: if(stable_keypress) nextstate = S11;
                     else         nextstate = S0; 

                S11: if(stable_keypress) nextstate = S11;
                     else         nextstate = S0; 
 
                default:          nextstate = S0;
            endcase
        end
    
        // power a specific row depending on which state is active
        assign rowScan[0] = ((state == S0) | (state == S1) | (state == S2));
        assign rowScan[1] = ((state == S3) | (state == S4) | (state == S5));
        assign rowScan[2] = ((state == S6) | (state == S7) | (state == S8));
        assign rowScan[3] = ((state == S9) | (state == S10) | (state == S11));

        // Row Logic
        assign row[0] = ((state == S0) | (state == S1) | (state == S2));
        assign row[1] = ((state == S3) | (state == S4) | (state == S5));
        assign row[2] = ((state == S6) | (state == S7) | (state == S8));
        assign row[3] = ((state == S9) | (state == S10) | (state == S11));

        assign en  = ((state == S1) | (state == S4) | (state == S7) | (state == S10)) && stable_keypress; // Enabler ON

endmodule