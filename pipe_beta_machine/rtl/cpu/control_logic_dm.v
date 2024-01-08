`define ST  6'b011001

// INPUT = OPCODE (6-bit)
// OUTPUT = wr (1-bit)
module control_logic_dm(
    input [5:0] opcode,
    output wr
);

	// If OPCODE = Store -> wr = 1, else wr = 0
	assign wr = (opcode[5:0] == `ST) ? 1'b1 : 1'b0 ;

endmodule

