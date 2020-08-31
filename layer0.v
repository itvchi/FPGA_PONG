module layer0 (
	input i_clk,
	input i_lcd_clk,
	input [8:0] i_x,
	input [8:0] i_y,
	input [5:0] i_rom1_data,
	input [23:0] i_rom2_data,
	output [12:0] o_rom1_address,
	output [7:0] o_rom2_address,
	output [23:0] o_color
);

localparam IDLE = 3'b000;
localparam READ_ROM1 = 3'b001;
localparam WAIT_DATA_ROM1 = 3'b010;
localparam READ_ROM2 = 3'b011;
localparam WAIT_DATA_ROM2 = 3'b100;
localparam END = 3'b101;

reg [12:0] r_rom1_address;
reg [7:0] r_rom2_address;
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
				r_state <= READ_ROM1;
			end 
		end
		
		READ_ROM1:
		begin
			r_rom1_address <= (r_y[8:2] * 120) + r_x[8:2];
			r_state <= WAIT_DATA_ROM1;
		end
		
		WAIT_DATA_ROM1:
		begin
			r_state <= READ_ROM2;
		end
		
		READ_ROM2:
		begin
			r_rom2_address <= (i_rom1_data * 16) + 4 * r_y[1:0] + r_x[1:0];
			r_state <= WAIT_DATA_ROM2;
		end
		
		WAIT_DATA_ROM2:
		begin
			r_state <= END;
		end
		
		END:
		begin
			r_color <= i_rom2_data;
			r_state <= IDLE;
		end
		
		default: r_state <= IDLE;
		endcase
	end
	
	assign w_lcd_rising_edge = ~r_lcd_clk_last && i_lcd_clk;
	
	assign o_rom1_address = r_rom1_address;
	assign o_rom2_address = r_rom2_address;
	assign o_color = r_color;

endmodule