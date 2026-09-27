module framebuffer (
    input wire          clk,
    input wire          we,
    input wire [2:0]    w_col,
    input wire [7:0]    w_data,
    output     [7:0]    r_data,
    output reg [2:0]    c_addr
);

    reg [7:0] fb [0:7];
    integer i;
    initial begin
        c_addr = 0;
        for (i = 0; i < 8; i = i + 1) fb[i] = 8'h00;
    end

    always @(posedge clk) begin
            
    end

endmodule