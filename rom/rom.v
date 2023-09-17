module rom(input i_clk,
            input i_read,
            input [7:0] i_address,
            output reg [7:0] o_data,
            output reg o_valid);

/* Define and initialize the memory */
reg [8:0] memory [0:255];

initial begin
    $readmemh("test_memory.mem", memory);
end

/* Detect rising edge of i_read and latch i_address */
reg [1:0] r_read_rising;
reg [7:0] r_address;

always @(posedge i_clk) begin
    r_read_rising <= {r_read_rising[0], i_read};
    r_address <= i_address;
end

always @(posedge i_clk) begin
    o_valid <= 1'b0; //default assignment
    
    if (r_read_rising == 2'b01) begin
        o_data <= memory[r_address];
        o_valid <= 1'b1;
    end
end

endmodule