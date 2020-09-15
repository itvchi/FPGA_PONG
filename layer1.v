module layer1 (
	input i_clk,
	input i_lcd_clk,
	input i_lcd_data_enable,
	input [8:0] i_x,
	input [8:0] i_y,
	input [23:0] i_rom_data,
	input [7:0] i_ram_data,
	output [7:0] o_rom_address,
	output [4:0] o_ram_address,
	output [23:0] o_color,
	output o_layer_active
);

localparam IDLE = 3'b000;
localparam WAIT = 3'b001;
localparam CALC_ADDRESS = 3'b010;
localparam WAIT_DATA = 3'b011;
localparam END = 3'b100;

//localparam IDLE = 3'b000;
localparam WRITE_ADDRESS = 3'b001;
localparam WAIT_RAM = 3'b010;
localparam READ_RAM = 3'b011;
//localparam END = 3'b100;

localparam mirrorNO = 2'b00;
localparam mirrorH = 2'b01;
localparam mirrorV = 2'b10;
localparam mirrorVH = 2'b11;

reg [5:0] r_tile;

reg [7:0] r_rom_address;
reg [4:0] r_ram_address;
reg [23:0] r_color = 24'd0;
reg [7:0] r_ram_data [7:0];
wire w_lcd_rising_edge;
reg r_lcd_clk_last;

wire w_lcd_data_enable_rising_edge;
reg r_lcd_data_enable_last;

reg [8:0] r_x;
reg [8:0] r_y;
reg [2:0] r_state = IDLE;
reg [2:0] r_state_ram = IDLE;
reg r_layer_active;
reg [1:0] r_rotate;

reg [7:0] r_player1_x = 1;
reg [7:0] r_player1_y = 10;
reg [7:0] r_player1_h = 20;
reg [7:0] r_player2_x = 117;
reg [7:0] r_player2_y = 15;
reg [7:0] r_player2_h = 25;
reg [7:0] r_ball_x = 50;
reg [7:0] r_ball_y = 30;	
	
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
		r_lcd_data_enable_last <= i_lcd_data_enable;
	end
	
	always @ (posedge i_clk)
	begin
		case(r_state_ram)
			IDLE:
			begin
				r_ram_address <= 5'b0;
				if(r_x == 0 && r_y == 0 && w_lcd_data_enable_rising_edge) r_state_ram <= WRITE_ADDRESS;
				else r_state_ram <= IDLE;
			end
			WRITE_ADDRESS:
			begin
				r_ram_address <= r_ram_address;
				r_state_ram <= WAIT_RAM;
			end
			WAIT_RAM:
			begin
				r_state_ram <= READ_RAM;
			end
			READ_RAM:
			begin
				if(r_ram_address < 8)
				begin
					r_ram_data[r_ram_address] <= i_ram_data;
					r_ram_address <= r_ram_address + 1;
					r_state_ram <= WRITE_ADDRESS;
				end
				else r_state_ram <= END;
			end
			END:
			begin
				r_player1_x <= r_ram_data[0];
				r_player1_y <= r_ram_data[1];
				r_player1_h <= r_ram_data[2];
				r_player2_x <= r_ram_data[3];
				r_player2_y <= r_ram_data[4];
				r_player2_h <= r_ram_data[5];
				r_ball_x <= r_ram_data[6];
				r_ball_y <= r_ram_data[7];
				r_state_ram <= IDLE;
			end
			
			default: r_state_ram <= IDLE;
		endcase
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
			if(r_tile == 6'b111111) 
			begin
				r_layer_active <= 1'b0;
				r_color <= 24'd0;
				r_state <= IDLE;
			end
			else
			begin
				r_layer_active <= 1'b1;
				case(r_rotate)
				mirrorNO: r_rom_address <= (r_tile * 16) + 4 * r_y[1:0] + r_x[1:0];
				mirrorH: r_rom_address <= (r_tile * 16 + 12) - 4 * r_y[1:0] + r_x[1:0];
				mirrorV: r_rom_address <= (r_tile * 16 + 3) + 4* r_y[1:0] - r_x[1:0];
				mirrorVH: r_rom_address <= (r_tile * 16 + 15) - 4 * r_y[1:0] - r_x[1:0];
				default: r_rom_address <= (r_tile * 16) + 4 * r_y[1:0] + r_x[1:0];
				endcase
				r_state <= WAIT_DATA;
			end
	
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
		if(r_x[8:2] == r_player1_x)
		begin
			r_rotate[1] <= 0;
			r_rotate[0] = (r_y[8:2] >= r_player1_y + r_player1_h - 2) ? 1 : 0;
			
			case(r_y[8:2])
				r_player1_y: r_tile <= 6'd1;
				r_player1_y + 1: r_tile <= 6'd2;
				r_player1_y + r_player1_h - 2: r_tile <= 6'd2;
				r_player1_y + r_player1_h - 1: r_tile <= 6'd1;
				default:
				begin
					if(r_y[8:2] > r_player1_y + 1 && r_y[8:2] < r_player1_y + r_player1_h - 2) r_tile <= 6'd3;
					else r_tile <= 6'b111111;
				end
			endcase
		end
		else if(r_x[8:2] == r_player1_x + 1)
		begin
			r_rotate[1] <= 1;
			r_rotate[0] = (r_y[8:2] >= r_player1_y + r_player1_h - 2) ? 1 : 0;
			
			case(r_y[8:2])
				r_player1_y: r_tile <= 6'd1;
				r_player1_y + 1: r_tile <= 6'd2;
				r_player1_y + r_player1_h - 2: r_tile <= 6'd2;
				r_player1_y + r_player1_h - 1: r_tile <= 6'd1;
				default:
				begin
					if(r_y[8:2] > r_player1_y + 1 && r_y[8:2] < r_player1_y + r_player1_h - 2) r_tile <= 6'd3;
					else r_tile <= 6'b111111;
				end
			endcase
		end
		else if(r_x[8:2] == r_player2_x)
		begin
			r_rotate[1] <= 0;
			r_rotate[0] = (r_y[8:2] >= r_player2_y + r_player2_h - 2) ? 1 : 0;
			
			case(r_y[8:2])
				r_player2_y: r_tile <= 6'd1;
				r_player2_y + 1: r_tile <= 6'd4;
				r_player2_y + r_player2_h - 2: r_tile <= 6'd4;
				r_player2_y + r_player2_h - 1: r_tile <= 6'd1;
				default:
				begin
					if(r_y[8:2] > r_player2_y + 1 && r_y[8:2] < r_player2_y + r_player2_h - 2) r_tile <= 6'd5;
					else r_tile <= 6'b111111;
				end
			endcase
		end
		else if(r_x[8:2] == r_player2_x + 1)
		begin
			r_rotate[1] <= 1;
			r_rotate[0] = (r_y[8:2] >= r_player2_y + r_player2_h - 2) ? 1 : 0;
			
			case(r_y[8:2])
				r_player2_y: r_tile <= 6'd1;
				r_player2_y + 1: r_tile <= 6'd4;
				r_player2_y + r_player2_h - 2: r_tile <= 6'd4;
				r_player2_y + r_player2_h - 1: r_tile <= 6'd1;
				default:
				begin
					if(r_y[8:2] > r_player2_y + 1 && r_y[8:2] < r_player2_y + r_player2_h - 2) r_tile <= 6'd5;
					else r_tile <= 6'b111111;
				end
			endcase
		end
		/*else if(r_x >= r_ball_x && r_y >= r_ball_y && r_x < r_ball_x + 8 && r_y < r_ball_y + 8)
		begin
			if(r_x < r_ball_x + 4 && r_y < r_ball_y + 4) r_rotate <= mirrorNO;
			else if(r_x >= r_ball_x + 4 && r_y < r_ball_y + 4) r_rotate <= mirrorV;
			else if(r_x < r_ball_x && r_y >= r_ball_y + 4) r_rotate <= mirrorH;
			else if(r_x >= r_ball_x + 4 && r_y >= r_ball_y + 4) r_rotate <= mirrorVH;
			else r_rotate <= mirrorNO;
			
			r_tile <= 6'd0;
		end
		else r_tile <= 6'b111111;
		*/
		
		
		else if(r_x[8:2] == r_ball_x)
		begin
			r_rotate[1] <= 0;
			
			if(r_y[8:2] == r_ball_y)
			begin
				r_rotate[0] <= 0;
				r_tile <= 6'd0;
			end
			else if(r_y[8:2] == r_ball_y + 1)
			begin
				r_rotate[0] <= 1;
				r_tile <= 6'd0;
			end
			else r_tile <= 6'b111111;
		end
		else if(r_x[8:2] == r_ball_x + 1)
		begin
			r_rotate[1] <= 1;
			
			if(r_y[8:2] == r_ball_y)
			begin
				r_rotate[0] <= 0;
				r_tile <= 6'd0;
			end
			else if(r_y[8:2] == r_ball_y + 1)
			begin
				r_rotate[0] <= 1;
				r_tile <= 6'd0;
			end
			else r_tile <= 6'b111111;
		end
		else r_tile <= 6'b111111;
		
	end
	
	assign w_lcd_rising_edge = ~r_lcd_clk_last && i_lcd_clk;
	assign w_lcd_data_enable_rising_edge = ~r_lcd_data_enable_last && i_lcd_data_enable;
	
	assign o_rom_address = r_rom_address;
	assign o_ram_address = r_ram_address;
	assign o_color = r_color;
	assign o_layer_active = r_layer_active;

endmodule