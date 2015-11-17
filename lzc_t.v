module stimulus;
	parameter cyc = 10;
	parameter delay = 1;

	reg clk, rst_n, mode, ivalid;
	reg [`WIDTH-1:0] DATA;
	wire ovalid;
	wire [8:0] zeros;

	reg debug_level;
	reg [8*128-1:0] fsdbfile, inputfile, goldenfile;
	reg [`WIDTH+1:0] input_vector[0:30000];
	reg [8:0] golden_vector[0:30000];

	integer i, j, error;

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
		if ($value$plusargs("fsdbfile=%s", fsdbfile)) begin
			$fsdbDumpfile(fsdbfile);
		end else begin
			$fsdbDumpfile("lzc.fsdb");
		end
		$fsdbDumpvars;
	end

	// debug mode
	initial begin
		if ($value$plusargs("DEBUG=%d", debug_level)) begin
			if (debug_level == 1) begin
				$monitor("clk=%d,OVALID=%b,ZEROS=%d", $time, ovalid, zeros);
			end
		end
	end

	// test pattern
	initial begin
		if ($value$plusargs("pattern=%s", inputfile)) begin
			$readmemb(inputfile, input_vector);
		end
		if ($value$plusargs("golden=%s", goldenfile)) begin
			$readmemb(goldenfile, golden_vector);
		end
	end

	// testbench
	initial begin
		clk = 1;
		rst_n = 1;
		j = 0;
		error = 0;
		#(cyc);
		#(delay) rst_n = 0;
		#(cyc*4) rst_n = 1;

		for (i = 0; i < 30000; i = i + 1) begin
			#(cyc) apply_pattern(input_vector[i]);
		end

		#(cyc*3);

		$display("%d errors in %s", error, inputfile);

		$finish;
	end

	// count error
	always @(posedge clk) begin
		if (ovalid) begin
			if (zeros != golden_vector[j]) begin
				error = error + 1;
			end
			j = j + 1;
		end
	end

	// apply pattern task
	task apply_pattern;
		input [`WIDTH+1:0] pattern;
		begin
			{mode, ivalid, DATA} = pattern;
		end
	endtask

endmodule
