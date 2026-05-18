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
