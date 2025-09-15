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
        output logic [3:0] rowScan, row, // Register rows
        output logic en); // Logic enabler to acknowledge a keypress is comfirmed

        typedef enum logic [3:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11} statetype;
        statetype state, nextstate;

        // Internal Logic
        logic keyPress;
        logic scan_delay; // To induce one cycle delay countering the synchronizer
     //    logic [24:0] counter;

        assign keyPress = col[0] ^ col[1] ^ col[2] ^ col[3]; // Check if any key on the keypad is pressed but ensure only one is pressed

     //    // Slow down scanning from the given 48MHz to 4kHz overall
     //    always_ff @(posedge clk, negedge reset) begin
     //        if(!reset) begin
     //            scan <= 0; counter <= 0;
     //        end else if (counter == 48_000 - 1) begin // Scan at 1kHz per row
     //                counter <= 0;
     //                scan <= 1;
     //        end else begin
     //                counter <= counter +1; scan <= 0;
     //        end
     //    end

		// Induce single-cycle delay
        always_ff @(posedge clk, negedge reset) begin
            if(!reset) begin
                scan_delay <= 1'b0;
            end else begin
                scan_delay <= keyPress;
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
                S0:  if(scan_delay) nextstate = S1; // row[0]
                     else         nextstate = S3;

                S1:  if(scan_delay) nextstate = S2; 
                     else         nextstate = S3; 

                S2:  if(scan_delay) nextstate = S2;
                     else         nextstate = S3; 

                S3:  if(scan_delay) nextstate = S4; // row[1]
                     else         nextstate = S6; 

                S4:  if(scan_delay) nextstate = S5;
                     else         nextstate = S6; 

                S5:  if(scan_delay) nextstate = S5;
                     else         nextstate = S6; 

                S6:  if(scan_delay) nextstate = S7; // row[2]
                     else         nextstate = S9; 

                S7:  if(scan_delay) nextstate = S8;
                     else         nextstate = S9; 

                S8:  if(scan_delay) nextstate = S8;
                     else         nextstate = S9; 

                S9:  if(scan_delay) nextstate = S10; // row[3]
                     else         nextstate = S0; 

                S10: if(scan_delay) nextstate = S11;
                     else         nextstate = S0; 

                S11: if(scan_delay) nextstate = S11;
                     else         nextstate = S0; 
 
                default:          nextstate = S0;
            endcase
        end

        // power a specific row depending on which state is active
	    assign rowScan[0] = ((state == S0) | (state == S1) | (state == S2) | (state == S4) | (state == S5) | (state == S7) | (state == S8) | (state == S10) | (state == S11));
	    assign rowScan[1] = ((state == S3) | (state == S1) | (state == S2) | (state == S4) | (state == S5) | (state == S7) | (state == S8) | (state == S10) | (state == S11));
	    assign rowScan[2] = ((state == S6) | (state == S1) | (state == S2) | (state == S4) | (state == S5) | (state == S7) | (state == S8) | (state == S10) | (state == S11));
	    assign rowScan[3] = ((state == S9) | (state == S1) | (state == S2) | (state == S4) | (state == S5) | (state == S7) | (state == S8) | (state == S10) | (state == S11));
    
        // Row Logic
        assign row[0] = ((state == S0) | (state == S1) | (state == S2));
        assign row[1] = ((state == S3) | (state == S4) | (state == S5));
        assign row[2] = ((state == S6) | (state == S7) | (state == S8));
        assign row[3] = ((state == S9) | (state == S10) | (state == S11));

        assign en  = ((state == S1) | (state == S4) | (state == S7) | (state == S10)); // Enabler ON

endmodule