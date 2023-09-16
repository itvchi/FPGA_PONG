module data_enable (input i_clk,
                    output o_data_enable,
                    output [8:0] o_col,
                    output [8:0] o_row);

localparam 
TOTAL_HORIZONTAL = 10'd525,
TOTAL_VERTICAL = 10'd290,
HORIZONTAL_BLANKING = 10'd45,
VERTICAL_BLANKING = 10'd18;

wire w_hsync, w_vsync;
reg [9:0] r_hcounter = 0;
reg [8:0] r_vcounter = 0;

    always @ (posedge i_clk)
    begin
        if (r_hcounter == TOTAL_HORIZONTAL-1)
        begin
            r_hcounter <= 0;
            if(r_vcounter == TOTAL_VERTICAL-1) r_vcounter <= 0;
            else r_vcounter <= r_vcounter + 1;
        end
        else r_hcounter <= r_hcounter + 1;
    end

    assign w_hsync = (r_hcounter < HORIZONTAL_BLANKING) ? 1'b0 : 1'b1;
    assign w_vsync = (r_vcounter < VERTICAL_BLANKING) ? 1'b0 : 1'b1;
    assign o_data_enable = (w_hsync & w_vsync);

    assign o_col = (r_hcounter < HORIZONTAL_BLANKING) ? 9'd0 : (r_hcounter - HORIZONTAL_BLANKING);
    assign o_row = (r_vcounter < VERTICAL_BLANKING) ? 9'd0 : (r_vcounter - VERTICAL_BLANKING);

endmodule