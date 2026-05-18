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
