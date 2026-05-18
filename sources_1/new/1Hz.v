//1Hz 発生
module gen_1Hz(clk, reset, clk_1Hz);
    input clk, reset;
    output reg clk_1Hz;

    reg[26:0]count;
    always@(posedge clk or posedge reset)begin
        if(reset == 1'b1)begin
            count <= 0;
            clk_1Hz <= 0;
        end else begin
            count <= count + 1'bl;
			if(count == 27'd50_000_000)begin
                clk_1Hz <= ~clk_1Hz;
                count <= 27'b0;
            end
        end
    end
endmodule
