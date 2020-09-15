module PONG_GAME (
	input i_clk,
	input i_ps2_clk,
	input i_ps2_data,
	output o_clk,
	output o_data_enable, 
	output [7:0] o_red,
	output [7:0] o_green,
	output [7:0] o_blue
);


wire [7:0] w_rom2_address;
wire [23:0] w_rom2_data;

wire [7:0] w_rom2_address_b;
wire [23:0] w_rom2_data_b;

wire w_clk;
wire w_data_enable;
wire [23:0] w_color1;
wire [23:0] w_color2;
wire [23:0] w_color3;

wire [8:0] w_x;
wire [8:0] w_y;

wire w_clk_pll;

wire w_layer_active;

wire [1:0] w_rotate;
wire [4:0] w_ram_address;
wire [7:0] w_ram_data;
wire [5:0] w_data;
wire [12:0] w_address;
wire w_ram_clk;

wire [7:0] w_ps2_data;
wire w_ps2_data_valid;
wire [7:0] w_code;
wire w_code_valid;

wire [4:0] w_ram_address_control_side;
wire [7:0] w_ram_data_control_side;
wire w_ram_wren;

	PLL pll (i_clk, w_clk_pll);
	ROM_2PORT tiles (.address_a (w_rom2_address), .address_b (w_rom2_address_b), .clock_a (w_clk_pll), .clock_b (w_clk_pll), .q_a (w_rom2_data), .q_b (w_rom2_data_b));
	layer0 bg (w_clk_pll, w_clk, 2'b00, w_x, w_y, w_rom2_data, w_rom2_address, w_color1);
	lcd_driver lcd (i_clk, w_color3, w_clk, w_data_enable, o_red, o_green, o_blue, w_x, w_y);
	
	RAM_2PORT ram (w_ram_data_control_side, w_ram_address, w_clk_pll, w_ram_address_control_side, w_clk_pll, w_ram_wren, w_ram_data);
	layer1 toplayer (w_clk_pll, w_clk, w_data_enable, w_x, w_y, w_rom2_data_b, w_ram_data, w_rom2_address_b, w_ram_address, w_color2, w_layer_active);
	color_mixer mixer (w_color1, w_color2, w_layer_active, w_color3);
	
	ps2_reader reader (i_clk, i_ps2_clk, i_ps2_data, w_ps2_data, w_ps2_data_valid);
	ps2_interpreter interpreter (i_clk, w_ps2_data, w_ps2_data_valid, w_code, w_code_valid);
	game control (i_clk, w_code, w_code_valid, w_ram_address_control_side, w_ram_data_control_side, w_ram_wren);

	assign o_clk = w_clk;
	assign o_data_enable = w_data_enable;

endmodule