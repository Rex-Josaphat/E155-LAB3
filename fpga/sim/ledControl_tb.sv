module ledControl( 
        logic reset,
        logic [3:0] sw1, sw2,
        logic [1:0] onSeg, // Segment enablers, onSeg[0]: Left Display, onSeg[1]: Right Display, 
        logic [4:0] segSum, segSumExpected,
        logic [3:0] sevenSegIn);
        
        // instantiate device under test
        ledControl dut(reset, sw1, sw2, onSeg, segSum, sevenSegIn);

        // Run tests and check results

        /////// Check LED Sum //////
        // There are 256 (16^2) possible combinations of the two displays. Here I run as much as 12 cases only
        initial begin
            sw1 = 4'b0000; sw2 = 4'b0101; segSumExpected = 5'b00101;
            assert (segSum == segSumExpected) else $error("Expected sum = 5: %b. Got %b", segSum, segSumExpected);

            sw1 = 4'b0001; sw2 = 4'b1000; segSumExpected = 5'b01001;
            assert (segSum == segSumExpected) else $error("Expected sum = 9: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1001; sw2 = 4'b0010; segSumExpected = 5'b01011;
            assert (segSum == segSumExpected) else $error("Expected sum = 11: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1110; sw2 = 4'b0011; segSumExpected = 5'b10001;
            assert (segSum == segSumExpected) else $error("Expected sum = 17: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0100; sw2 = 4'b1010; segSumExpected = 5'b01110;
            assert (segSum == segSumExpected) else $error("Expected sum = 14: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0101; sw2 = 4'b0101; segSumExpected = 5'b01010;
            assert (segSum == segSumExpected) else $error("Expected sum = 10: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1101; sw2 = 4'b0110; segSumExpected = 5'b10011;
            assert (segSum == segSumExpected) else $error("Expected sum = 19: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b0111; sw2 = 4'b1011; segSumExpected = 5'b10010;
            assert (segSum == segSumExpected) else $error("Expected sum = 18: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1000; sw2 = 4'b0111; segSumExpected = 5'b01111;
            assert (segSum == segSumExpected) else $error("Expected sum = 15: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1111; sw2 = 4'b1110; segSumExpected = 5'b11101;
            assert (segSum == segSumExpected) else $error("Expected sum = 29: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1101; sw2 = 4'b1010; segSumExpected = 5'b10111;
            assert (segSum == segSumExpected) else $error("Expected sum = 23: %b. Got %b", segSum, segSumExpected);
            
            sw1 = 4'b1011; sw2 = 4'b1100; segSumExpected = 5'b10111;
            assert (segSum == segSumExpected) else $error("Expected sum = 23: %b. Got %b", segSum, segSumExpected);

            $finish;
        end

        /////// Check Switching Logic //////
        
endmodule