/*
module InstructionMemory(
    input [31:0] Address,        // Input comes from PC
    output [31:0] Instruction    // The 32-bit machine code
    );

    // Create a memory of 64 words (enough for small programs)
    reg [31:0] memory [63:0];

    initial begin
        // This is where you load your program!
        // You can load a hex file using $readmemh, or hardcode simpler tests.
        
        memory[0] = 32'h00500093; 
        
        memory[1] = 32'h00300113;
        
        memory[2] = 32'h002081B3;
        
        memory[3] = 32'h00000063;
    end

    
    assign Instruction = memory[Address[31:2]];

endmodule
*/

module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instruction
    );

    reg [31:0] memory [63:0];

    initial begin
        // x1 = 0x00001000
        // 今のCPUにはLUIがないので、1024を作って2回倍にする
        memory[0]  = 32'h40000093; // addi x1, x0, 1024
        memory[1]  = 32'h001080B3; // add  x1, x1, x1   ; x1 = 2048
        memory[2]  = 32'h001080B3; // add  x1, x1, x1   ; x1 = 4096 = 0x1000

        // VRAM[0]〜VRAM[4] に色を書き込む
        memory[3]  = 32'h00400113; // addi x2, x0, 4
        memory[4]  = 32'h0020A023; // sw   x2, 0(x1)

        memory[5]  = 32'h00100113; // addi x2, x0, 1
        memory[6]  = 32'h0020A223; // sw   x2, 4(x1)

        memory[7]  = 32'h00E00113; // addi x2, x0, 14
        memory[8]  = 32'h0020A423; // sw   x2, 8(x1)

        memory[9]  = 32'h00C00113; // addi x2, x0, 12
        memory[10] = 32'h0020A623; // sw   x2, 12(x1)

        memory[11] = 32'h00F00113; // addi x2, x0, 15
        memory[12] = 32'h0020A823; // sw   x2, 16(x1)

        // 左端に縦線も描く
        // 1行 = 80セル = 320 bytes
        memory[13] = 32'h1420A023; // sw x2, 320(x1)   ; VRAM[80]
        memory[14] = 32'h2820A023; // sw x2, 640(x1)   ; VRAM[160]
        memory[15] = 32'h3C20A023; // sw x2, 960(x1)   ; VRAM[240]
        memory[16] = 32'h5020A023; // sw x2, 1280(x1)  ; VRAM[320]

        // 無限ループ
        memory[17] = 32'h00000063; // beq x0, x0, 0
    end

    assign Instruction = memory[Address[31:2]];

endmodule
