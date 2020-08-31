module background_generator (
	input i_clk,
	input [2:0] i_bg_set,
	input i_address,
	output reg [5:0] o_data
);

localparam bg1 = 2'b00;
localparam bg2 = 2'b01;
localparam bg3 = 2'b10;
localparam bg4 = 2'b11;

	always @ (posedge i_clk)
	begin
		case(i_bg_set)
			bg1:
			begin
			end
			
			bg2:
			begin
			end
			
			bg3:
			begin
			end
			
			default: 
		endcase
	end

endmodule