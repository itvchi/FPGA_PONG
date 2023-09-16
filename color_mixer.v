module color_mixer (input [23:0] i_layer1_color,
					input [23:0] i_layer2_color,
					input i_layer2_active,
					output [23:0] o_color);

	assign o_color = (i_layer2_active == 1'b1) ? ((i_layer2_color == 24'hfc64c8) ? i_layer1_color : i_layer2_color) : i_layer1_color;

endmodule