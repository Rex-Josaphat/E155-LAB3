module lab3_JN( 
        input logic reset,
        input logic [3:0] col_async,
        output logic [3:0] row,
        output logic [1:0] onSeg,
        output logic [6:0] segDisp);

        // instantiate device under test
        lab3_JN dut(reset, col_async, row, onSeg, segDisp);

        // Generate testbench clock
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
       
	    initial begin
	    	col = 4'b0000; #50;
	    	col = 4'b0001; #50;

	    	col = 4'b0000; #50;
	    	col = 4'b0010; #50;

	    	col = 4'b0000; #50;
	    	col = 4'b0100; #50;

	    	col = 4'b0000; #50;
	    	col = 4'b1000; #50;
	    end
endmodule