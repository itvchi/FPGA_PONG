module lcd_driver (
	input i_clk,
	input [23:0] i_color,
	output o_clk,
	output o_data_enable,
	output [7:0] o_red,
	output [7:0] o_green,
	output [7:0] o_blue,
	output [8:0] o_x,
	output [8:0] o_y
);

wire w_clk;
wire w_data_enable;
wire [8:0] w_col;
wire [8:0] w_row;

	clock_divider #(.INPUT_CLOCK(4), .OUTPUT_CLOCK(1)) clk_div (.i_clk(i_clk), .o_clk(w_clk));
	data_enable DE (.i_clk(w_clk), .o_data_enable(w_data_enable), .o_col(w_col), .o_row(w_row));

	assign o_clk = w_clk;
	assign o_data_enable = w_data_enable;
	
	assign o_x = w_col;
	assign o_y = w_row;
	
	assign o_red = i_color[23:16];
	assign o_green = i_color [15:8];
	assign o_blue = i_color [7:0];

endmodule