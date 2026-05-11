module rom (
    input [3:0] addr,
    output reg [7:0] data
);

    always @(*) begin
        case (addr)
            4'h0: data = 8'b00100001; // MOV A,1
            4'h1: data = 8'b00110010; // MOV B,2
            4'h2: data = 8'b00000001; // ADD A,1
            4'h3: data = 8'b01000000; // OUT A
            4'h4: data = 8'b01100010; // JMP 2
            default: data = 8'b00000000;
        endcase
    end

endmodule
