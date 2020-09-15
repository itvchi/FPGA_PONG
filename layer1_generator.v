module layer1_generator (
	input i_clk,
	input [8:0] i_x,
	input [8:0] i_y,
	input [7:0] i_ram_data,
	input [12:0] i_layer_address,
	input i_layer_clk,
	output o_ram_clk,
	output [5:0] o_ram_address,
	output [5:0] o_layer_data,
	output [1:0] o_rotate
);





reg [7:0] r_player1_x = 1;
reg [7:0] r_player1_y = 10;
reg [7:0] r_player1_h = 10;
reg [7:0] r_player2_x;
reg [7:0] r_player2_y;
reg [7:0] r_player2_h;
reg [7:0] r_ball_x;
reg [7:0] r_ball_y;

	always @ (posedge i_clk)
	begin
			r_x <= i_x;
			r_y <= i_y;
	end

/*	always @ (posedge i_clk)
	begin
		case(r_state)
			IDLE:
			begin
				r_index = 0;
				if(r_x == 0 && r_y == 0) r_state <= UPDATE;
				else r_state <= IDLE;
			end
			
			UPDATE:
			begin
				if(r_index < 8) r_ram_address <= r_index;
				else r_state <= WAIT;
			end
			
			READ_DATA:
			begin
				case(r_index)
				3'd0: r_player1_x <= i_ram_data;
				3'd1: r_player1_y <= i_ram_data;
				3'd2: r_player1_h <= i_ram_data;
				3'd3: r_player2_x <= i_ram_data;
				3'd4: r_player2_y <= i_ram_data;
				3'd5: r_player2_h <= i_ram_data;
				3'd6: r_ball_x <= i_ram_data;
				3'd7: r_ball_y <= i_ram_data;
				default: r_state <= UPDATE;
				endcase
				r_state <= UPDATE;
			end
			
			WAIT:
			begin
				if(r_x == 0 && r_y == 0) r_state <= WAIT;
				else r_state <= IDLE;
			end
			
			default: r_state <= IDLE;
		endcase
	end
*/	
	always @ (posedge i_clk)
	begin
			if(r_player1_y*120 + r_player1_x == i_layer_address)
			begin
				r_rotate <= 2'b00;
				r_layer_data <= 6'd1;
			end
			else if(r_player1_y*120 + r_player1_x + 1 == i_layer_address)
			begin
				r_rotate <= 2'b01;
				r_layer_data <= 6'd1;
			end
			/*else if(r_player1_y*120 + r_player1_x + r_player1_h*120 == i_layer_address)
			begin
				r_rotate <= 2'b11;
				r_layer_data <= 6'd2;
			end
			else if(r_player1_y*120 + r_player1_x + r_player1_h*120 + 1 == i_layer_address)
			begin
				r_rotate <= 2'b10;
				r_layer_data <= 6'd2;
			end*/
			else
			begin
				r_rotate <= 2'b00;
				r_layer_data <= 6'b111111;
			end
	end


	assign o_ram_address = r_ram_address;
	assign o_layer_data = r_layer_data;
	assign o_rotate = r_rotate;
	
endmodule