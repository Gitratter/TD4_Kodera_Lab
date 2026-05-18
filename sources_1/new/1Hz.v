//1Hz 発生
module gen_1Hz_enable(clk, reset, enable_1Hz);
    input clk, reset;
    output reg enable_1Hz;

    reg[26:0]count;
    always@(posedge clk or posedge reset)begin
		
        if(reset) begin

            count <= 0;
            enable_1Hz <= 0;
        end
        else begin
            if(count == 27'd50_000_000 - 1) begin

                count <= 0;
                enable_1Hz <= 1'b1;

            end
            else begin
                count <= count + 1'b1;
                enable_1Hz <= 1'b0;
				
            end
        end
    end
endmodule
