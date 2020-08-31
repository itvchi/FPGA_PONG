module clk_div6 (
	input i_clk,
	output reg o_clk
);

reg [2:0] cnt = 0;

	always @ (posedge i_clk)
	begin
		if(cnt == 3'b110) 
		begin
			o_clk <= ~o_clk;
			cnt <= 0;
		end
		else cnt <= cnt + 3'b001;
	end

endmodule