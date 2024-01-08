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

`define TRUE  32'd1
`define FALSE 32'd0


module alu(
	input  wire clk,
	input  wire clk_en,
	input  wire signed[31:0] data_a,
	input  wire signed[31:0] data_b,
	input  wire [3:0]  alufn,
	output reg  [31:0] res
);

	always @(posedge(clk)) begin
		if(clk_en) begin
			case(alufn)
				`ADD    : res <= data_a + data_b;
				`SUB    : res <= data_a - data_b;
				`MUL    : res <= data_a * data_b;
				`DIV    : res <= `FALSE;
				`AND    : res <= data_a & data_b;
				`OR     : res <= data_a | data_b;
				`XOR    : res <= data_a ^ data_b;
				`CMPEQ  : res <= (data_a == data_b) ? `TRUE : `FALSE;
				`CMPLT  : res <= (data_a < data_b) ? `TRUE : `FALSE;
				`CMPLE  : res <= (data_a <= data_b) ? `TRUE : `FALSE;
				`SHL    : res <= data_a << data_b[4:0];
				`SHR    : res <= data_a >> data_b[4:0];
				`SRA    : res <= data_a >>> data_b[4:0];
				default : res <= `FALSE;
			endcase		
		end
	end
endmodule