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
	reg state, state_next;
	reg findOne, flag;
	reg [8:0] zero_cnt, zero_next;
	reg [5:0] word_cnt, word_next, WORDS;
	reg xor_value;

	always @* begin
		xor_value = ^DATA;
	end

	always @(posedge CLK or negedge RST_N) begin
		if (!RST_N) begin
			state <= INPUT;
			findOne <= 0;
			zero_cnt <= 0;
			zero_next <= 0;
			ZEROS <= 0;
			OVALID <= 0;
			word_cnt <= 0;
			word_next <= 0;
			WORDS <= 0;
			i <= 0;
			flag <= 0;
		end	else begin
			state <= state_next;
			if (IVALID) begin
				WORDS <= WORDS + word_next;
			end
			if (IVALID && (!findOne || flag)) begin
				ZEROS <= ZEROS + zero_next;
				flag <= 0;
			end
			if (state == OUTPUT && state_next == INPUT) begin
				ZEROS <= zero_next;
				WORDS <= 0;
				findOne <= 0;
			end
		end
	end

	always @* begin
		if (IVALID) begin
			zero_cnt = 0;
			word_cnt = 1;
			for (i = width-1; i >= 0; i = i - 1) begin
				if (!findOne && DATA[i] == 0) begin
					zero_cnt = zero_cnt + 1;
				end else begin
					findOne = 1;
					flag = 1;
				end
			end
			i = 0;
		end else begin
			zero_cnt = 0;
			word_cnt = 0;
		end
	end

	always @* begin
		case (state)
			INPUT: begin
				OVALID = 0;
				zero_next = zero_cnt;
				if (MODE) begin
					if (!IVALID || (xor_value !== 1 && xor_value !== 0)) begin
						state_next = INPUT;
					end else begin
						word_next = word_cnt;
						if (findOne || WORDS == word - 1) begin
							state_next = OUTPUT;
						end else begin
							state_next = INPUT;
						end
					end
				end else begin
					if (!IVALID || (xor_value !== 1 && xor_value !== 0)) begin
						state_next = INPUT;
					end else begin
						word_next = word_cnt;
						if (WORDS == word - 1) begin
							state_next = OUTPUT;
						end else begin
							state_next = INPUT;
						end
					end
				end
			end
			OUTPUT: begin
				OVALID = 1;
				zero_next = 0;
				state_next = INPUT;
			end
		endcase
	end
	
endmodule
