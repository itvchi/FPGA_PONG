module PONG_GAME (
	input i_clk,
	output o_clk,
	output o_data_enable, 
	output [7:0] o_red,
	output [7:0] o_green,
	output [7:0] o_blue
);

wire [12:0] w_rom1_address;
wire [5:0] w_rom1_data;
wire [7:0] w_rom2_address;
wire [23:0] w_rom2_data;

wire [23:0] w_rom2_data_b;

wire w_clk;
wire w_data_enable;
wire [23:0] w_color;

wire [8:0] w_x;
wire [8:0] w_y;

wire w_clk_pll;

	PLL pll (i_clk, w_clk_pll);
	//ROM_1PORT background (w_rom1_address, w_clk_pll, w_rom1_data);
	background_generator background (w_clk_pll, 2'b00, w_rom1_address, w_rom1_data);
	ROM_2PORT tiles (.address_a (w_rom2_address), .address_b (w_rom2_address), .clock_a (w_clk_pll), .clock_b (w_clk_pll), .q_a (w_rom2_data), .q_b (w_rom2_data_b));
	layer0 bg (w_clk_pll, w_clk, w_x, w_y, w_rom1_data, w_rom2_data, w_rom1_address, w_rom2_address, w_color);
	lcd_driver lcd (i_clk, w_color, w_clk, w_data_enable, o_red, o_green, o_blue, w_x, w_y);
	
	
	assign o_clk = w_clk;
	assign o_data_enable = w_data_enable;

endmodule