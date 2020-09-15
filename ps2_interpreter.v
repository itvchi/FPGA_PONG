// o_code (0-press/1-release)00(0-normal/1-special)(xxxx-code)

module ps2_interpreter (
	input i_clk,
	input [7:0] i_data,
	input i_convert,
	output [7:0] o_code,
	output o_code_valid
);

parameter IDLE = 2'b00;
parameter DATA_BYTE = 2'b01;
parameter DECODE = 2'b010;
parameter END = 2'b11;

// release => F0, key_code
localparam keyEnter = 8'h5A;
localparam keySpacebar = 8'h29;

// release => F0, key_code
localparam keyW = 8'h1D; 
localparam keyS = 8'h1B; 
localparam keyA = 8'h1C; 
localparam keyD = 8'h23; 

// press => E0, key_code
// release => E0, F0, key_code
localparam keyUP = 8'h75;
localparam keyDOWN = 8'h72;
localparam keyLEFT = 8'h6B;
localparam keyRIGHT = 8'h74;

reg [2:0] r_state = 0;
reg [2:0] r_index = 0;
reg [7:0] r_data [0:2];
reg [7:0] r_code;
reg r_code_valid ;
reg [17:0] r_counter = 0;

	always @ (posedge i_clk)
	begin
		case (r_state)
			IDLE:
			begin
				r_counter <= 18'b0;
				r_code_valid <= 0;
				r_index <=0;
				
				if(i_convert == 1'b1) r_state <= DATA_BYTE;
				else r_state <= IDLE;
			end
			DATA_BYTE:
			begin
				if(r_counter == 0) r_data[r_index] <= i_data;
				else r_data[r_index] <= r_data[r_index];
				
				if(r_counter == 18'd250000)
				begin
					r_counter <= 18'b0;
					r_state <= DECODE;
				end
				else if(i_convert == 1'b1)
				begin
					if(r_index<2)
					begin
						r_counter <= 18'b0;
						r_index <= r_index + 1;
						r_state <= DATA_BYTE;
					end
					else
					begin
						r_counter <= 18'b0;
						r_index <= 0;
						r_state <= DECODE;
					end
				end
				else 
				begin
					r_counter <= r_counter + 18'd1;
					r_state <= DATA_BYTE;
				end
			end
			DECODE:
			begin
				case(r_data[0])
					keyW: r_code <= 8'h00;
					keyS: r_code <= 8'h01;
					keyA: r_code <= 8'h02;
					keyD: r_code <= 8'h03;
					keyEnter: r_code <= 8'h10;
					keySpacebar: r_code <= 8'h11;
					8'hF0:
					begin
						case(r_data[1])
							keyW: r_code <= 8'h80;
							keyS: r_code <= 8'h81;
							keyA: r_code <= 8'h82;
							keyD: r_code <= 8'h83;
							keyEnter: r_code <= 8'h90;
							keySpacebar: r_code <= 8'h91;
							default: r_code <= 8'hFF;
						endcase
					end
					8'hE0:
					begin
						case(r_data[1])
							keyUP: r_code <= 8'h04;
							keyDOWN: r_code <= 8'h05;
							keyLEFT: r_code <= 8'h06;
							keyRIGHT: r_code <= 8'h07;
							8'hF0:
							begin
								case(r_data[2])
									keyUP: r_code <= 8'h14;
									keyDOWN: r_code <= 8'h15;
									keyLEFT: r_code <= 8'h16;
									keyRIGHT: r_code <= 8'h17;
									default: r_code <= 8'hFF;
								endcase
							end
							default: r_code <= 8'hFF;
						endcase
					end
					default: r_code <= 8'hFF;
				endcase
				
				r_state <= END;
			end
			END:
			begin
				r_code_valid <= 1'b1;
				r_state <= IDLE;
			end
			default:
			begin
				r_state <= IDLE;
			end
		endcase
	end
	
	assign o_code = r_code;
	assign o_code_valid = r_code_valid;
	
endmodule