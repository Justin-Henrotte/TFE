module shifter(
	input  wire clk,
	input  wire clk_en,
	input  wire[2:0] offset_x,
	input  wire[2:0] offset_y,
	input  wire[127:0] mask,
	output wire[127:0] mask0,
	output wire[127:0] mask1,
	output wire[127:0] mask2,
	output wire[127:0] mask3
);

	shifter_unit shifter0(
		.clk(clk),
		.clk_en(clk_en),
		.offset_x({2'b0, offset_x}),
		.offset_y({2'b0, offset_y}),
		.img(mask),
		.shifted(mask0)
	);

	shifter_unit shifter1(
		.clk(clk),
		.clk_en(clk_en),
		.offset_x({1'b1, (4'b1000 - {1'b0, offset_x})}),
		.offset_y({2'b0, offset_y}),
		.img(mask),
		.shifted(mask1)
	);

	shifter_unit shifter2(
		.clk(clk),
		.clk_en(clk_en),
		.offset_x({2'b0, offset_x}),
		.offset_y({1'b1, (4'b1000 - {1'b0, offset_y})}),
		.img(mask),
		.shifted(mask2)
	);

	shifter_unit shifter3(
		.clk(clk),
		.clk_en(clk_en),
		.offset_x({1'b1, (4'b1000 - {1'b0, offset_x})}),
		.offset_y({1'b1, (4'b1000 - {1'b0, offset_y})}),
		.img(mask),
		.shifted(mask3)
	);

endmodule
