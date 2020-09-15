module layer0 (
	input i_clk,
	input i_lcd_clk,
	input [1:0] i_bg_set,
	input [8:0] i_x,
	input [8:0] i_y,
	input [23:0] i_rom_data,
	output [7:0] o_rom_address,
	output [23:0] o_color
);

localparam IDLE = 3'b000;
localparam WAIT = 3'b001;
localparam CALC_ADDRESS = 3'b010;
localparam WAIT_DATA = 3'b011;
localparam END = 3'b100;

localparam bg1 = 2'b00;
localparam bg2 = 2'b01;
localparam bg3 = 2'b10;
localparam bg4 = 2'b11;

reg [5:0] r_tile;

reg [7:0] r_rom_address;
reg [23:0] r_color = 24'd0;
wire w_lcd_rising_edge;
reg r_lcd_clk_last;
reg [8:0] r_x;
reg [8:0] r_y;
reg [2:0] r_state = IDLE;

	
	
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
				r_state <= WAIT;
			end 
		end
		
		WAIT:
		begin
			r_state <= CALC_ADDRESS;
		end
		
		CALC_ADDRESS:
		begin
			r_rom_address <= (r_tile * 16) + 4 * r_y[1:0] + r_x[1:0];
			r_state <= WAIT_DATA;
		end
		
		WAIT_DATA:
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
	
	always @ (posedge i_clk)
	begin
		case(i_bg_set)
			bg1:
			begin
				if(r_y[8:2] == 7'd0 || r_y[8:2] == 7'd66)
				begin
					case(r_x[3:2])
					2'b00: r_tile <= 6'd8;
					2'b01: r_tile <= 6'd10;
					2'b10: r_tile <= 6'd6;
					2'b11: r_tile <= 6'd8;
					default: r_tile <= 6'd12;
					endcase
				end
				else if(r_y[8:2] == 7'd1 || r_y[8:2] == 7'd67)
				begin
					case(r_x[3:2])
					2'b00: r_tile <= 6'd9;
					2'b01: r_tile <= 6'd11;
					2'b10: r_tile <= 6'd7;
					2'b11: r_tile <= 6'd9;
					default: r_tile <= 6'd12;
					endcase
				end
				else if(r_y[8:2] == 7'd2 || r_y[8:2] == 7'd64)
				begin
					case(r_x[3:2])
					2'b00: r_tile <= 6'd6;
					2'b01: r_tile <= 6'd8;
					2'b10: r_tile <= 6'd8;
					2'b11: r_tile <= 6'd10;
					default: r_tile <= 6'd12;
					endcase
				end
				else if(r_y[8:2] == 7'd3 || r_y[8:2] == 7'd65)
				begin
					case(r_x[3:2])
					2'b00: r_tile <= 6'd7;
					2'b01: r_tile <= 6'd9;
					2'b10: r_tile <= 6'd9;
					2'b11: r_tile <= 6'd11;
					default: r_tile <= 6'd12;
					endcase
				end
				else
				begin
					r_tile <= 6'd12;
				end
			end
			
			bg2:
			begin
				r_tile <= 6'd12;
			end
			
			bg3:
			begin
				r_tile <= 6'd12;
			end
			
			default: r_tile <= 6'd12;
		endcase
	end
	
	
	assign w_lcd_rising_edge = ~r_lcd_clk_last && i_lcd_clk;
	
	assign o_rom_address = r_rom_address;
	assign o_color = r_color;

endmodule