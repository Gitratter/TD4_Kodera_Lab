module TD4_TOP(clk, reset, in, out, clksel, clk_ind, seg, an);
    input clk, reset, clksel;
    input [3:0]in;
    output reg [3:0]clk_ind;
    output reg [3:0]out;
    output [6:0] seg;
    output [3:0] an;
    
    assign an = 4'b1110;
    
    /*
    //クロック切替
    wire clk_1Hz, clk_10Hz, clkt;
    assign clkt = (clksel == 1'b1)? clk_10Hz : clk_1Hz;

    //クロック生成
    gen_1Hz gen1 (.clk(clk),.reset(reset), .clk_1Hz(clk_1Hz));
    gen_10Hz gen10 (.clk(clk),.reset(reset), .clk_10Hz(clk_10Hz));

    */
    
    
    //==================================================
    // Enable Signal
    //==================================================
    wire enable_1Hz;
    wire enable_10Hz;
    wire enable_cpu;

    assign enable_cpu = (clksel) ? enable_10Hz : enable_1Hz;

    gen_1Hz_enable gen1(
        .clk(clk),
        .reset(reset),
        .enable_1Hz(enable_1Hz)
    );

    gen_10Hz_enable gen10(
        .clk(clk),
        .reset(reset),
        .enable_10Hz(enable_10Hz)
    );
    
    //==================================================
    // Register
    //==================================================
    reg [3:0]reg_A;
    reg [3:0]reg_B;  //register
    reg [3:0]pcnt;  //program count
    reg carry_flag;
    wire carry_wire;

    //==================================================
    // ROM
    //==================================================
    wire [7:0] command;
    ROM rom(.pcnt(pcnt), .command(command));

    //==================================================
    // Decoder
    //==================================================
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

    //==================================================
    // Selector
    //==================================================
    wire [3:0]select_data;
    SELECTOR selector(.select({selectB, selectA}), .reg_A(reg_A), .reg_B(reg_B), .in(in), .select_data(select_data));

    //==================================================
    // ALU
    //==================================================
    wire [3:0]ALU_data;
    ALU alu(.ALUsel(ALUsel), .select_data(select_data), .im(im), .ALU_data(ALU_data), .carry(carry_wire));


    SEG7 seg7(.data(out),.seg(seg));


    //==================================================
    // CPU Register Update
    //==================================================
    always@(posedge clk or posedge reset)begin
        if(reset)begin
            reg_A      <= 4'b0000;
            reg_B      <= 4'b0000;
            out        <= 4'b0000;
            pcnt       <= 4'b0000;
            carry_flag <= 1'b0;
            clk_ind    <= 4'b0000;

        end

        else if(enable_cpu) begin

            // Register Write

            if(~LOAD0)
                reg_A <= ALU_data;

            if(~LOAD1)
                reg_B <= ALU_data;

            if(~LOAD2)
                out <= ALU_data;

            // Program Counter
            if(~LOAD3)
                pcnt <= ALU_data;
            else
                pcnt <= pcnt + 1'b1;

            // Carry Flag
            carry_flag <= carry_wire;

            //------clock Indicator
            if(clk_ind >= 4'b1111)
                clk_ind <= 4'b0000;
            else
                clk_ind <= clk_ind + 1'b1;
            //------clock Indicator
        end

    end

endmodule //TOP module end---
