module stimulus;
	parameter cyc = 10;
	parameter delay = 1;

	reg clk, rst_n, mode, ivalid;
	reg [`WIDTH-1:0] DATA;
	wire ovalid;
	wire [5:0] zeros;

	reg debug_level;
	reg [8*128-1:0] fsdbfile;

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

	// fsdb filename
	initial begin
		if ($value$plusargs("fsdb=%s", fsdbfile))
			$fsdbDumpfile(fsdbfile);
		else
			$fsdbDumpfile("lzc.fsdb");
		$fsdbDumpvars;
	end

	// debug mode
	initial begin
		if ($value$plusargs("DEBUG=%d", debug_level));
		if (debug_level == 1) begin
			always @(posedge clk) begin
				$display("clk=%d,OVALID=%d,ZEROS=%d", $time, ovalid, zeros);
			end
		end
	end

	initial begin
		#(cyc) rst_n = 0;
		#(cyc*2);
		#(cyc) rst_n = 1;

		// sample test pattern
		#(cyc)1_0_0000
		#(CYC)0_0_1011
		#(cyc)1_1_0000
		#(cyc)1_0_0000
		#(cyc)0_0_1101
		#(cyc)0_0_0101
		#(cyc)0_0_1101
		#(cyc)0_1_0000
		#(cyc)0_0_0100
		#(cyc)0_1_0000
		#(cyc)1_1_0000
		#(cyc)1_0_0000
		#(cyc)0_0_1001
		#(cyc)1_0_0000
		#(cyc)0_1_0001
		#(cyc)0_1_0000
		#(cyc)1_1_0000
		#(cyc)1_0_0000
		#(cyc)1_0_0000
		#(cyc)1_1_0000
		#(cyc)1_1_0000
		#(cyc)1_1_0000
		#(cyc)1_1_0000
		#(cyc)1_0_0000
		#(cyc)0_0_1000

		$finish;
	end

endmodule