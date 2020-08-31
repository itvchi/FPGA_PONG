module layer1_generator (
	input i_clk,
	input [8:0] i_x,
	input [8:0] i_y,
	input [7:0] i_ram_data,
	input [12:0] i_layer_adress,
	input i_layer_clk,
	output o_o_ram_clk,
	output [5:0] o_ram_adress,
	output [5:0] o_layer_data,
	output [1:0] o_rotate
);

localparam IDLE = 2'b00;
localparam UPDATE = 2'b01;
localparam WAIT = 2'b10;

reg [1:0] r_state = IDLE;
reg [8:0] r_x;
reg [8:0] r_y;

reg [6:0] r_player1_x;
reg [6:0] r_player1_y;
reg [6:0] r_player2_x;
reg [6:0] r_player2_y;
reg [6:0] r_ball_x;
reg [6:0] r_ball_y;

	always @ (posedge i_clk)
	begin
			r_x <= i_x;
			r_y <= i_y;
	end

	always @ (posedge i_clk)
	begin
		case(r_state)
			IDLE:
			begin
				if(r_x == 0 && r_y == 0) r_state <= UPDATE;
				else r_state <= IDLE;
			end
			
			UPDATE:
			begin
				
			end
			
			WAIT:
			begin
				if(r_x == 0 && r_y == 0) r_state <= WAIT;
				else r_state <= IDLE;
			end
			
			default: r_state <= IDLE;
		endcase
	end


endmodule