module beta_sim(
	clk,
	mau_address_im,
	mau_read_data_im,
	mau_write_data_im,
	mau_wren_im,
	mau_address_dm,
	mau_read_data_dm,
	mau_write_data_dm,
	mau_wren_dm,
	mau_address_rf,
	mau_read_data_rf,
	mau_write_data_rf,
	mau_wren_rf,
	alive,
	halt,
	clk_sequence,
	exported_wren_dm,
	exported_wren_rfw,
	exported_data_alu,
	exported_data_dm,
	exported_data_rfw,
	exported_address_dm,
	exported_address_rfw,
	io_data
);

	input  wire        clk;
	input  wire [31:0] mau_address_im;
	output wire [31:0] mau_read_data_im;
	input  wire [31:0] mau_write_data_im;
	input  wire        mau_wren_im;
	input  wire [31:0] mau_address_dm;
	output wire [31:0] mau_read_data_dm;
	input  wire [31:0] mau_write_data_dm;
	input  wire        mau_wren_dm;
	input  wire [31:0] mau_address_rf;
	output wire [31:0] mau_read_data_rf;
	input  wire [31:0] mau_write_data_rf;
	input  wire        mau_wren_rf;
	input  wire        alive;
	output wire        halt;
	output wire [4:0]  clk_sequence;
	output wire        exported_wren_dm;
	output wire        exported_wren_rfw;
	output wire [31:0] exported_data_alu;
	output wire [31:0] exported_data_dm;
	output wire [31:0] exported_data_rfw;
	output wire [31:0] exported_address_dm;
	output wire [31:0] exported_address_rfw;
	input  wire [31:0] io_data;

	cpu beta_cpu(
		.clk(clk),
		.mau_address_im(mau_address_im),
		.mau_read_data_im(mau_read_data_im),
		.mau_write_data_im(mau_write_data_im),
		.mau_wren_im(mau_wren_im),
		.mau_address_dm(mau_address_dm),
		.mau_read_data_dm(mau_read_data_dm),
		.mau_write_data_dm(mau_write_data_dm),
		.mau_wren_dm(mau_wren_dm),
		.mau_address_rf(mau_address_rf),
		.mau_read_data_rf(mau_read_data_rf),
		.mau_write_data_rf(mau_write_data_rf),
		.mau_wren_rf(mau_wren_rf),
		.alive(alive),
		.halt(halt),
		.clk_sequence(clk_sequence),
		.exported_wren_dm(exported_wren_dm),
		.exported_wren_rfw(exported_wren_rfw),
		.exported_data_alu(exported_data_alu),
		.exported_data_dm(exported_data_dm),
		.exported_data_rfw(exported_data_rfw),
		.exported_address_dm(exported_address_dm),
		.exported_address_rfw(exported_address_rfw),
		.io_data(io_data)
	);

endmodule 