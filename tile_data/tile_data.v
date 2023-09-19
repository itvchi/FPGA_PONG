module tile_data(/* tile_data interface */
                input [3:0] i_tile_no,
                input [1:0] i_tile_x,
                input [1:0] i_tile_y,
                /* input [1:0] i_rotate, */
                input [1:0] i_mirror,
                input i_read,
                output [23:0] o_rgb_data,
                output o_valid,
                /* rom interface */
                input [23:0] i_rom_data,
                input i_rom_valid,
                output reg [8:0] o_rom_address,
                output o_rom_read);

localparam
TILE_WIDTH = 4,
TILE_HEIGHT = 4,
TILE_AREA = TILE_WIDTH * TILE_HEIGHT;

localparam 
mirrorNO = 2'd0,
mirrorH = 2'd1,
mirrorV = 2'd2,
mirrorVH = 2'd3;

/* tile_data inputs -> rom inputs */
assign o_rom_read = i_read;

always @(*) begin
    case(i_mirror)
        mirrorNO: o_rom_address <= (i_tile_no * TILE_AREA) + (i_tile_y * TILE_WIDTH) + i_tile_x;
        mirrorH: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_HEIGHT - 1) * TILE_WIDTH) - (i_tile_y * TILE_WIDTH) + i_tile_x;
        mirrorV: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_WIDTH - 1)) + (i_tile_y * TILE_WIDTH) - i_tile_x;
        mirrorVH: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_AREA - 1)) - (i_tile_y * TILE_WIDTH) - i_tile_x;
        default: o_rom_address <= (i_tile_no * TILE_AREA) + (i_tile_y * TILE_WIDTH) + i_tile_x;
    endcase
end

/* rom outputs -> tile_data outputs */
assign o_rgb_data = i_rom_data;
assign o_valid = i_rom_valid;

endmodule