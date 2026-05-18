//10Hz発生
module gen_10Hz_enable(clk, reset, enable_10Hz);
    input clk, reset;
    output reg enable_10Hz;

    reg[26:0]count;
	
    always@(posedge clk or posedge reset)begin
		
        if(reset) begin
            count <= 0;
            enable_10Hz <= 0;
        end
        else begin

            if(count == 27'd5_000_000 - 1) begin
                count <= 0;
                enable_10Hz <= 1'b1;
            end
            else begin
                count <= count + 1'b1;
                enable_10Hz <= 1'b0;

            end
        end
    end
endmodule
