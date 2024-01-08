`define ST  6'b011001

// INPUT = OPCODE (6-bit)
// OUTPUT = ra2sel (1-bit)
module control_logic_rfr(
    input [5:0] opcode,
    output ra2sel
);

	// If OPCODE = Store -> ra2sel = 1, else ra2sel = 0
	assign ra2sel = (opcode[5:0] == `ST) ? 1'b1 : 1'b0 ;

endmodule

