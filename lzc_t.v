module stimulus;
	parameter cyc = 10;
	parameter delay = 1;

	reg clk, rst_n, mode, ivalid;
	reg [`WIDTH-1:0] DATA;
	wire ovalid;
	wire [5:0] zeros;

	LZC #(
		.width(`WIDTH),
		.word(`WORD))
	lzc1 (
		.CLK(clk),
		.RST_N(rst_n),
		.MODE(mode),
		.IVALID(ivalid),
		.DATA(DATA),
		.OVALID(ovalid),
		.ZEROS(zeros)
	);

	always #(cyc/2) clk = ~clk;

	initial begin
		$fsdbDumpfile("lzc.fsdb");
		$fsdbDumpvars;
	end

endmodule