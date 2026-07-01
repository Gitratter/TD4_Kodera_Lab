module VideoRAM(
    input wire clk,

    input wire [12:0] read_addr,
    output wire [3:0] read_color,

    input wire write_enable,
    input wire [12:0] write_addr,
    input wire [3:0] write_color
    );

    reg [3:0] mem [0:4799];
    integer i;

    initial begin
        for (i = 0; i < 4800; i = i + 1) begin
            if (i < 800)
                mem[i] = 4'h4;
            else if (i < 1600)
                mem[i] = 4'h2;
            else if (i < 2400)
                mem[i] = 4'h1;
            else if (i < 3200)
                mem[i] = 4'hE;
            else if (i < 4000)
                mem[i] = 4'hC;
            else
                mem[i] = 4'h9;
        end
    end

    assign read_color = mem[read_addr];

    always @(posedge clk) begin
        if (write_enable) begin
            mem[write_addr] <= write_color;
        end
    end
endmodule
