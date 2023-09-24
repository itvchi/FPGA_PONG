module background_generator (input [6:0] i_tile_x,
							input [6:0] i_tile_y,
							output reg [3:0] o_tile_no);

reg [3:0] tile_memory [9:0];

initial begin
	/* First layer brick tile_no - upper half */
	tile_memory[0] = 8;
	tile_memory[1] = 10;
	tile_memory[2] = 6;
	tile_memory[3] = 8;
	/* Second layer brick tile_no - lower half */
	tile_memory[4] = 9;
	tile_memory[5] = 11;
	tile_memory[6] = 7;
	tile_memory[7] = 9;
end

always @(*) begin
	casex (i_tile_y)
		/* 6th bit is ?, because when it is 1, 4 layers left to display on the screen and they are brick layers */
		7'b?000000: o_tile_no <= tile_memory[0 + i_tile_x[1:0]];
		7'b?000001: o_tile_no <= tile_memory[4 + i_tile_x[1:0]];
		/* Offset next 2 layers (second layer of bricks) by i_tile_x[1] bit negation */
		7'b?000010: o_tile_no <= tile_memory[0 + {~i_tile_x[1], i_tile_x[0]}];
		7'b?000011: o_tile_no <= tile_memory[4 + {~i_tile_x[1], i_tile_x[0]}];
		default: o_tile_no <= 12; /* Tile between brick layers */ 
	endcase
end

endmodule