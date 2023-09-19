module rom(input i_clk,
            input i_read,
            input i_write,
            input [7:0] i_read_addr,
            input [7:0] i_write_addr,
            input [7:0] i_data,
            output reg [23:0] o_rgb_data,
            output reg o_valid);

/* Define and initialize the memory */
reg [23:0] memory [0:255];

initial begin
    $readmemh("test_memory.mem", memory);
end

/* Detect rising edge of i_read, i_write and latch i_read_addr and i_write_addr */
reg [1:0] r_read_rising;
reg [1:0] r_write_rising;
reg [7:0] r_read_addr;
reg [7:0] r_write_addr;

always @(posedge i_clk) begin
    r_read_rising <= {r_read_rising[0], i_read};
    r_write_rising <= {r_write_rising[0], i_write};
    r_read_addr <= i_read_addr;
    r_write_addr <= i_write_addr;
end

/* Process read */
always @(posedge i_clk) begin
    o_valid <= 1'b0; //default assignment
    
    if (r_read_rising == 2'b01) begin
        o_rgb_data <= memory[r_read_addr];
        o_valid <= 1'b1;
    end
end

/* Process write */
always @(posedge i_clk) begin
    if (r_write_rising == 2'b01) begin
        memory[r_write_addr] <= i_data;
    end
end

endmodule