module sram_4x8 (
    input wire          clk,
    input wire          reset,
    input wire  [1:0]   addr,
    input wire          we,
    input wire          oe,
    inout wire  [7:0]   data
);
    reg [7:0] mem_ [0:3];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) 
                mem_[i] <= 8'h00;
        end else if (we) begin
            mem_[addr] <= data;    
        end
    end

    assign data = (oe && !we) ? mem_[addr] : 8'bz;

endmodule