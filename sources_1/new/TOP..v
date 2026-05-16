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

    //clk switch
    wire clk_1Hz, clk_10Hz, clkt;
    assign clkt = (clksel == 1'b1)? clk_10Hz : clk_1Hz;

    //clk generate
    gen_1Hz gen1 (.clk(clk),.reset(reset), .clk_1Hz(clk_1Hz));
    gen_10Hz gen10 (.clk(clk),.reset(reset), .clk_10Hz(clk_10Hz));

    //pg counter reg
    reg


















    
