`timescale 10ns/1ns
`include "ram.v"
module ram_tb();

integer mem_idx;
reg r_clk = 1'b1;
reg r_read = 1'b0;
reg r_write = 1'b0;
reg [7:0] r_read_addr = 8'd0;
reg [7:0] r_write_addr = 8'd0;
reg [7:0] r_data_in = 8'd0;

wire [7:0] w_data_out;
wire w_valid;

rom UUT(r_clk, r_read, r_write, r_read_addr, r_write_addr, r_data_in, w_data_out, w_valid);

always #5 r_clk <= ~r_clk;

initial begin
    $dumpfile("ram.vcd"); /* Name of the signal dump file */
    $dumpvars(0, ram_tb); /* Signals to dump */
    #100;
    for (mem_idx = 0; mem_idx < 256; mem_idx++) begin 
        r_read_addr <= mem_idx;
        r_read <= 1'b1;
        #10; r_read <= 1'b0;
        #100;
    end
    #1000;
    for (mem_idx = 0; mem_idx < 256; mem_idx++) begin 
        r_data_in = {2 {mem_idx[3:0]}};
        r_write_addr <= mem_idx;
        r_write <= 1'b1;
        #10; r_write <= 1'b0;
        #100;
    end
    #1000;
    for (mem_idx = 0; mem_idx < 256; mem_idx++) begin 
        r_read_addr <= mem_idx;
        r_read <= 1'b1;
        #10; r_read <= 1'b0;
        #100;
    end
    $finish();
end

endmodule