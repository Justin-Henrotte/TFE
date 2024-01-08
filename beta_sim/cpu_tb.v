// Run with 
// quartus_sh -t "/home/justin/intelFPGA_lite/22.1std/quartus/common/tcl/internal/nativelink/qnativesim.tcl" --rtl_sim "beta_sim" "beta_sim"

// /// Test OP
// `define INSTR1  32'hC03F_0001
// `define INSTR2  32'hC05F_0002
// `define INSTR3  32'h8081_1800
// `define INSTR4  32'h80A2_1800

// // Test ST
// `define INSTR1  32'hC11F_0010
// `define INSTR2  32'hF108_000F
// `define INSTR3  32'hA508_2000
// `define INSTR4  32'hF108_0006
// `define INSTR5  32'hA508_2800
// `define INSTR6  32'hF108_0003
// `define INSTR7  32'hA508_3000
// `define INSTR8  32'hF108_0003
// `define INSTR9  32'hA508_3800
// `define INSTR10  32'h8121_F800
// `define INSTR11  32'hF129_000C
// `define INSTR12  32'hA529_1800
// `define INSTR13  32'hF129_000C
// `define INSTR14  32'hA529_1000
// `define INSTR15  32'h6528_0000
// `define INSTR16  32'hC028_0001
// `define INSTR17  32'hC049_0001
// `define INSTR18  32'h8081_1800
// `define INSTR19  32'h80A2_1800
// `define INSTR20  32'hFFFF_F800

// Test JMP
// `define INSTR1  32'hC03F_0010
// `define INSTR2  32'h6C41_0000
// `define INSTR3  32'hC07F_0003
// `define INSTR4  32'hC09F_0004
// `define INSTR5  32'hC0A2_0005
// `define INSTR6  32'hC0DF_0006
// `define INSTR7  32'hC0FF_0007

// // Test BEQ
// `define INSTR1  32'hC03F_0000
// `define INSTR2  32'h7441_0001
// `define INSTR3  32'hC062_0003
// `define INSTR4  32'hC11F_0010
// `define INSTR5  32'hC09F_0004
// `define INSTR6  32'hC0BF_0005
// `define INSTR7  32'hC0DF_0006
// `define INSTR8  32'hC0FF_0007

// // Test BEQ 2
// `define INSTR1  32'hC03F_0001
// `define INSTR2  32'hC3FF_0002
// `define INSTR3  32'hC3FF_0003
// `define INSTR4  32'hC3FF_0004
// `define INSTR5  32'hC3FF_0005
// `define INSTR6  32'hC3FF_0006
// `define INSTR7  32'hC3FF_0007
// `define INSTR8  32'h7441_0001
// `define INSTR9  32'hC062_0003
// `define INSTR10 32'hC11F_0010
// `define INSTR11 32'hC09F_0004
// `define INSTR12 32'hC0BF_0005
// `define INSTR13 32'hC0DF_0006
// `define INSTR14 32'hC0FF_0007

// // Test Factorial Loop
// `define INSTR1  32'h77FF_0000
// `define INSTR2  32'hC03F_0005 // Init
// `define INSTR3  32'hC05F_0001
// `define INSTR4  32'h77E1_0003
// `define INSTR5  32'h8841_1000
// `define INSTR6  32'hC421_0001
// `define INSTR7  32'h77FF_FFFC
// `define INSTR8  32'hC002_0000

// // Test Factorial Rec
`define INSTR1  32'h77ff0019
`define INSTR2  32'hc3bd0004
`define INSTR3  32'h679dfffc
`define INSTR4  32'hc3bd0004
`define INSTR5  32'h677dfffc
`define INSTR6  32'h837df800
`define INSTR7  32'hc3bd0004
`define INSTR8  32'h643dfffc
`define INSTR9  32'h603bfff4
`define INSTR10 32'h77e10007
`define INSTR11 32'hc4010001
`define INSTR12 32'hc3bd0004
`define INSTR13 32'h641dfffc
`define INSTR14 32'h779ffff3
`define INSTR15 32'hc7bd0004
`define INSTR16 32'h88010000
`define INSTR17 32'h77ff0002
`define INSTR18 32'hc01f0001
`define INSTR19 32'h77ff0000
`define INSTR20 32'h603dfffc
`define INSTR21 32'hc3bdfffc
`define INSTR22 32'h637dfffc
`define INSTR23 32'hc3bdfffc
`define INSTR24 32'h639dfffc
`define INSTR25 32'hc3bdfffc
`define INSTR26 32'h6ffc0000
`define INSTR27 32'hc3bd0190
`define INSTR28 32'hc03f0005 // Init
`define INSTR29 32'hc3bd0004
`define INSTR30 32'h643dfffc
`define INSTR31 32'h779fffe2
`define INSTR32 32'hc7bd0004
`define INSTR33 32'hc7bd0190

`define EXIT  32'hFFFF_F800

`timescale 1 ns / 100 ps

module cpu_tb;
	// Input = reg
	// Output = wire
	reg         clk;
	reg  [31:0] mau_address_im;
	wire [31:0] mau_read_data_im;
	reg  [31:0] mau_write_data_im;
	reg         mau_wren_im;
	reg  [31:0] mau_address_dm;
	wire [31:0] mau_read_data_dm;
	reg  [31:0] mau_write_data_dm;
	reg         mau_wren_dm;
	reg  [31:0] mau_address_rf;
	wire [31:0] mau_read_data_rf;
	reg  [31:0] mau_write_data_rf;
	reg         mau_wren_rf;
	reg         alive;
	wire        halt;
	wire [4:0]  clk_sequence;
	wire        exported_wren_dm;
	wire        exported_wren_rfw;
	wire [31:0] exported_data_alu;
	wire [31:0] exported_data_dm;
	wire [31:0] exported_data_rfw;
	wire [31:0] exported_address_dm;
	wire [31:0] exported_address_rfw;
	reg  [31:0] io_data;
	
	parameter stimDelay = 20;
	
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

	always
	#10 clk = ~clk;
	
	initial
	begin
		$display($time, " << Starting Simulation >> ");
		clk = 1'b0;
		mau_address_im = 32'd0;
		mau_write_data_im = 32'd0;
		mau_wren_im = 1'b0;
		mau_address_dm  = 32'd0;
		mau_write_data_dm = 32'd0;
		mau_wren_dm = 1'b0;
		mau_address_rf  = 32'd0;
		mau_write_data_rf = 32'd0;
		mau_wren_rf = 1'b0;
		alive = 1'b0;
		io_data = 32'd0;

		// Program the Instruction Memory
		// /// 4 Instructions
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;
		
		/// 7 Instructions
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_001C; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0020; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;

		// /// 8 Instructions
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_001C; mau_write_data_im = `INSTR8; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0020; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0024; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;

		// /// 14 Instructions
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_001C; mau_write_data_im = `INSTR8; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0020; mau_write_data_im = `INSTR9; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0024; mau_write_data_im = `INSTR10; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0028; mau_write_data_im = `INSTR11; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_002C; mau_write_data_im = `INSTR12; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0030; mau_write_data_im = `INSTR13; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0034; mau_write_data_im = `INSTR14; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0038; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_003C; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;

		// /// 31 Instructions
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_001C; mau_write_data_im = `INSTR8; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0020; mau_write_data_im = `INSTR9; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0024; mau_write_data_im = `INSTR10; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0028; mau_write_data_im = `INSTR11; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_002C; mau_write_data_im = `INSTR12; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0030; mau_write_data_im = `INSTR13; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0034; mau_write_data_im = `INSTR14; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0038; mau_write_data_im = `INSTR15; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_003C; mau_write_data_im = `INSTR16; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0040; mau_write_data_im = `INSTR17; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0044; mau_write_data_im = `INSTR18; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0048; mau_write_data_im = `INSTR19; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_004C; mau_write_data_im = `INSTR20; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0050; mau_write_data_im = `INSTR21; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0054; mau_write_data_im = `INSTR22; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0058; mau_write_data_im = `INSTR23; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_005C; mau_write_data_im = `INSTR24; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0060; mau_write_data_im = `INSTR25; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0064; mau_write_data_im = `INSTR26; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0068; mau_write_data_im = `INSTR27; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_006C; mau_write_data_im = `INSTR28; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0070; mau_write_data_im = `INSTR29; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0074; mau_write_data_im = `INSTR30; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0078; mau_write_data_im = `INSTR31; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_007C; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0080; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;

		// /// 33 Instructions
		#(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_001C; mau_write_data_im = `INSTR8; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0020; mau_write_data_im = `INSTR9; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0024; mau_write_data_im = `INSTR10; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0028; mau_write_data_im = `INSTR11; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_002C; mau_write_data_im = `INSTR12; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0030; mau_write_data_im = `INSTR13; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0034; mau_write_data_im = `INSTR14; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0038; mau_write_data_im = `INSTR15; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_003C; mau_write_data_im = `INSTR16; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0040; mau_write_data_im = `INSTR17; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0044; mau_write_data_im = `INSTR18; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0048; mau_write_data_im = `INSTR19; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_004C; mau_write_data_im = `INSTR20; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0050; mau_write_data_im = `INSTR21; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0054; mau_write_data_im = `INSTR22; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0058; mau_write_data_im = `INSTR23; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_005C; mau_write_data_im = `INSTR24; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0060; mau_write_data_im = `INSTR25; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0064; mau_write_data_im = `INSTR26; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0068; mau_write_data_im = `INSTR27; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_006C; mau_write_data_im = `INSTR28; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0070; mau_write_data_im = `INSTR29; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0074; mau_write_data_im = `INSTR30; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0078; mau_write_data_im = `INSTR31; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_007C; mau_write_data_im = `INSTR32; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0080; mau_write_data_im = `INSTR33; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0084; mau_write_data_im = `EXIT; mau_wren_im = 1'b1;
		#(stimDelay) mau_address_im = 32'h0000_0088; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;

		// Program the Instruction Memory
		// #(stimDelay) mau_address_im = 32'h00000000; mau_write_data_im = `INSTR1; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000004; mau_write_data_im = `INSTR2; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000008; mau_write_data_im = `INSTR3; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000000C; mau_write_data_im = `INSTR4; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000010; mau_write_data_im = `INSTR5; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000014; mau_write_data_im = `INSTR6; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000018; mau_write_data_im = `INSTR7; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000001C; mau_write_data_im = `INSTR8; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000020; mau_write_data_im = `INSTR9; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000024; mau_write_data_im = `INSTR10; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000028; mau_write_data_im = `INSTR11; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000002C; mau_write_data_im = `INSTR12; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000030; mau_write_data_im = `INSTR13; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000034; mau_write_data_im = `INSTR14; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000038; mau_write_data_im = `INSTR15; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000003C; mau_write_data_im = `INSTR16; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000040; mau_write_data_im = `INSTR17; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000044; mau_write_data_im = `INSTR18; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h00000048; mau_write_data_im = `INSTR19; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000004C; mau_write_data_im = `INSTR20; mau_wren_im = 1'b1;
		// #(stimDelay) mau_address_im = 32'h0000_0000; mau_write_data_im = 32'h0; mau_wren_im = 1'b0;
		
		#(stimDelay) alive = 1'b1;
		#(10)
		#(stimDelay)
		#(stimDelay)


		#10000; //Let simulation finish
		$display($time, "<< Simulation Complete >>");
		$stop;
	end
endmodule