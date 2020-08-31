`timescale 1ns/10ps
module tb;

reg clk = 0;


wire [12:0] w_rom1_address;
wire [5:0] w_rom1_data;
wire [7:0] w_rom2_address;
wire [23:0] w_rom2_data;

wire w_clk;
wire w_data_enable;
wire [23:0] w_color;

wire [8:0] w_x;
wire [8:0] w_y;

wire w_clk_pll;

wire [7:0] w_red;
wire [7:0] w_green;
wire [7:0] w_blue;

	PLL pll (clk, w_clk_pll);
	ROM_1PORT background (w_rom1_address, w_clk_pll, w_rom1_data);
	ROM_2PORT tiles (.address_a (w_rom2_address), .clock_a (w_clk_pll), .q_a (w_rom2_data));
	layer1 bg (w_clk_pll, w_clk, w_x, w_y, w_rom1_data, w_rom2_data, w_rom1_address, w_rom2_address, w_color);
	lcd_driver lcd (clk, w_color, w_clk, w_data_enable, w_red, w_green, w_blue, w_x, w_y);
	
	
always  #10 clk <= ~clk;

endmodule