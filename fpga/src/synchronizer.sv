// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module synchronizes the sequence of the key columns from the keypad to eliminate metastability

module synchronizer (
        input logic clk, reset,
        input logic [3:0] col,
        output logic [3:0] col_sync);

        // internal logic
        logic [3:0] col_meta;

        // Synchronize
        always_ff @(posedge clk) begin
            if (reset == 0) begin
                col_meta <= 4'b0;
                col_sync <= 4'b0;
            end else begin
                col_meta <= col;
                col_sync <= col_meta;
            end
        end

endmodule