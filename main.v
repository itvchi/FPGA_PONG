module main (input i_clk,
            output o_clk,
            output o_lcd_clk,
            output o_lcd_de, 
            output [7:0] o_lcd_red,
            output [7:0] o_lcd_green,
            output [7:0] o_lcd_blue);

wire clk_50M, clk_100M, clk_200M;	
wire [8:0] w_x, w_y;
wire [7:0] w_mul;
wire [23:0] w_rom_data;
wire w_rom_valid;
wire [8:0] w_rom_address;
wire w_rom_read;
wire [23:0] w_rgb_data;
reg [3:0] r_tile = 0;
reg [2:0] r_mirror, r_rotate;
wire [15:0] w_xy;
				
pll pll_instance (.inclk0(i_clk), .c0(clk_50M), .c1(clk_100M), .c2(clk_200M));

tile_data tile(.i_tile_no(r_tile), .i_tile_x(w_x[3:2]), .i_tile_y(w_y[3:2]), .i_mirror(2'd0), .i_rotate(r_rotate), .i_read(clk_50M), .o_rgb_data(w_rgb_data), .o_valid(w_valid),
                .i_rom_data(w_rom_data), .i_rom_valid(w_rom_valid), .o_rom_address(w_rom_address), .o_rom_read(w_rom_read));
rom_rgb memory(.i_clk(clk_200M), .i_read(w_rom_read), .i_address(w_rom_address), .o_rgb_data(w_rom_data), .o_valid(w_rom_valid));

lcd_driver lcd (.i_clk(clk_50M), .i_color(w_rgb_data), .o_clk(o_lcd_clk), .o_data_enable(o_lcd_de), 
                .o_red(o_lcd_red), .o_green(o_lcd_green), .o_blue(o_lcd_blue), .o_x(w_x), .o_y(w_y));

assign o_clk = clk_50M;
assign w_mul = w_x * w_y;
assign w_xy = { 3'd0, w_x[8:4], 3'd0, w_y[8:4]};

always @(*) begin
    casex (w_xy)
        16'h0000:
        begin
            r_tile <= 6; 
            r_mirror <= 0;
            r_rotate <= 0;
        end 
        16'h??00:
        begin
            r_tile <= 8; 
            r_mirror <= 0;
            r_rotate <= 0;
        end 
        16'h00??:
        begin
            r_tile <= 8; 
            r_mirror <= 0;
            r_rotate <= 3;
        end 
        default: 
        begin
            r_tile <= 12; 
            r_mirror <= 0;
        end 
    endcase
end

endmodule