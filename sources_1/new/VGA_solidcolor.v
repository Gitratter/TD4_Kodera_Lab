/*
module VGA_SolidColor(
    input wire clk,
    input wire reset,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync
    );

    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;

    reg [1:0] clk_div;
    reg [9:0] h_count;
    reg [9:0] v_count;

    wire pixel_tick = (clk_div == 2'b11);
    wire active_video = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);

    assign Hsync = ~((h_count >= H_VISIBLE + H_FRONT) &&
                     (h_count <  H_VISIBLE + H_FRONT + H_SYNC));
    assign Vsync = ~((v_count >= V_VISIBLE + V_FRONT) &&
                     (v_count <  V_VISIBLE + V_FRONT + V_SYNC));

    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 2'b00;
        else
            clk_div <= clk_div + 2'b01;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 10'd0;
            v_count <= 10'd0;
        end else if (pixel_tick) begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 10'd0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 10'd0;
                else
                    v_count <= v_count + 10'd1;
            end else begin
                h_count <= h_count + 10'd1;
            end
        end
    end

    always @(*) begin
        if (active_video) begin
            vgaRed   = 4'h0;
            vgaGreen = 4'hF;
            vgaBlue  = 4'h0;
        end else begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h0;
            vgaBlue  = 4'h0;
        end
    end
endmodule
*/


module VGA_Graphics(
    input wire clk,
    input wire reset,
    input wire [31:0] debug_value,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync
    );

    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;

    reg [1:0] clk_div;
    reg [9:0] x;
    reg [9:0] y;

    wire pixel_tick = (clk_div == 2'b11);
    wire active_video = (x < H_VISIBLE) && (y < V_VISIBLE);

    assign Hsync = ~((x >= H_VISIBLE + H_FRONT) &&
                     (x <  H_VISIBLE + H_FRONT + H_SYNC));

    assign Vsync = ~((y >= V_VISIBLE + V_FRONT) &&
                     (y <  V_VISIBLE + V_FRONT + V_SYNC));

    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 2'b00;
        else
            clk_div <= clk_div + 2'b01;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 10'd0;
            y <= 10'd0;
        end else if (pixel_tick) begin
            if (x == H_TOTAL - 1) begin
                x <= 10'd0;
                if (y == V_TOTAL - 1)
                    y <= 10'd0;
                else
                    y <= y + 10'd1;
            end else begin
                x <= x + 10'd1;
            end
        end
    end

    wire border =
        active_video &&
        (x < 10 || x >= 630 || y < 10 || y >= 470);

    wire red_box =
        active_video &&
        (x >= 80 && x < 220 && y >= 100 && y < 190);

    wire blue_box =
        active_video &&
        (x >= 420 && x < 560 && y >= 280 && y < 400);

    wire white_cross =
        active_video &&
        ((x >= 315 && x < 325) || (y >= 235 && y < 245));

    // debug_value[31:0] を画面上部に32個の四角で表示
    wire bit_area =
        active_video &&
        (x >= 64 && x < 576) &&
        (y >= 48 && y < 80);

    wire [9:0] bit_x = x - 10'd64;
    wire [4:0] bit_index = bit_x[8:4];

    wire bit_cell_on = bit_area;
    wire bit_value = debug_value[31 - bit_index];

    wire bit_cell_border =
        bit_cell_on &&
        ((bit_x[3:0] == 4'd0) ||
         (bit_x[3:0] == 4'd15) ||
         (y == 48) ||
         (y == 79));

    always @(*) begin
        if (!active_video) begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h0;
            vgaBlue  = 4'h0;
        end else if (bit_cell_border) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hF;
            vgaBlue  = 4'hF;
        end else if (bit_cell_on && bit_value) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hC;
            vgaBlue  = 4'h0;
        end else if (bit_cell_on) begin
            vgaRed   = 4'h2;
            vgaGreen = 4'h2;
            vgaBlue  = 4'h2;
        end else if (border) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hF;
            vgaBlue  = 4'hF;
        end else if (red_box) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'h0;
            vgaBlue  = 4'h0;
        end else if (blue_box) begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h4;
            vgaBlue  = 4'hF;
        end else if (white_cross) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hF;
            vgaBlue  = 4'hF;
        end else begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h8;
            vgaBlue  = 4'h2;
        end
    end
endmodule



