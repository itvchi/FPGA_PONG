module ps2_reader (
	input i_clk,
	input i_ps2_clk,
	input i_ps2_data,
	output [7:0] o_data,
	output o_data_valid
);

parameter IDLE = 3'b000;
parameter START_BIT = 3'b001;
parameter DATA_BIT = 3'b010;
parameter PARITY_BIT = 3'b011;
parameter STOP_BIT = 3'b100;
parameter END = 3'b101;

wire w_falling_edge;
reg r_ps2_clk;
reg r_ps2_clk_last;
reg [2:0] r_state = 0;
reg [2:0] r_index = 0;
reg [7:0] r_data;
reg r_parity_bit;
reg r_data_valid ;
reg [15:0] r_counter = 0;


	always @ (posedge i_clk)
	begin
		if(r_state != IDLE) r_counter <= r_counter + 16'd1;
		else r_counter <= 0;
		
		if(r_counter == 16'd50000) 
		begin
			r_counter <= 0;
			r_state <= IDLE;
		end
		else r_state <= r_state;
	
		case(r_state)
			IDLE:
			begin
				r_data_valid <= 0;
				r_index <= 0;
				
				if(w_falling_edge) r_state <= START_BIT;
				else r_state <= IDLE;
			end
			START_BIT:
			begin
				if(i_ps2_data == 0) r_state <= DATA_BIT;
				else r_state <= IDLE;
			end
			DATA_BIT:
			begin
				if(w_falling_edge)
				begin
					r_data[r_index] <= i_ps2_data;
					
					if(r_index<7)
					begin
						r_index <= r_index + 3'd1;
						r_state <= DATA_BIT;
					end
					else
					begin
						r_index <= 0;
						r_state <= PARITY_BIT;
					end
				end
				else r_state <= DATA_BIT;
			end
			PARITY_BIT:
			begin
				if(w_falling_edge)
				begin
					r_parity_bit <= i_ps2_data;
					r_state <= STOP_BIT;
				end
				else r_state <= PARITY_BIT;
			end
			STOP_BIT:
			begin
				if(w_falling_edge)
				begin
					if(i_ps2_data == 1'b1) 
					begin
						if(^{r_data, r_parity_bit}) r_data_valid <= 1'b1;
						else r_data_valid <= 1'b0;
						r_state <= END;
					end
					else r_state <= IDLE;
				end
				else r_state <= STOP_BIT;
			end
			END:
			begin
				r_data_valid <= 1'b0;
				r_state <= IDLE;
			end
			default:
			begin
				r_state <= IDLE;
			end
		endcase
		
		r_ps2_clk_last <= r_ps2_clk;
		r_ps2_clk <= i_ps2_clk;
	end
	
	assign w_falling_edge = r_ps2_clk_last && ~r_ps2_clk;
	
	assign o_data = r_data;
	assign o_data_valid = r_data_valid;
	
endmodule