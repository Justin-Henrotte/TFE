// INPUT = OPCODE (6-bit)
// OUTPUT = bsel (1-bit)
//          alufn (4-bit)
module control_logic_alu(
    input [5:0] opcode,
    output bsel,
    output [3:0] alufn
);

	// bsel = directly the inverse of the fifth bit
	assign bsel = ~opcode[4];

    // If OPCODE is OP or OPC, alufn = OPCODE[3:0], else alufn = 0 (Correspond to the ADD operation)
    assign alufn[3:0] = (opcode[5] == 1'b1) ? opcode[3:0] : 4'h0 ;

endmodule

