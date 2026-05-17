module TOP(
    input CLOCK_50,
    input [3:0] SW,
    output [3:0] LEDR
);

reg [25:0] cnt = 0;

always @(posedge CLOCK_50) begin
    cnt <= cnt + 1;
end

wire slow_clk = cnt[25];

TD4 td4_inst (
    .CLK(slow_clk),
    .IN(SW),
    //.OUT(LEDR)
);

assign LEDR = td4_inst.ADDR;

endmodule 


/*
module TD4_TOP(clk, reset, in, out, clksel, clk_ind);
    input clk, reset, clksel;
    input [3:0]in;
    output reg [3:0]clk_ind;
    output reg [3:0]out = 4'b0000;

    //クロック切替
    wire clk_1Hz, clk_10Hz, clkt;
    assign clkt = (clksel == 1'b1)? clk_10Hz : clk_1Hz;

    //クロック生成
    gen_1Hz gen1 (.clk(clk),.reset(reset), .clk_1Hz(clk_1Hz));
    gen_10Hz gen10 (.clk(clk),.reset(reset), .clk_10Hz(clk_10Hz));

    //プログラムカウンタ・レジスタ関連
    reg [3:0]reg_A = 4'b0000;
    reg [3:0]reg_B = 4'b0000;  //register
    reg [3:0]pcnt = 4'b0000;  //program count
    reg carry_flag;
    wire carry_wire;

    //ROM---------
    wire [7:0] command;
    ROM rom(.pcnt(pcnt), .command(command));

    //Decoder---------
    wire [6:0] instr;
    wire [3:0] opcode = command[7:4];
    wire [3:0] im = command[3:0];
    DECODER decoder(.opcode(opcode), .carry(carry_flag), .instr(instr));
    wire selectB = instr[6];
    wire selectA = instr[5];
    wire LOAD0 = instr[4];
    wire LOAD1 = instr[3];
    wire LOAD2 = instr[2];
    wire LOAD3 = instr[1];
    wire ALUsel = instr[0];

    //Selecter---------
    wire [3:0]select_data;
    SELECTOR selector(.select({selectB, selectA}), .reg_A(reg_A), .reg_B(reg_B), .in(in), .select_data(select_data));

    //ALU----------
    wire [3:0]ALU_data;
    ALU alu(.ALUsel(ALUsel), .select_data(select_data), .im(im), .ALU_data(ALU_data), .carry(carry_wire));

    //Register---------
    always@(posedge clkt or posedge reset)begin
        if(reset)begin
            reg_A <= 0;
            reg_B <= 0;
            out <= 0;
            pcnt <= 0;
            carry_flag <= 0;
        end else begin
            if(~LOAD0)reg_A <= ALU_data;
            if(~LOAD1)reg_B <= ALU_data;
            if(~LOAD2)out <= ALU_data;
            pcnt <= ~LOAD3? ALU_data : pcnt + 1'b1;
            carry_flag <= carry_wire;

            //------clock Indicator
            if(clk_ind >= 4'b1111)
                clk_ind <= 0;
            else
                clk_ind <= clk_ind + 1;
            //------clock Indicator
        end

    end

endmodule //TOP module end---
            


//ROM module
module ROM(pcnt, command);
    input [3:0]pcnt;
    output [7:0]command;

    reg [7:0]rom[0:7];
    initial begin
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


//Decoder
module DECODER(opcode, carry, instr);
    input [3:0]opcode;
    input carry;
    output reg [6:0]instr;
    //instr = selectB, selectA, LOAD0, LOAD1, LOAD2, LOAD3, ALUsel

    always@(*)begin
        case(opcode)
            4'b0011 : instr = 7'b110111x;  //MOV A,Im
            4'b0111 : instr = 7'b111011x;  //MOV B,Im
            4'b0001 : instr = 7'b010111x;  //MOV A,B
            4'b0100 : instr = 7'b001011x;  //MOV B,A
            4'b0000 : instr = 7'b0001110;  //ADD A,Im
            4'b0101 : instr = 7'b0110110;  //ADD B,Im
            4'b1000 : instr = 7'b0001111;  //SUB A,Im
            4'b1101 : instr = 7'b0110111;  //SUB B,Im
            4'b0010 : instr = 7'b100111x;  //IN A
            4'b0110 : instr = 7'b101011x;  //IN B
            4'b1011 : instr = 7'b111101x;  //OUT Im
            4'b1010 : instr = 7'b001101x;  //OUT A 追加
            4'b1001 : instr = 7'b011101x;  //OUT B
            4'b1111 : instr = 7'b111110x;  //JMP Im
            4'b1110 : instr = Carry? 7bxx1111x : 7'b111110x;  //JNC Im
            //default : {selectB,selectA,LOAD0,LOAD1,LOAD2,LOAD3,ALUsel} =7'bxxxxxxx;
        endcase
    end
endmodule


//Selector
module SELECTOR(select, reg_A, reg_B, in, select_data);
    input [1:0]select;
    input [3:0]reg_A;
    input [3:0]reg_B;
    input [3:0]in;
    output reg [3:0]select_data;

    always @(*)begin
        case(select)
            2'b00 : select_data = reg_A;
            2'b01 : select_data = reg_B;
            2'b10 : select_data = in;
            2'b11 : select_data = 4'b0000;
        endcase
    end
endmodule


//ALU
module ALU(ALUsel, select_data, im, ALU_data, carry);
    input ALUsel;
    input [3:0]select_data;
    input [3:0]im;
    output [3:0]ALU_data;
    output carry;

    assign {carry, ALU_data} = ALUsel?(select_data-im):(select_data+im);
endmodule




//1Hz 発生
module gen_1Hz(clk, reset, clk_1Hz);
    input clk, reset;
    output reg clk_1Hz;

    reg[26:0]count;
    always@(posedge clk or posedge reset)begin
        if(reset == 1'b1)begin
            count <= 0;
            clk_1Hz <= 0;
        end else begin
            count <= count + 1'bl;
            if(count == 27'd500000000)begin
                clk_1Hz <= ~clk_1Hz;
                count <= 27'b0;
            end
        end
    end
endmodule

//10Hz発生
module gen_10Hz(clk, reset, clk_10Hz);
    input clk, reset;
    output reg clk_10Hz;

    reg[26:0]count;
    always@(posedge clk or posedge reset)begin
        if(reset == 1'b1)begin
            count <= 0;
            clk_10Hz <= 0;
        end else begin
            count <= count + 1'bl;
            if(count == 27'd500000000)begin
                clk_10Hz <= ~clk_10Hz;
                count <= 27'b0;
            end
        end
    end
endmodule







    

    

















    
