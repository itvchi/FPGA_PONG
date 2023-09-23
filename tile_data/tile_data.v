module tile_data(/* tile_data interface */
                input [3:0] i_tile_no,
                input [1:0] i_tile_x,
                input [1:0] i_tile_y,
                /* input [1:0] i_rotate, */
                input [1:0] i_mirror,
                input [1:0] i_rotate,
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

localparam
rotateNO = 2'd0,
rotate90 = 2'd1,
rotate180 = 2'd2,
rotate270 = 2'd3;

reg [2:0] r_rot_x, r_rot_y;

/* Calculate "which a and y to print" based od requested x, y and rotation */
always @(*) begin
    case(i_rotate)
        rotateNO: 
        begin
            r_rot_x <= i_tile_x;
            r_rot_y <= i_tile_y;
        end
        rotate90: 
        begin
            r_rot_x <= i_tile_y;
            r_rot_y <= TILE_WIDTH - i_tile_x - 1;
        end
        rotate180: 
        begin
            r_rot_x <= TILE_WIDTH - i_tile_x - 1;
            r_rot_y <= TILE_HEIGHT - i_tile_y - 1;
        end
        rotate270: 
        begin
            r_rot_x <= TILE_HEIGHT - i_tile_y - 1;
            r_rot_y <= i_tile_x; 
        end
        default:
        begin
            r_rot_x <= i_tile_x;
            r_rot_y <= i_tile_y;
        end
    endcase
end

/* Set o_rom_address based on requested tile number, x, y and mirror */
always @(*) begin
    case(i_mirror)
        mirrorNO: o_rom_address <= (i_tile_no * TILE_AREA) + (r_rot_y * TILE_WIDTH) + r_rot_x;
        mirrorH: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_HEIGHT - 1) * TILE_WIDTH) - (r_rot_y * TILE_WIDTH) + r_rot_x;
        mirrorV: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_WIDTH - 1)) + (r_rot_y * TILE_WIDTH) - r_rot_x;
        mirrorVH: o_rom_address <= ((i_tile_no * TILE_AREA) + (TILE_AREA - 1)) - (r_rot_y * TILE_WIDTH) - r_rot_x;
        default: o_rom_address <= (i_tile_no * TILE_AREA) + (r_rot_y * TILE_WIDTH) + r_rot_x;
    endcase
end

/* tile_data inputs -> rom inputs */
assign o_rom_read = i_read;

/* rom outputs -> tile_data outputs */
assign o_rgb_data = i_rom_data;
assign o_valid = i_rom_valid;

endmodule