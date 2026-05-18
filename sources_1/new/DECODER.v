module DECODER(opcode, carry, instr);
    input [3:0]opcode;
    input carry;
    output reg [6:0]instr;
    //instr = selectB, selectA, LOAD0, LOAD1, LOAD2, LOAD3, ALUsel

    always@(*)begin
        case(opcode)
            4'b0011 : instr = 7'b1101110;  //MOV A,Im
            4'b0111 : instr = 7'b1110110;  //MOV B,Im
            4'b0001 : instr = 7'b0101110;  //MOV A,B
            4'b0100 : instr = 7'b0010110;  //MOV B,A
            4'b0000 : instr = 7'b0001110;  //ADD A,Im
            4'b0101 : instr = 7'b0110110;  //ADD B,Im
            4'b1000 : instr = 7'b0001111;  //SUB A,Im
            4'b1101 : instr = 7'b0110111;  //SUB B,Im
            4'b0010 : instr = 7'b1001110;  //IN A
            4'b0110 : instr = 7'b1010110;  //IN B
            4'b1011 : instr = 7'b1111010;  //OUT Im
            4'b1010 : instr = 7'b0011010;  //OUT A 追加
            4'b1001 : instr = 7'b0111010;  //OUT B
            4'b1111 : instr = 7'b1111100;  //JMP Im
            4'b1110 : instr = carry ? 7'b1111110 : 7'b1111100;  //JNC Im
            default : instr = 7'b1111110;
            //default : {selectB,selectA,LOAD0,LOAD1,LOAD2,LOAD3,ALUsel} =7'bxxxxxxx;
        endcase
    end
endmodule
