module cpu(
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

	// Pipeline 1 - IM
	reg [31:0] pc_next_pipe_im;

	// Pipeline 2 - RFR
	reg [31:0] im_data_pipe_rfr;
	reg [31:0] pc_next_pipe_rfr;

	// Pipeline 3 - ALU
	reg [31:0] im_data_pipe_alu;
	reg [31:0] pc_next_pipe_alu;
	reg [31:0] rf_data_r2_pipe_alu;

	// Pipeline 4 - DM
	reg [31:0] im_data_pipe_dm;
	reg [31:0] pc_next_pipe_dm;
	reg [31:0] rf_data_r2_pipe_dm;
	reg [31:0] alu_res_pipe_dm;

	// Pipeline 5 - RFW
	reg [31:0] im_data_pipe_rfw;

	// CONTROL SIGNALS
	wire [1:0] pcsel;
	wire       ra2sel;
	wire       wr;
	wire [1:0] wdsel;
	wire       bsel;
	wire       werf;
	wire [3:0] alufn;

	// CONTROL LOGIC
	// CONTROL LOGIC for Register File (Read)
	control_logic_rfr clogic_rfr(
		.opcode(im_data[31:26]),
		.ra2sel(ra2sel)
	);

	// CONTROL LOGIC for ALU
	control_logic_alu clogic_alu(
		.opcode(im_data_pipe_rfr[31:26]),
		.bsel(bsel),
		.alufn(alufn)
	);

	// CONTROL LOGIC for Data Memory
	control_logic_dm clogic_dm(
		.opcode(im_data_pipe_alu[31:26]),
		.wr(wr)
	);
	assign exported_wren_dm  = wr;

	// CONTROL LOGIC for Register File (Write)
	control_logic_rfw clogic_rfw(
		.opcode(im_data_pipe_dm[31:26]),
		.wdsel(wdsel),
		.werf(werf),
		.wr(exported_wren_rfw)
	);

	// PROGRAM COUNTER
	wire [31:0] pc_curr;
	wire [31:0] pc_next;
	wire [31:0] pc_addr;
	wire [15:0] lit;

	program_counter pc(
		.clk(clk),
		.rst(~alive),
		.clk_en(clk_sequence[0] | pcsel == 2'b10 | (pcsel == 2'b01 & pc_addr == 32'b0) | (pcsel == 2'b11 & pc_addr != 32'b0)),
		.pcsel(pcsel),
		.pc_in(pc_next), // WARNING when branching -> pc_in might have changed -> CHECK THAT
		.offset(im_data_pipe_rfr[15:0]),
		.address(pc_addr),
		.pc_out(pc_curr),
		.pc_next(pc_next)
	);
	
	// INSTRUCTION MEMORY
	wire im_clk_en;
	wire [31:0] im_data;
	assign mau_read_data_im = im_data;
	
	instruction_memory im(
		.clk(clk),
		.cpu_clk_en(clk_sequence[0]),
		.cpu_address(pc_curr),
		.cpu_data_write(32'b0),
		.cpu_wren(1'b0),
		.mau_clk_en(~alive),
		.mau_address(mau_address_im),
		.mau_data_write(mau_write_data_im),
		.mau_wren(mau_wren_im),
		.data_read(im_data),
		.alive(alive)
	);
								 
	// OPERATION SIGNALS
	wire [4:0]  ra;
	wire [4:0]  rb;
	wire [4:0]  rc;
	wire [5:0]  opcode;

	assign lit         = im_data[15:0];
	assign rb          = im_data[15:11];
	assign ra          = im_data[20:16];
	assign rc          = im_data[25:21];
	assign opcode      = im_data[31:26];
	assign halt = im_data_pipe_rfw[31] & im_data_pipe_rfw[30]
					& im_data_pipe_rfw[29] & im_data_pipe_rfw[28]
					& im_data_pipe_rfw[27] & im_data_pipe_rfw[26];

	// REGISTER FILE
	wire [1:0]  rf_clk_en;
	wire [31:0] rf_addr_r1;
	wire [31:0] rf_addr_r2;
	wire [31:0] rf_addr_w;
	wire [31:0] rf_data_w;
	wire [31:0] rf_data_r1;
	wire [31:0] rf_data_r2;

	assign rf_clk_en  = {clk_sequence[4], clk_sequence[1]};
	assign rf_addr_r1 = {25'b0, ra, 2'b0};
	assign rf_addr_r2 = (ra2sel == 1'b0) ? {25'b0, rb, 2'b0} : {25'b0, rc, 2'b0};
	assign rf_addr_w  = {25'b0, im_data_pipe_dm[25:21], 2'b0};
	assign pc_addr    = rf_data_r1;
	
	assign mau_read_data_rf = rf_data_r1; 
	
	register_file rf(
		.clk(clk),
		.cpu_clk_en(rf_clk_en),
		.cpu_read_address1(rf_addr_r1),
		.cpu_read_address2(rf_addr_r2),
		.cpu_write_address(rf_addr_w),
		.cpu_data_write(rf_data_w),
		.cpu_data_read1(rf_data_r1),
		.cpu_data_read2(rf_data_r2),
		.cpu_wren(werf),
		.mau_clk_en(~alive),
		.mau_address(mau_address_rf),
		.mau_data_write(mau_write_data_rf),
		.mau_wren(mau_wren_rf),
		.alive(alive)
	);

	// ALU
	wire [31:0] alu_data_b;
	wire [31:0] alu_res;
	wire [31:0] lit_32;
	
	assign lit_32 = (im_data_pipe_rfr[15] == 1'b0) ? {16'h0000, im_data_pipe_rfr[15:0]} : {16'hffff, im_data_pipe_rfr[15:0]};
	assign alu_data_b = (bsel == 1'b0) ? lit_32 : rf_data_r2;

	alu the_alu(
		.clk(clk),
		.clk_en(clk_sequence[2]),
		.data_a(rf_data_r1),
		.data_b(alu_data_b),
		.alufn(alufn),
		.res(alu_res)
	);

	// DATA MEMORY
	wire [31:0] dm_data_r;
	
	assign mau_read_data_dm     = dm_data_r;
	assign exported_address_dm  = alu_res;
	assign exported_address_rfw = alu_res_pipe_dm;
	assign exported_data_alu    = rf_data_r2;
	assign exported_data_dm     = rf_data_r2_pipe_alu;
	assign exported_data_rfw    = rf_data_r2_pipe_dm;
	
	data_memory dm(
		.clk(clk),
		.cpu_clk_en(clk_sequence[3]),
		.cpu_address(alu_res),
		.cpu_data_write(rf_data_r2_pipe_alu),
		.cpu_wren(wr & (alu_res[31:30] == 2'b00)),
		.mau_clk_en(~alive),
		.mau_address(mau_address_dm),
		.mau_data_write(mau_write_data_dm),
		.mau_wren(mau_wren_dm),
		.data_read(dm_data_r),
		.alive(alive)
   );
	
	wire [31:0] st_data;
	assign st_data = (alu_res_pipe_dm[31:30] == 2'b00) ? dm_data_r : (alu_res_pipe_dm[31:30] == 2'b01) ? io_data : 32'b0;

	assign rf_data_w = (wdsel[1] == 1'b0) ? ((wdsel[0] == 1'b0) ? pc_next_pipe_dm : alu_res_pipe_dm) : st_data;

	clock_controller cc(
		.clk(clk),
		.instruction_rfr(im_data),
		.instruction_alu(im_data_pipe_rfr),
		.instruction_dm(im_data_pipe_alu),
		.instruction_rfw(im_data_pipe_dm),
		.branch_data(rf_data_r1),
		.clk_sequence_out(clk_sequence),
		.pcsel(pcsel),
		.alive(alive)
	);

	always @(posedge(clk)) begin
		if(alive) begin
			// Pipeline 1 - IM
			if (clk_sequence[0] == 1'b1) begin
				pc_next_pipe_im <= pc_next;
			end

			// Pipeline 2 - RFR
			if (clk_sequence[1] == 1'b1) begin
				im_data_pipe_rfr <= im_data;
				pc_next_pipe_rfr <= pc_next_pipe_im;
			end

			// Pipeline 3 - ALU
			if (clk_sequence[2] == 1'b1) begin
				im_data_pipe_alu <= im_data_pipe_rfr;
				pc_next_pipe_alu <= pc_next_pipe_rfr;
				rf_data_r2_pipe_alu <= rf_data_r2;
			end

			// Pipeline 4 - DM
			if (clk_sequence[3] == 1'b1) begin
				im_data_pipe_dm <= im_data_pipe_alu;
				pc_next_pipe_dm <= pc_next_pipe_alu;
				rf_data_r2_pipe_dm <= rf_data_r2_pipe_alu;
				alu_res_pipe_dm <= alu_res;
			end

			// Pipeline 5 - RFW
			if (clk_sequence[4] == 1'b1) begin
				im_data_pipe_rfw <= im_data_pipe_dm;
			end
		end else begin
			// Pipeline 1 - IM
			pc_next_pipe_im <= 32'h0000_0000;

			// Pipeline 2 - RFR
			im_data_pipe_rfr <= 32'h0000_0000;
			pc_next_pipe_rfr <= 32'h0000_0000;

			// Pipeline 3 - ALU
			im_data_pipe_alu <= 32'h0000_0000;
			pc_next_pipe_alu <= 32'h0000_0000;
			rf_data_r2_pipe_alu <= 32'h0000_0000;

			// Pipeline 4 - DM
			im_data_pipe_dm <= 32'h0000_0000;
			pc_next_pipe_dm <= 32'h0000_0000;
			rf_data_r2_pipe_dm <= 32'h0000_0000;
			alu_res_pipe_dm <= 32'h0000_0000;

			// Pipeline 5 - RFW
			im_data_pipe_rfw <= 32'h0000_0000;
		end
	end

endmodule 