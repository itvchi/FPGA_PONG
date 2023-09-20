module lcd_driver (input i_clk,
				input [23:0] i_color,
				output o_clk,
				output o_data_enable,
				output [7:0] o_red,
				output [7:0] o_green,
				output [7:0] o_blue,
				output [8:0] o_x,
				output [8:0] o_y);
					
wire w_clk;

clock_divider #(.INPUT_CLOCK(4), .OUTPUT_CLOCK(1)) clk_div (.i_clk(i_clk), .o_clk(w_clk));
data_enable DE (.i_clk(w_clk), .o_data_enable(o_data_enable), .o_col(o_x), .o_row(o_y));

assign o_clk = w_clk;
assign {o_red, o_green, o_blue} = i_color;

endmodule