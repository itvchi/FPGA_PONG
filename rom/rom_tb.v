`timescale 10ns/1ns
`include "rom.v"
module rom_tb();

integer mem_idx;
reg r_clk = 1'b1;
reg r_read = 1'b0;
reg [7:0] r_address = 8'd0;

wire [7:0] w_data;
wire w_valid;

rom UUT(r_clk, r_read, r_address, w_data, w_valid);

always #5 r_clk <= ~r_clk;

initial begin
    $dumpfile("rom.vcd"); /* Name of the signal dump file */
    $dumpvars(0, rom_tb); /* Signals to dump */
    #100;
    for (mem_idx = 0; mem_idx < 256; mem_idx++) begin 
        r_address <= mem_idx;
        r_read <= 1'b1;
        #10; r_read <= 1'b0;
        #100;
    end
    #100;
    $finish();
end

endmodule