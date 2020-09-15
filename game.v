module game (
	input i_clk,
	input [7:0] i_key,
	input i_key_valid,
	output [4:0] o_ram_address,
	output [7:0] o_ram_data,
	output o_ram_wren
);

localparam IDLE = 3'b000;
localparam TO_ARRAY = 3'b001;
localparam WRITE_DATA = 3'b010;
localparam WRITE_ENABLE = 3'b011;
localparam NEXT_ADDRESS = 3'b100;
localparam END = 3'b101;

localparam Lup = 8'h00;
localparam Ldown = 8'h01;
localparam Rup = 8'h04;
localparam Rdown = 8'h05;

reg [2:0] r_state_ram = IDLE;
reg r_write_enable = 0;
reg [4:0] r_ram_address;
reg [7:0] r_ram_data_array [7:0];
reg [7:0] r_ram_data;
reg r_update_player = 0;
reg r_update_ball = 0;

reg [7:0] r_player1_x = 1;
reg [7:0] r_player1_y = 10;
reg [7:0] r_player1_h = 20;
reg [7:0] r_player2_x = 117;
reg [7:0] r_player2_y = 15;
reg [7:0] r_player2_h = 25;
reg [7:0] r_ball_x = 50;
reg [7:0] r_ball_y = 30;

reg [20:0] counter = 0;
reg dir_x = 0;
reg dir_y = 0;

	always @ (posedge i_clk)
	begin
		counter <= counter + 21'b1;
		
		if(counter == 21'b0)
		begin
			if(dir_x) r_ball_x <= r_ball_x + 1;
			else r_ball_x <= r_ball_x - 1;
			if(dir_y) r_ball_y <= r_ball_y + 1;
			else r_ball_y <= r_ball_y - 1;
		end
		else if(counter == 21'b1)
		begin
			if(r_ball_x == 3 && (r_ball_y >= r_player1_y && (r_ball_y+1) <= (r_player1_y+r_player1_h)))
			begin
				dir_x <= ~dir_x;
			end
			else if(r_ball_x+1 == 116 && (r_ball_y >= r_player2_y && (r_ball_y+1) <= (r_player2_y+r_player2_h)))
			begin
				dir_x <= ~dir_x;
			end
			//else if((r_ball_x == 3 && (r_ball_y == r_player1_y - 1 || r_ball_y + 1 == r_player1_y+r_player1_h+1)) || (r_ball_x+1 == 116 && (r_ball_y == r_player2_y - 1 || r_ball_y + 1 == r_player2_y+r_player2_h+1)))
			//begin
			//	dir_x <= ~dir_x;
			//	dir_y <= ~dir_y;
			//end
			else 
			begin
				dir_x <= dir_x;
			end
		
			
			if(r_ball_y == 4 || r_ball_y+1 == 63)
			begin
				dir_y <= ~dir_y;
			end
			else dir_y <= dir_y; 
			if(r_ball_x < 1 || r_ball_x+1 > 118 )
			begin
				r_ball_x <= 60;
				r_ball_y <= 35;
			end
			else 
			begin
				r_ball_x <= r_ball_x;
				r_ball_y <= r_ball_y;
			end
		
			r_update_ball <= 1'b1;
		end
		else
		begin
			r_ball_x <= r_ball_x;
			r_ball_y <= r_ball_y;
			dir_x <= dir_x;
			dir_y <= dir_y;
		end
	end

	always @ (posedge i_clk)
		begin
			case(r_state_ram)
				IDLE:
				begin
					r_ram_address <= 5'b0;
					if(r_update_player == 1'b1 || r_update_ball == 1'b1) r_state_ram <= TO_ARRAY;
					else r_state_ram <= IDLE;
				end
				TO_ARRAY:
				begin
					r_ram_data_array[0] <= r_player1_x;
					r_ram_data_array[1] <= r_player1_y;
					r_ram_data_array[2] <= r_player1_h;
					r_ram_data_array[3] <= r_player2_x;
					r_ram_data_array[4] <= r_player2_y;
					r_ram_data_array[5] <= r_player2_h;
					r_ram_data_array[6] <= r_ball_x;
					r_ram_data_array[7] <= r_ball_y;
					
					r_state_ram <= WRITE_DATA;
				end
				WRITE_DATA:
				begin
					r_ram_data <= r_ram_data_array[r_ram_address];
					r_state_ram <= WRITE_ENABLE;
				end
				WRITE_ENABLE:
				begin
					r_write_enable <= 1'b1;
					r_state_ram <= NEXT_ADDRESS;
				end
				NEXT_ADDRESS:
				begin
					r_write_enable <= 1'b0;
					if(r_ram_address < 8)
					begin
						r_ram_address <= r_ram_address + 1;
						r_state_ram <= WRITE_DATA;
					end
					else r_state_ram <= END;
				end
				END:
				begin
					r_state_ram <= IDLE;
				end
				
				default: r_state_ram <= IDLE;
			endcase
		end
		
		always @ (posedge i_clk)
		begin
			if(i_key_valid)
			begin
				case(i_key)
					Lup: 
					begin
						if(r_player1_y > 4) r_player1_y <= r_player1_y - 1;
						else r_player1_y <= r_player1_y;
					end
					Ldown:
					begin
						if(r_player1_y + r_player1_h <= 63) r_player1_y <= r_player1_y + 1;
						else r_player1_y <= r_player1_y;
					end
					Rup:
					begin
						if(r_player2_y > 4) r_player2_y <= r_player2_y - 1;
						else r_player2_y <= r_player2_y;
					end
					Rdown:
					begin
						if(r_player2_y + r_player2_h <= 63) r_player2_y <= r_player2_y + 1;
						else r_player2_y <= r_player2_y;
					end
					default: 
					begin
						r_player1_y <= r_player1_y;
						r_player2_y <= r_player2_y;
					end
				endcase
				
				r_update_player <= 1'b1;
			end
			else
			begin
				r_player1_x <= r_player1_x;
				r_player1_y <= r_player1_y;
				r_player1_h <= r_player1_h;
				r_player2_x <= r_player2_x;
				r_player2_y <= r_player2_y;
				r_player2_h <= r_player2_h;
				r_ball_x <= r_ball_x;
				r_ball_y <= r_ball_y;
				
				r_update_player <= 1'b0;
			end
		end

	assign o_ram_wren = r_write_enable;
	assign o_ram_address = r_ram_address;
	assign o_ram_data = r_ram_data;

endmodule