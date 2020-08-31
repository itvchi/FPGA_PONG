module layer1 (
	input i_clk,
	input i_lcd_clk,
	input [8:0] i_x,
	input [8:0] i_y,
	input [5:0] i_generator_data,
	input [23:0] i_rom_data,
	input [1:0] i_rotate,
	output [12:0] o_generator_address,
	output [7:0] o_rom_address,
	output [23:0] o_color,
	output o_layer_active
);

localparam IDLE = 3'b000;
localparam READ_GENERATOR = 3'b001;
localparam WAIT_DATA_GENERATOR = 3'b010;
localparam READ_ROM = 3'b011;
localparam WAIT_DATA_ROM = 3'b100;
localparam END = 3'b101;

localparam _0deg = 2'b00;
localparam _90deg = 2'b01;
localparam _180deg = 2'b10;
localparam _270deg = 2'b11;

reg [12:0] r_generator_address;
reg [7:0] r_rom_address;
reg [23:0] r_color = 24'd0;
wire w_lcd_rising_edge;
reg r_lcd_clk_last;
reg [8:0] r_x;
reg [8:0] r_y;
reg [2:0] r_state = IDLE;
reg r_layer_active;
reg [1:0] r_rotate;

	
	
	always @ (posedge i_clk)
	begin
		if(w_lcd_rising_edge)
		begin
			r_x <= i_x;
			r_y <= i_y;
		end
		else
		begin
			r_x <= r_x;
			r_y <= r_y;
		end
		
		r_lcd_clk_last <= i_lcd_clk;
	end
	
	always @(posedge i_clk)
	begin
		case(r_state)
		IDLE:
		begin
			if(w_lcd_rising_edge) 
			begin
				r_state <= READ_GENERATOR;
			end 
		end
		
		READ_GENERATOR:
		begin
			r_generator_address <= (r_y[8:2] * 120) + r_x[8:2];
			r_state <= WAIT_DATA_GENERATOR;
		end
		
		WAIT_DATA_GENERATOR:
		begin
			r_rotate <= i_rotate;
			r_state <= READ_ROM;
		end
		
		READ_ROM:
		begin
			if(i_generator_data == 6'b111111) 
			begin
				r_layer_active <= 1'b0;
				r_color <= 24'd0;
				r_state <= IDLE;
			end
			else
			begin
				r_layer_active <= 1'b1;
				case(r_rotate)
				_0deg: r_rom_address <= (i_generator_data * 16) + 4 * r_y[1:0] + r_x[1:0];
				_90deg: r_rom_address <= (i_generator_data * 16 + 12) + r_y[1:0] - 4 * r_x[1:0];
				_180deg: r_rom_address <= (i_generator_data * 16 + 15) - 4 * r_y[1:0] - r_x[1:0];
				_270deg: r_rom_address <= (i_generator_data * 16 + 3) + 4 * r_y[1:0] + r_x[1:0];
				default: r_rom_address <= (i_generator_data * 16) - r_y[1:0] + 4 * r_x[1:0];
				endcase
				r_state <= WAIT_DATA_ROM;
			end
		end
		
		WAIT_DATA_ROM:
		begin
			r_state <= END;
		end
		
		END:
		begin
			r_color <= i_rom_data;
			r_state <= IDLE;
		end
		
		default: r_state <= IDLE;
		endcase
	end
	
	assign w_lcd_rising_edge = ~r_lcd_clk_last && i_lcd_clk;
	
	assign o_generator_address = r_generator_address;
	assign o_rom_address = r_rom_address;
	assign o_color = r_color;
	assign o_layer_active = r_layer_active;

endmodule