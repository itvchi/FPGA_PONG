module clk_div8 (
	input i_clk,
	output o_clk
);

reg [2:0] cnt = 0;

	always @ (posedge i_clk)
	begin
		cnt <= cnt + 1;
	end
	
	assign o_clk = cnt[2];

endmodule