// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/11/2025

// This module synchronizes the sequence of the key columns from the keypad to eliminate metastability

module synchronizer (
        input logic clk, reset,
        input logic [3:0] col_async,
        output logic [3:0] col);

        // internal logic
        logic [3:0] col_meta;

        // Synchronize
        always_ff @(posedge clk or negedge reset) begin
            if (!reset) begin
                col_meta <= 4'hF;
                col <= 4'hF;
            end else begin
                col_meta <= col_async;
                col <= col_meta;
            end
        end

endmodule