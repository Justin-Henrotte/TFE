module shifter_unit(
	input wire clk,
	input wire clk_en,
	input wire[4:0] offset_x,
	input wire[4:0] offset_y,
	input wire[127:0] img,
	output reg[127:0] shifted
);
	integer i;
	reg[127:0] tmp;

	always @(posedge clk) begin 
		if(clk_en == 1'b1) begin
			if(offset_x[4] == 1'b0) begin
				for(i = 0; i < 8; i = i + 1) begin
					tmp[i * 16 +: 16] = img[i * 16 +: 16] << {offset_x[3:0], 1'b0};
				end
			end else begin
				for(i = 0; i < 8; i = i + 1) begin
					tmp[i * 16 +: 16] = img[i * 16 +: 16] >> {offset_x[3:0], 1'b0};
				end
			end
			
			if(offset_y[4] == 1'b0) begin
				shifted <= tmp << 16 * offset_y[3:0];
			end else begin
				shifted <= tmp >> 16 * offset_y[3:0];
			end
		end
	end 

endmodule
