module VGA_Graphics(
    input wire clk,
    input wire reset,
    input wire [31:0] debug_value,
    
    output wire [12:0] vram_addr,
    input wire [3:0] vram_color,
    
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output wire Hsync,
    output wire Vsync
    );

    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_TOTAL   = 800;

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
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
        (x >= 80 && x < 220 && y >= 120 && y < 210);

    wire blue_box =
        active_video &&
        (x >= 420 && x < 560 && y >= 280 && y < 400);

    wire white_cross =
        active_video &&
        ((x >= 315 && x < 325) || (y >= 235 && y < 245));



    wire [6:0] cell_x = x[9:3];
    wire [5:0] cell_y = y[8:3];

    assign vram_addr = (cell_y * 80) + cell_x;




    wire hex_pixel;

    Hex32Text hex_display (
        .x(x),
        .y(y),
        .value(debug_value),
        .pixel(hex_pixel)
    );




    reg [3:0] bgRed;
    reg [3:0] bgGreen;
    reg [3:0] bgBlue;

    always @(*) begin
        case (vram_color)
            4'h0: begin bgRed = 4'h0; bgGreen = 4'h0; bgBlue = 4'h0; end
            4'h1: begin bgRed = 4'h0; bgGreen = 4'h0; bgBlue = 4'hA; end
            4'h2: begin bgRed = 4'h0; bgGreen = 4'hA; bgBlue = 4'h0; end
            4'h3: begin bgRed = 4'h0; bgGreen = 4'hA; bgBlue = 4'hA; end
            4'h4: begin bgRed = 4'hA; bgGreen = 4'h0; bgBlue = 4'h0; end
            4'h5: begin bgRed = 4'hA; bgGreen = 4'h0; bgBlue = 4'hA; end
            4'h6: begin bgRed = 4'hA; bgGreen = 4'h5; bgBlue = 4'h0; end
            4'h7: begin bgRed = 4'hA; bgGreen = 4'hA; bgBlue = 4'hA; end
            4'h8: begin bgRed = 4'h5; bgGreen = 4'h5; bgBlue = 4'h5; end
            4'h9: begin bgRed = 4'h5; bgGreen = 4'h5; bgBlue = 4'hF; end
            4'hA: begin bgRed = 4'h5; bgGreen = 4'hF; bgBlue = 4'h5; end
            4'hB: begin bgRed = 4'h5; bgGreen = 4'hF; bgBlue = 4'hF; end
            4'hC: begin bgRed = 4'hF; bgGreen = 4'h5; bgBlue = 4'h5; end
            4'hD: begin bgRed = 4'hF; bgGreen = 4'h5; bgBlue = 4'hF; end
            4'hE: begin bgRed = 4'hF; bgGreen = 4'hF; bgBlue = 4'h5; end
            default: begin bgRed = 4'hF; bgGreen = 4'hF; bgBlue = 4'hF; end
        endcase
    end






    always @(*) begin
        if (!active_video) begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h0;
            vgaBlue  = 4'h0;
        end else if (hex_pixel) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hF;
            vgaBlue  = 4'h0;
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
            vgaRed   = bgRed;
            vgaGreen = bgGreen;
            vgaBlue  = bgBlue;
        end
    end
endmodule


module Hex32Text(
    input wire [9:0] x,
    input wire [9:0] y,
    input wire [31:0] value,
    output reg pixel
    );

    localparam ORIGIN_X = 96;
    localparam ORIGIN_Y = 40;
    localparam DIGIT_W  = 32;
    localparam DIGIT_H  = 48;
    localparam SEG_T    = 5;

    wire in_area =
        (x >= ORIGIN_X) &&
        (x < ORIGIN_X + DIGIT_W * 8) &&
        (y >= ORIGIN_Y) &&
        (y < ORIGIN_Y + DIGIT_H);

    wire [9:0] hex_x = x - ORIGIN_X;
    wire [9:0] hex_y = y - ORIGIN_Y;

    wire [2:0] digit_index = hex_x[7:5];
    wire [4:0] local_x = hex_x[4:0];
    wire [5:0] local_y = hex_y[5:0];

    reg [3:0] nibble;
    reg [6:0] seg;

    always @(*) begin
        case (digit_index)
            3'd0: nibble = value[31:28];
            3'd1: nibble = value[27:24];
            3'd2: nibble = value[23:20];
            3'd3: nibble = value[19:16];
            3'd4: nibble = value[15:12];
            3'd5: nibble = value[11:8];
            3'd6: nibble = value[7:4];
            default: nibble = value[3:0];
        endcase

        case (nibble)
            4'h0: seg = 7'b1110111;
            4'h1: seg = 7'b0010010;
            4'h2: seg = 7'b1011101;
            4'h3: seg = 7'b1011011;
            4'h4: seg = 7'b0111010;
            4'h5: seg = 7'b1101011;
            4'h6: seg = 7'b1101111;
            4'h7: seg = 7'b1010010;
            4'h8: seg = 7'b1111111;
            4'h9: seg = 7'b1111011;
            4'hA: seg = 7'b1111110;
            4'hB: seg = 7'b0101111;
            4'hC: seg = 7'b1100101;
            4'hD: seg = 7'b0011111;
            4'hE: seg = 7'b1101101;
            default: seg = 7'b1101100;
        endcase

        pixel = in_area && (
            (seg[6] && local_y < SEG_T && local_x >= SEG_T && local_x < DIGIT_W - SEG_T) ||
            (seg[5] && local_x < SEG_T && local_y >= SEG_T && local_y < DIGIT_H / 2) ||
            (seg[4] && local_x >= DIGIT_W - SEG_T && local_y >= SEG_T && local_y < DIGIT_H / 2) ||
            (seg[3] && local_y >= 22 && local_y < 27 && local_x >= SEG_T && local_x < DIGIT_W - SEG_T) ||
            (seg[2] && local_x < SEG_T && local_y >= DIGIT_H / 2 && local_y < DIGIT_H - SEG_T) ||
            (seg[1] && local_x >= DIGIT_W - SEG_T && local_y >= DIGIT_H / 2 && local_y < DIGIT_H - SEG_T) ||
            (seg[0] && local_y >= DIGIT_H - SEG_T && local_x >= SEG_T && local_x < DIGIT_W - SEG_T)
        );
    end
endmodule
