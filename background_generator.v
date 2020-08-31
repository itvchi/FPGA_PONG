module background_generator (
	input i_clk,
	input [2:0] i_bg_set,
	input [12:0] i_address,
	output [5:0] o_data
);

localparam bg1 = 2'b00;
localparam bg2 = 2'b01;
localparam bg3 = 2'b10;
localparam bg4 = 2'b11;

reg [5:0] r_data;

	always @ (posedge i_clk)
	begin
		case(i_bg_set)
			bg1:
			begin
				if((i_address < 120) || (i_address >= 7920 && i_address < 8039))
				begin
					case(i_address[1:0])
					2'b00: r_data <= 6'd8;
					2'b01: r_data <= 6'd10;
					2'b10: r_data <= 6'd6;
					2'b11: r_data <= 6'd8;
					default: r_data <= 6'd12;
					endcase
				end
				else if((i_address >= 120 && i_address < 240) || (i_address >= 8040 && i_address < 8160))
				begin
					case(i_address[1:0])
					2'b00: r_data <= 6'd9;
					2'b01: r_data <= 6'd11;
					2'b10: r_data <= 6'd7;
					2'b11: r_data <= 6'd9;
					default: r_data <= 6'd12;
					endcase
				end
				else if((i_address >= 240 && i_address < 360) || (i_address >= 7680 && i_address < 7800))
				begin
					case(i_address[1:0])
					2'b00: r_data <= 6'd6;
					2'b01: r_data <= 6'd8;
					2'b10: r_data <= 6'd8;
					2'b11: r_data <= 6'd10;
					default: r_data <= 6'd12;
					endcase
				end
				else if((i_address >= 360 && i_address < 480) || (i_address >= 7800 && i_address < 7920))
				begin
					case(i_address[1:0])
					2'b00: r_data <= 6'd7;
					2'b01: r_data <= 6'd9;
					2'b10: r_data <= 6'd9;
					2'b11: r_data <= 6'd11;
					default: r_data <= 6'd12;
					endcase
				end
				else if(i_address >= 480 && i_address < 7679)
				begin
					r_data <= 6'd12;
				end
			end
			
			bg2:
			begin
				r_data <= 6'd12;
			end
			
			bg3:
			begin
				r_data <= 6'd12;
			end
			
			default: r_data <= 6'd12;
		endcase
	end

	assign o_data = r_data; 
	
endmodule