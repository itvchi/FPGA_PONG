`timescale 10ns/1ns
`include "tile_data.v"
`include "../rom/rom_rgb.v"
module tile_data_tb();

reg r_clk = 1'b1;
integer x, y;

reg [3:0] r_tile_no;
reg [1:0] r_x, r_y, r_mirror;
reg r_read;
wire [23:0] w_rgb_data;
wire w_walid;

wire [23:0] w_rom_data;
wire w_rom_valid;
wire [8:0] w_rom_address;
wire w_rom_read;

tile_data UUT(.i_tile_no(r_tile_no), .i_tile_x(r_x), .i_tile_y(r_y), .i_mirror(r_mirror), .i_read(r_read), .o_rgb_data(w_rgb_data), .o_valid(w_valid),
                .i_rom_data(w_rom_data), .i_rom_valid(w_rom_valid), .o_rom_address(w_rom_address), .o_rom_read(w_rom_read));

rom_rgb memory(.i_clk(r_clk), .i_read(w_rom_read), .i_address(w_rom_address), .o_rgb_data(w_rom_data), .o_valid(w_rom_valid));

/* Signals */
always #5 r_clk <= ~r_clk;

initial begin
    $dumpfile("tile_data.vcd");
    $dumpvars(0, tile_data_tb);
    #100;
    r_tile_no = 0;
    r_mirror <= 1;
    for (y = 0; y < 4; y++) begin
        r_y <= y;
        for (x = 0; x < 4; x++) begin
            r_x <= x;

            r_read <= 1'b1; #10;
            r_read <= 1'b0; #100;
        end
    end
    #100;
    $finish();
end

endmodule