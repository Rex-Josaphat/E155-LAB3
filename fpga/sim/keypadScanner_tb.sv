// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/13/2025

// This is a testbench to simulate the synchronization, FSM logic, and transisions

module keypadScanner_tb();
        logic clk; 
        logic reset;
        logic [3:0] col, col_async;
        logic [3:0] row, rowScan;
        logic en;

        // instantiate device under test
	    synchronizer dut1(clk, reset, col_async, col); // synchronizer module

	    keypadScanner dut2(clk, reset, col, rowScan, row, en);
    
        // generate clock
	    always begin
	    	clk = 0; #5;
	    	clk = 1; #5;
	    end
        
        // Pulse the reset at start of tests 
        initial begin
            reset = 1; #20; 
            reset = 0; #20;
            reset = 1; #20; 
        end

	    initial begin
	    	col_async = 4'b0000; #50;
	    	col_async = 4'b0001; #50;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b0010; #50;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b0100; #50;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b1000; #50;

			col_async = 4'b0000; #50;
	    	col_async = 4'b1100; #50; // Bad input: Do not register

			col_async = 4'b0100; #50;
			col_async = 4'b1010; #50; // Bad input: Do not register

			col_async = 4'b0000; #50;
			col_async = 4'b1001; #50; // Bad input: Do not register

			col_async = 4'b0100; #50; // Col Switch: No button release
			col_async = 4'b1000; #50;

			col_async = 4'b0011; #50; // Bad input: test release-hold (2 cols)
			col_async = 4'b0001; #50;

			col_async = 4'b1011; #50; // Bad input: test release-hold (3 cols)
			col_async = 4'b1000; #50;
	    end

	
endmodule