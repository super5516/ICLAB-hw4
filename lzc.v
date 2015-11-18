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
	reg [8:0] zero_cnt;
	reg [5:0] WORDS;

	always @(posedge CLK or negedge RST_N) begin
		if (!RST_N) begin
			state <= INPUT;
			findOne <= 0;
			zero_cnt <= 0;
			ZEROS <= 0;
			OVALID <= 0;
			WORDS <= 0;
			flag <= 0;
		end	else begin
			state <= state_next;
			if (IVALID) begin
				WORDS <= WORDS + 1;
				ZEROS <= zero_cnt;
			end
			if (state == OUTPUT && state_next == INPUT) begin
				ZEROS <= 0;
				WORDS <= 0;
			end
		end
	end

	always @(posedge CLK) begin
		if (IVALID) begin
			for (i = width-1; i >= 0; i = i - 1) begin
				if (!findOne && DATA[i] == 0) begin
					zero_cnt = zero_cnt + 1;
				end else begin
					findOne = 1;
				end
			end
		end
		if (state == OUTPUT && state_next == INPUT) begin
			findOne = 0;
			zero_cnt = 0;
		end
	end

	always @* begin
		case (state)
			INPUT: begin
				OVALID = 0;
				if (!IVALID) begin
					state_next = INPUT;
				end else begin
					if ((MODE && findOne) || WORDS == word - 1) begin
						state_next = OUTPUT;
					end else begin
						state_next = INPUT;
					end
				end
			end
			OUTPUT: begin
				OVALID = 1;
				state_next = INPUT;
			end
		endcase
	end
	
endmodule
