module rom_rgb(input i_clk,
            input i_read,
            input [8:0] i_address,
            output reg [23:0] o_rgb_data,
            output reg o_valid);

/* Define and initialize the memory */
reg [23:0] memory [0:287];

initial begin
    /* Path relative to parent directory - for simulation from external modules */
    $readmemh("../rom/memory.hex", memory);
end

/* Detect rising edge of i_read and latch i_address */
reg [1:0] r_read_rising;
reg [8:0] r_address;

always @(posedge i_clk) begin
    r_read_rising <= {r_read_rising[0], i_read};
    r_address <= i_address;
end

always @(posedge i_clk) begin
    o_valid <= 1'b0; //default assignment
    
    if (r_read_rising == 2'b01) begin
        o_rgb_data <= memory[r_address];
        o_valid <= 1'b1;
    end
end

endmodule