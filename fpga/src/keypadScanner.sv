// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module receives the column input and scans rows to determine exactly
// which row was acivated. These values are then sent to the decoding module 
// to figure out which key was pressed
        
module keypadScanner(
        input logic clk, // 48MHz
        input logic reset, // Active LOW asynchronous reset
        input logic [3:0] col, // Synchronized column input
        output logic [3:0] rowScan, // Power the rows
        output logic [3:0] row, // Register row for comfirmed press
        output logic en); // Logic enabler for comfirmed keypress

        typedef enum logic [3:0] { S0, S1, S2, // row 0
                                   S3, S4, S5, // row 1
                                   S6, S7, S8, // row 2
                                   S9, S10, S11 // row 3                          
        } statetype;

        statetype state, nextstate;

        // Internal Logic
        logic keyPress; 
        logic [24:0] counter, DBcounter;
		logic clk_en; // Modified FSM scan clock

        // Set slow scan rate for the FSM
        always_ff @(posedge clk) begin
			if(!reset) begin
				counter <= 0;
				clk_en <= 1'b0;
			end else if (counter == 100_000 - 1) begin
				counter <= 0;
				clk_en <= 1'b1;
			end else begin
				counter <= counter + 1;
				clk_en <= 1'b0;
			end
		end

        assign keyPress = (col != 4'b0000) && ((col & (col - 1)) == 4'b0000); // Check if any key on the keypad is pressed but ensure only one is pressed        

        // State register
        always_ff @(posedge clk or negedge reset) begin
            if(!reset) state <= S0;
            else if (clk_en) state <= nextstate; // Only switch states at the defined rate
        end
        
		// Keypad Debouncing Logic (target 50ms debounce)
		localparam int unsigned DEBOUNCE = 24;

        always_ff @(posedge clk) begin
			if(!reset) DBcounter <= 0;
			else if (clk_en) begin
				if (state inside {S1, S4, S7, S10})begin
					if (keyPress && DBcounter < DEBOUNCE) begin
						DBcounter <= DBcounter + 1;
					end else if (!keyPress) begin
						DBcounter <= 0;
					end
				end else begin
					DBcounter <= 0;
				end
			end
		end

        // FSM State Transition Logic
        always_comb begin
            unique case (state)
				// Row 0
                S0:  if(keyPress) nextstate = S1;
                     else         nextstate = S3;
                S1:  if(!keyPress)nextstate = S3; 
                     else         nextstate = (DBcounter >= DEBOUNCE ? S2 : S1); 
                S2:  if(keyPress) nextstate = S2;
                     else         nextstate = S3; 

				// Row 1
                S3:  if(keyPress) nextstate = S4; 
                     else         nextstate = S6; 
                S4:  if(!keyPress)nextstate = S6;
                     else         nextstate = (DBcounter >= DEBOUNCE ? S5 : S4);  
                S5:  if(keyPress) nextstate = S5;
                     else         nextstate = S6; 

                // Row 2
				S6:  if(keyPress) nextstate = S7;
                     else         nextstate = S9; 
                S7:  if(!keyPress)nextstate = S9;
                     else         nextstate = (DBcounter >= DEBOUNCE ? S8 : S7); 
                S8:  if(keyPress) nextstate = S8;
                     else         nextstate = S9; 

				// Row 3
                S9:  if(keyPress) nextstate = S10;
                     else         nextstate = S0; 
                S10: if(!keyPress)nextstate = S0;
                     else         nextstate = (DBcounter >= DEBOUNCE ? S11 : S10); 
                S11: if(keyPress) nextstate = S11;
                     else         nextstate = S0; 
 
                default:          nextstate = S0;
            endcase
        end

        // Row Logic
    	assign row[0] = (state inside {S0,  S1,  S2 });
    	assign row[1] = (state inside {S3,  S4,  S5 });
    	assign row[2] = (state inside {S6,  S7,  S8 });
    	assign row[3] = (state inside {S9,  S10, S11});

		// Power the rows
        assign rowScan = row;

		// Enabler turns 
    	assign en = clk_en && keyPress &&
                	( ((state == S1)  && (DBcounter == DEBOUNCE - 1)) ||
                	  ((state == S4)  && (DBcounter == DEBOUNCE - 1)) ||
                	  ((state == S7)  && (DBcounter == DEBOUNCE - 1)) ||
                	  ((state == S10) && (DBcounter == DEBOUNCE - 1)) ); 

endmodule