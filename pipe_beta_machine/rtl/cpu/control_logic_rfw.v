`define LD  6'b011000
`define ST  6'b011001

// INPUT = OPCODE (6-bit)
// OUTPUT = wdsel (2-bit)
//          werf (1-bit)
// To export it, we also output wr (1-bit)
module control_logic_rfw(
    input [5:0] opcode,
    output [1:0] wdsel,
    output werf,
	output wr
);

	// wdsel MSB: If OPCODE == LD ->  1, 0 otherwise
	assign wdsel[1] = (opcode[5:0] == `LD) ? 1'b1 : 1'b0 ;

	// wdsel LSB = opcode[5] -> 1 for OP and OPC, 0 otherwise
	assign wdsel[0] = opcode[5];

	// If OPCODE == Store -> werf = 0, else werf = 1
	assign werf = (opcode[5:0] == `ST) ? 1'b0 : 1'b1 ;

	// If OPCODE == Store -> wr = 1, else wr = 0
	assign wr = (opcode[5:0] == `ST) ? 1'b1 : 1'b0 ;

endmodule

