`define ST  6'h19
`define JMP 6'h1B
`define BEQ 6'h1D
`define BNE 6'h1E

`define PCSEL_BEQ	2'b01
`define PCSEL_JMP	2'b10
`define PCSEL_BNE	2'b11

// module clock_controller(
// 	input  wire clk,
// 	input  wire [31:0] instruction_rfr,
// 	input  wire [31:0] instruction_alu,
// 	input  wire [31:0] instruction_dm,
// 	input  wire [31:0] instruction_rfw,
// 	output reg  [5:0] clk_sequence,
// 	input  wire alive
// );

// 	reg [2:0] sc; // clk_sequence counter
	
// 	always @(posedge(clk)) begin
// 		if(alive) begin
// 			case(sc)
// 				3'd0: clk_sequence <= 6'b000001;
// 				3'd1: clk_sequence <= 6'b000010;
// 				3'd2: clk_sequence <= 6'b000100;
// 				3'd3: clk_sequence <= 6'b001000;
// 				3'd4: clk_sequence <= 6'b010000;
// 				3'd5: clk_sequence <= 6'b100000;
// 			endcase		
			
// 			if(sc == 3'd5) begin
// 				sc <= 3'd0;
// 			end else begin
// 				sc <= sc + 3'd1;
// 			end
// 		end else begin
// 			sc   <= 1'b0;
// 			clk_sequence <= 6'b000001;
// 		end
// 	end
// endmodule


module clock_controller(
	input  wire clk,
	input  wire [31:0] instruction_rfr, // Suffix represent the next stage of the instruction
	input  wire [31:0] instruction_alu,
	input  wire [31:0] instruction_dm,
	input  wire [31:0] instruction_rfw,
	input  wire [31:0] pc_addr,
	output wire [4:0] clk_sequence_out,
	output reg  [1:0] pcsel,
	input  wire alive
);
	reg [4:0] clk_sequence;
	initial clk_sequence = 5'b00001;
	initial pcsel = 2'b00;


	// Detect if the new instruction is EXIT
	wire exit = instruction_rfr[31] & instruction_rfr[30] & instruction_rfr[29] 
				& instruction_rfr[28] & instruction_rfr[27] & instruction_rfr[26];

	// Detect Data Hazard
	wire data_hazard_ra = (instruction_rfr[20:16] != 5'b11111) & 
					   ((instruction_rfr[20:16] == instruction_alu[25:21] & clk_sequence[2] == 1'b1 & instruction_alu[31:26] != 6'h19) |
						(instruction_rfr[20:16] == instruction_dm[25:21]  & clk_sequence[3] == 1'b1 & instruction_dm[31:26]  != 6'h19) |
						(instruction_rfr[20:16] == instruction_rfw[25:21] & clk_sequence[4] == 1'b1 & instruction_rfw[31:26] != 6'h19));
	
	// Only used in betaop operations => instrucion[31:30] == 2'b10
	wire data_hazard_rb = (instruction_rfr[31:30] == 2'b10) & 
					   (instruction_rfr[15:11] != 5'b11111) & 
					   ((instruction_rfr[15:11] == instruction_alu[25:21] & clk_sequence[2] == 1'b1 & instruction_alu[31:26] != 6'h19) |
						(instruction_rfr[15:11] == instruction_dm[25:21]  & clk_sequence[3] == 1'b1 & instruction_dm[31:26]  != 6'h19) |
						(instruction_rfr[15:11] == instruction_rfw[25:21] & clk_sequence[4] == 1'b1 & instruction_rfw[31:26] != 6'h19));

	// Only used in store operation => instrucion[31:26] == 6'h19
	wire data_hazard_rc = (instruction_rfr[31:26] == `ST) & 
					   (instruction_rfr[25:21] != 5'b11111) & 
					   ((instruction_rfr[25:21] == instruction_alu[25:21] & clk_sequence[2] == 1'b1 & instruction_alu[31:26] != 6'h19) |
						(instruction_rfr[25:21] == instruction_dm[25:21]  & clk_sequence[3] == 1'b1 & instruction_dm[31:26]  != 6'h19) |
						(instruction_rfr[25:21] == instruction_rfw[25:21] & clk_sequence[4] == 1'b1 & instruction_rfw[31:26] != 6'h19));
	
	wire data_hazard = data_hazard_ra | data_hazard_rb | data_hazard_rc;

	// Detect Control Hazard
	reg control_hazard_prev;
	reg control_hazard_prev_prev;
	initial control_hazard_prev = 1'b0;
	initial control_hazard_prev_prev = 1'b0;

	wire control_hazard_detection = instruction_rfr[31:26] == `JMP |
									instruction_rfr[31:26] == `BEQ |
									instruction_rfr[31:26] == `BNE ;
	
	wire st_gpu = instruction_rfr[31:26] == `ST;

	wire control_hazard = (control_hazard_detection | st_gpu) 
							& ~control_hazard_prev 
							& ~control_hazard_prev_prev 
							& ~data_hazard; // & ~exit (Implicit)

	wire stall = data_hazard & ~exit;

	assign clk_sequence_out = stall ? {clk_sequence[4:2], 2'b00} :
							  (control_hazard | exit) ? {clk_sequence[4:1], 1'b0} :
							  (control_hazard_prev) ? 
							  	(((pcsel == 2'b10) | (pcsel == `PCSEL_BEQ & pc_addr == 32'd0) | (pcsel == `PCSEL_BNE & pc_addr != 32'd0)) ? 
									{clk_sequence[4:1], 1'b0} :
									{clk_sequence[4:1], 1'b1})
								: clk_sequence;
	
	always @(posedge(clk)) begin
		if(alive) begin
			// clk_sequence[0] Instruction memory + Program Counter
			// clk_sequence[1] Register file (read)
			// clk_sequence[2] ALU
			// clk_sequence[3] Data memory
			// clk_sequence[4] Register file (write)
			
			// Reorganized structure
			if(stall) begin
				// Exit is always false here
				clk_sequence <= {clk_sequence[3:2], 3'b011};
				control_hazard_prev_prev <= 1'b0;
			end else begin
				if(exit) begin
					clk_sequence <= {clk_sequence[3:1], 2'b00};
					control_hazard_prev_prev <= 1'b0;
				end else begin
					if(control_hazard) begin
						clk_sequence <= {clk_sequence[3:1], 2'b00};
						control_hazard_prev_prev <= 1'b0;
					end else begin
						if(control_hazard_prev) begin
							if((pcsel == 2'b10) | (pcsel == `PCSEL_BEQ & pc_addr == 32'd0) | (pcsel == `PCSEL_BNE & pc_addr != 32'd0)) begin
								clk_sequence <= {clk_sequence[3:1], 2'b01};
								control_hazard_prev_prev <= 1'b1;
							end else begin
								clk_sequence <= {clk_sequence[3:1], 2'b11};
								control_hazard_prev_prev <= 1'b0;
							end
						end else begin
							clk_sequence <= {clk_sequence[3:1], 2'b11};
							control_hazard_prev_prev <= 1'b0;
						end
					end
				end
			end

			if(~control_hazard) begin
				pcsel <= 2'b00;
			end else begin
				if(instruction_rfr[31:26] == `JMP) begin
					pcsel <= 2'b10;
				end else begin if(instruction_rfr[31:26] == `BEQ) begin
						pcsel <= 2'b01;
					end else begin if(instruction_rfr[31:26] == `BNE) begin
							pcsel <= 2'b11;
						end else begin
							pcsel <= 2'b00;
						end
					end
				end
			end

			control_hazard_prev <= control_hazard;
			// control_hazard_prev_prev <= control_hazard_prev;
			
			
		end else begin
			clk_sequence <= 5'b00001;
			control_hazard_prev <= 1'b0;
			control_hazard_prev_prev <= 1'b0;
			pcsel <= 2'b00;
		end
	end
endmodule
