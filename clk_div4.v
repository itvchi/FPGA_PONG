module clk_div4 (
	input i_clk,
	output o_clk
);

reg [1:0] cnt = 0;

	always @ (posedge i_clk)
	begin
		cnt <= cnt + 1;
	end
	
	assign o_clk = cnt[1];

endmodule