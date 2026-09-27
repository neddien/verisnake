// Drives Digital's "LED-Matrix" component (8 rows x 8 columns).
//
// The matrix is scanned one column at a time: c_addr picks the column and
// r_data holds that column's 8 LEDs (one bit per row). The matrix remembers
// each column, so cycling c_addr through 0..7 shows the whole image.
//
// The picture is stored in an 8-column framebuffer. Write a column by putting
// its number on w_col, its LED pattern on w_data, and raising we for one clock.
module led_matrix_driver (
    input  wire       clk,
    input  wire       reset,
    input  wire       we,
    input  wire [2:0] w_col,
    input  wire [7:0] w_data,
    output wire [7:0] r_data,
    output reg  [2:0] c_addr
);
    reg [7:0] fb [0:7];
    integer i;

    // Start blank so the matrix isn't full of x before the first reset
    initial begin
        c_addr = 3'd0;
        for (i = 0; i < 8; i = i + 1)
            fb[i] = 8'h00;
    end

    // Framebuffer write port
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                fb[i] <= 8'h00;
        end else if (we) begin
            fb[w_col] <= w_data;
        end
    end

    // Column scanner: moves to the next column every clock, wraps 7 -> 0
    always @(posedge clk) begin
        if (reset)
            c_addr <= 3'd0;
        else
            c_addr <= c_addr + 3'd1;
    end

    assign r_data = fb[c_addr];

endmodule
