module ROM(pcnt, command);
    input [3:0]pcnt;
    output [7:0]command;

	reg [7:0]rom[0:15];

	integer i;
    initial begin
		
		// Default
        for(i = 0; i < 16; i = i + 1)
            rom[i] = 8'b11110000;

        // Program
        rom[0] = 8'b00000001;  //add regA+1
        rom[1] = 8'b10100000;  //regA out
        rom[2] = 8'b00000001;  //add regA+1
        rom[3] = 8'b10100000;  //regA out
        rom[4] = 8'b00000001;  //add regA+1
        rom[5] = 8'b10100000;  //regA out
        rom[6] = 8'b10000010;  //sub regA-10
        rom[7] = 8'b10100000;  //regA out
		
    end
    assign command = rom[pcnt];
endmodule
