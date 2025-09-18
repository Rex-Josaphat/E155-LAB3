module lab3_JN();
        logic reset;
		logic clk;
        logic [3:0] col_async;
        logic [3:0] row;
        logic [1:0] onSeg;
        logic [6:0] segDisp;

        // instantiate device under test
        lab3_JN dut(reset, col_async, row, onSeg, segDisp);

        // Generate testbench clock
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

	        col_async = 4'b0000; #50;
	        col_async = 4'b0010; #50;

	        col_async = 4'b0000; #50;
	        col_async = 4'b0100; #50;

	        col_async = 4'b0000; #50;
	        col_async = 4'b1000; #50;
	    end
endmodule