// Josaphat Ngoga
// jngoga@g.hmc.edu
// 9/13/2025

// This is a testbench to simulate the synchronization, FSM logic, and transisions

module keypadScanner_tb();
        logic clk; 
        logic reset;
        logic [3:0] col, col_async;
        logic [3:0] row;
        logic en;

        // instantiate device under test
	    synchronizer dut1(clk, reset, col_async, col); // synchronizer module

	    keypadScanner dut2(clk, reset, col, row, en);
    
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
	    	col_async = 4'b0000; #10;
	    	col_async = 4'b0001; #10;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b0010; #10;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b0100; #10;

	    	col_async = 4'b0000; #10;
	    	col_async = 4'b1000; #10;
	    end

	
endmodule