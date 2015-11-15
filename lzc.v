module LZC #(
	parameter width = 8;
	parameter word = 4;
	)(
	input wire CLK,
	input wire RST_N,
	input wire reg MODE,
	input wire reg IVALID,
	input wire reg [width-1:0] DATA,
	output reg OVALID,
	output reg [5:0] ZEROS
);

	parameter INPUT = 1'b0;
	parameter OUTPUT = 1'b1;

	reg state, state_next;
	reg findOne;
	reg [5:0] zero_cnt, word_cnt;

	always @(posedge CLK or negedge RST_N) begin
		if (!RST_N) begin
			state <= INPUT;
			findOne <= 0;
			ZEROS <= 0;
		end	else begin
			state <= state_next;
			ZEROS <= zero_cnt;
		end
	end

	always @* begin
		// turbo mode
		if (MODE) begin
			if (!IVALID) begin
				state_next = INPUT;
			end else begin
				case(state)
					INPUT: begin
						findOne = 0;
						for (i = width-1; i >= 0; i = i - 1) begin
							if (!findOne && DATA[i] == 0) begin
								zero_cnt = zero_cnt + 1;
								state_next = INPUT;
							end else begin
								findOne = 1;
								state_next = OUTPUT;
							end
						end
					end
					OUTPUT: begin
						OVALID = 1;
						zero_cnt = 0;
						state_next = INPUT;
					end
				endcase
			end
		// normal mode
		end else begin
			if (!IVALID) begin
				state_next = INPUT;
			end else begin
				case(state)
					INPUT: begin
						word_cnt = word_cnt + 1;
						if (word_cnt == word) begin
							state_next = OUTPUT;
						end else begin
							state_next = INPUT;
						end
						findOne = 0;
						for (i = width-1; i >= 0; i = i - 1) begin
							if (!findOne && DATA[i] == 0) begin
								zero_cnt = zero_cnt + 1;
							end else begin
								findOne = 1;
							end
						end
					end
					OUTPUT: begin
						OVALID = 1;
						zero_cnt = 0;
						state_next = INPUT;
					end
				endcase
			end
		end
	end

endmodule