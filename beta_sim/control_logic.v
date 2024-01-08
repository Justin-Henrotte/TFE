`define NOP   4'b0000
`define ADD   4'b0001
`define SUB   4'b0010
`define MUL   4'b0011
`define DIV   4'b0100
`define AND   4'b0101
`define OR    4'b0110
`define XOR   4'b0111
`define CMPEQ 4'b1000
`define CMPLT 4'b1001
`define CMPLE 4'b1010
`define SHL   4'b1011
`define SHR   4'b1100
`define SRA   4'b1101

`define LD  6'b011000
`define ST  6'b011001

module control_logic(
    input [5:0] address,
    output [11:0] q
);

	// input	[5:0]  address;
	// output	[11:0]  q;

	// wire [11:0] q;

	assign q[11:0] = (address[5:0] == 6'h18) ? 12'h1A0 : 
					 (address[5:0] == 6'h19) ? 12'h10C : 
					 (address[5:0] == 6'h1B) ? 12'h082 : 
					 (address[5:0] == 6'h1D) ? 12'h081 : 
					 (address[5:0] == 6'h1E) ? 12'h083 : 
					 // OP
					 (address[5:0] == 6'h20) ? 12'h1D0 : 
					 (address[5:0] == 6'h21) ? 12'h2D0 : 
					 (address[5:0] == 6'h22) ? 12'h3D0 : 
					 (address[5:0] == 6'h23) ? 12'h4D0 : 
					 (address[5:0] == 6'h24) ? 12'h8D0 : 
					 (address[5:0] == 6'h25) ? 12'h9D0 : 
					 (address[5:0] == 6'h26) ? 12'hAD0 : 
					 (address[5:0] == 6'h28) ? 12'h5D0 : 
					 (address[5:0] == 6'h29) ? 12'h6D0 : 
					 (address[5:0] == 6'h2A) ? 12'h7D0 : 
					 (address[5:0] == 6'h2C) ? 12'hBD0 : 
					 (address[5:0] == 6'h2D) ? 12'hCD0 : 
					 (address[5:0] == 6'h2E) ? 12'hDD0 : 
					 // OPC
					 (address[5:0] == 6'h30) ? 12'h190 : 
					 (address[5:0] == 6'h31) ? 12'h290 : 
					 (address[5:0] == 6'h32) ? 12'h390 : 
					 (address[5:0] == 6'h33) ? 12'h490 : 
					 (address[5:0] == 6'h34) ? 12'h890 : 
					 (address[5:0] == 6'h35) ? 12'h990 : 
					 (address[5:0] == 6'h36) ? 12'hA90 : 
					 (address[5:0] == 6'h38) ? 12'h590 : 
					 (address[5:0] == 6'h39) ? 12'h690 : 
					 (address[5:0] == 6'h3A) ? 12'h790 : 
					 (address[5:0] == 6'h3C) ? 12'hB90 : 
					 (address[5:0] == 6'h3D) ? 12'hC90 : 
					 (address[5:0] == 6'h3E) ? 12'hD90 : 
					 
					 12'h000 ;
					

endmodule

