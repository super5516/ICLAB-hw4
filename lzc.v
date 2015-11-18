module LZC #(
	parameter width = 8,
	parameter word = 4
	)(
	input wire CLK,
	input wire RST_N,
	input wire MODE,
	input wire IVALID,
	input wire [width-1:0] DATA,
	output reg OVALID,
	output reg [8:0] ZEROS
);

	parameter INPUT = 1'b0;
	parameter OUTPUT = 1'b1;

	integer i;
	wire have_one;
	reg state, state_next;
	reg findOne, flag;
	reg already_have_one;
	reg [8:0] zero_cnt;
	reg [5:0] WORDS;

	assign have_one = (findOne) ? 1 : 0;

	always @(posedge CLK or negedge RST_N) begin
		if (!RST_N) begin
			state <= INPUT;
			ZEROS <= 0;
			OVALID <= 0;
			WORDS <= 0;
			flag <= 0;
			already_have_one <= 0;
		end	else begin
			state <= state_next;
			if (IVALID) begin
				WORDS <= WORDS + 1;
				ZEROS <= ZEROS + ((already_have_one) ? 0 : zero_cnt);
				already_have_one <= (have_one) ? 1 : already_have_one;
			end
			if (state_next == OUTPUT) begin
				OVALID <= 1;
			end else begin
				OVALID <= 0;
			end
			if (state == OUTPUT) begin
				ZEROS <= 0;
				WORDS <= 0;
				already_have_one <= 0;
			end
		end
	end

	always @* begin
		if (IVALID) begin
			zero_cnt = 0;
			findOne = 0;
			for (i = width-1; i >= 0; i = i - 1) begin
				if (!findOne && DATA[i] == 0) begin
					zero_cnt = zero_cnt + 1;
				end else begin
					findOne = 1;
				end
			end
		end
	end

	always @* begin
		case (state)
			INPUT: begin
				if (!IVALID) begin
					state_next = INPUT;
				end else begin
					if ((MODE && (have_one || already_have_one)) || WORDS == word - 1) begin
						state_next = OUTPUT;
					end else begin
						state_next = INPUT;
					end
				end
			end
			OUTPUT: begin
				state_next = INPUT;
			end
		endcase
	end
	
endmodule
