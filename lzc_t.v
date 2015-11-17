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

	initial begin
		clk = 1;
		rst_n = 1;
		#(cyc);
		#(delay) rst_n = 0;
		#(cyc*4) rst_n = 1;

		// sample test pattern
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_1011;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_1101;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_0101;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_1101;
		#(cyc) {mode, ivalid, DATA} = 6'b0_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_0100;
		#(cyc) {mode, ivalid, DATA} = 6'b0_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_1001;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_1_0001;
		#(cyc) {mode, ivalid, DATA} = 6'b0_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_1_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b1_0_0000;
		#(cyc) {mode, ivalid, DATA} = 6'b0_0_1000;

		#(cyc*3);

		$finish;
	end

endmodule
