module clock_divider #(parameter INPUT_CLOCK = 1000000,
                        parameter OUTPUT_CLOCK = 1000)
                        (input i_clk,
                        output reg o_clk);

localparam TICKS = (INPUT_CLOCK/(2*OUTPUT_CLOCK));
localparam BITS = $clog2(TICKS);

reg [BITS-1:0] r_counter;

initial 
begin
    r_counter = 0;
    o_clk = 0;
end

always @(posedge i_clk) 
begin
    r_counter <= r_counter + 1'd1;

    if(r_counter == (TICKS-1))
    begin
        o_clk <= ~o_clk;
        r_counter <= 0;
    end
end

endmodule