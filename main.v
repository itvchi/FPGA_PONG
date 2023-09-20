module main (input i_clk,
            output o_clk,
            output o_lcd_clk,
            output o_lcd_de, 
            output [7:0] o_lcd_red,
            output [7:0] o_lcd_green,
            output [7:0] o_lcd_blue);

wire clk_50M, clk_100M, clk_200M;				
				
pll pll_instance (.inclk0(i_clk), .c0(clk_50M), .c1(clk_100M), .c2(clk_200M));
lcd_driver lcd (.i_clk(clk_50M), .i_color(24'hFF0000), .o_clk(o_lcd_clk), .o_data_enable(o_lcd_de), 
                .o_red(o_lcd_red), .o_green(o_lcd_green), .o_blue(o_lcd_blue));

assign o_clk = clk_50M;

endmodule