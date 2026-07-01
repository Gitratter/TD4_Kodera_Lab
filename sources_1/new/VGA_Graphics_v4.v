module VGA_Graphics(
    input wire clk,
    input wire reset,
    input wire [31:0] debug_value,
    output wire [12:0] vram_addr,
    input wire [7:0] vram_char,
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

    wire [6:0] cell_x = x[9:3];
    wire [5:0] cell_y = y[8:3];
    wire [2:0] font_x = x[2:0];
    wire [2:0] font_y = y[2:0];

    assign vram_addr = (cell_y * 80) + cell_x;

    wire text_pixel = font_pixel(vram_char, font_x, font_y);

    always @(*) begin
        if (!active_video) begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h0;
            vgaBlue  = 4'h0;
        end else if (text_pixel) begin
            vgaRed   = 4'hF;
            vgaGreen = 4'hF;
            vgaBlue  = 4'hF;
        end else begin
            vgaRed   = 4'h0;
            vgaGreen = 4'h2;
            vgaBlue  = 4'h5;
        end
    end

    function font_pixel;
        input [7:0] ch;
        input [2:0] fx;
        input [2:0] fy;
        reg [7:0] row;
        begin
            row = 8'b00000000;

            case (ch)
                8'h48: begin // H
                    case (fy)
                        0: row = 8'b10000001;
                        1: row = 8'b10000001;
                        2: row = 8'b10000001;
                        3: row = 8'b11111111;
                        4: row = 8'b10000001;
                        5: row = 8'b10000001;
                        6: row = 8'b10000001;
                        7: row = 8'b10000001;
                    endcase
                end

                8'h45: begin // E
                    case (fy)
                        0: row = 8'b11111111;
                        1: row = 8'b10000000;
                        2: row = 8'b10000000;
                        3: row = 8'b11111100;
                        4: row = 8'b10000000;
                        5: row = 8'b10000000;
                        6: row = 8'b10000000;
                        7: row = 8'b11111111;
                    endcase
                end

                8'h4C: begin // L
                    case (fy)
                        0: row = 8'b10000000;
                        1: row = 8'b10000000;
                        2: row = 8'b10000000;
                        3: row = 8'b10000000;
                        4: row = 8'b10000000;
                        5: row = 8'b10000000;
                        6: row = 8'b10000000;
                        7: row = 8'b11111111;
                    endcase
                end

                8'h4F: begin // O
                    case (fy)
                        0: row = 8'b01111110;
                        1: row = 8'b10000001;
                        2: row = 8'b10000001;
                        3: row = 8'b10000001;
                        4: row = 8'b10000001;
                        5: row = 8'b10000001;
                        6: row = 8'b10000001;
                        7: row = 8'b01111110;
                    endcase
                end

                default: row = 8'b00000000;
            endcase

            font_pixel = row[7 - fx];
        end
    endfunction
endmodule
