// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/13/2025

// Testbench to simulate decoding pressed key from a series of row and column inputs
// Testbench also simulates input switching between the two displays

module keypadDecoder_tb();
        input logic clk, reset;
        input logic en;
        input logic [3:0] row, col;
        output logic [3:0] sw1, sw2;
        
        // Instantiate device under test
        keypadDecoder dut(.clk(clk), .reset(reset), .en(en), .row(row), .col(col), .sw1(sw1), .sw2(sw2));

        // generate clock
	always begin
	    clk = 0; #5;
		clk = 1; #5;
	end

    // Pulse the reset at start of tests 
    initial begin
        reset = 1;         
        #20; 
        reset = 0;
    end

    // Run tests
    initial begin
		row = 4'b0001;
		col = 4'b0001; #15;
		en = 1; #10;
		en = 0; #10;


		row = 4'b0001;
		col = 4'b0010;
		en = 1; #10;
		en = 0; #10;
		
		row = 4'b0001;
		col = 4'b0100;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0001;
		col = 4'b1000;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0010;
		col = 4'b0001;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0010;
		col = 4'b0010;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0010;
		col = 4'b0100;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0010;
		col = 4'b1000;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0100;
		col = 4'b0001;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0100;
		col = 4'b0010;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0100;
		col = 4'b0100;
		en = 1; #10;
		en = 0; #10;

		row = 4'b0100;
		col = 4'b1000;
		en = 1; #10;
		en = 0; #10;

		row = 4'b1000;
		col = 4'b0001;
		en = 1; #10;
		en = 0; #10;

		row = 4'b1000;
		col = 4'b0010;
		en = 1; #10;
		en = 0; #10;

		row = 4'b1000;
		col = 4'b0100;
		en = 1; #10;
		en = 0; #10;

		row = 4'b1000;
		col = 4'b1000;
		en = 1; #10;
		en = 0; #10;

	end
endmodule