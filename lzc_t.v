module stimulus;
	parameter cyc = 10;
	parameter delay = 1;

	reg clk, rst_n, mode, ivalid;
	reg [`WIDTH-1:0] DATA;
	wire ovalid;
	wire [5:0] zeros;

	reg debug_level;
	reg [8*128-1:0] fsdbfile, test_input, test_golden;
	reg [`WIDTH+1:0] test_input_vector;
	reg [5:0] test_golden_vector;

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

	// test pattern
	initial begin
		if ($value$plusargs("pattern=%s", test_input));
			$readmemb(test_input, test_input_vector);
		if ($value$plusargs("golden=%s", test_golden));
			$readmemb(test_golden, test_golden_vector);
	end

	// apply pattern task
	task apply_pattern;
		output [5:0] result;
		input [`WIDTH+1:0] pattern;
		begin
			{mode, ivalid, DATA} = pattern;
		end
	endtask

endmodule