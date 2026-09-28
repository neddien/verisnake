module verisnake (
    input   wire          clk,
    input   wire          rst,
    input   wire [4:0]    ctl,
    output  wire [7:0]    score,
    output  wire [7:0]    r_data,
    output  reg  [2:0]    c_addr 
);
    parameter MOVE_DIV = 16'd50;

    reg [4:0] sn_head_pos_x_;
    reg [4:0] sn_head_pos_y_;
    reg [4:0] sn_speed_;
    reg [7:0] score_;
    reg [4:0] ap_pos_x_;
    reg [4:0] ap_pos_y_;
    reg [7:0] fb_ [7:0];
    reg [15:0] move_cnt_;
    reg [5:0] sn_dir_;
    reg [7:0] data_;
    integer i, j;

    initial begin
        sn_head_pos_x_  = 8 / 2;
        sn_head_pos_y_  = 8 / 2;
        sn_speed_       = 1;
        score_          = 0;
        ap_pos_x_       = 2;
        ap_pos_y_       = 2;
        c_addr          = 0;
        move_cnt_       = 0;
        sn_dir_         = 5'h04;
        data_           = 8'h00;

        for (i = 0; i < 8; i = i + 1)
            fb_[i] = 8'h00;
    end

    // Assign to data pin
    assign score    = score_;

    genvar r;
    generate 
        for (r = 0; r < 8; r = r + 1) begin : col_slice
            assign r_data[r] = fb_[r][7 - c_addr];
        end
    endgenerate

    // Game logic
    always @(posedge clk) begin
        if (move_cnt_ == MOVE_DIV - 1) begin
            move_cnt_ <= 0;

            if (ctl) sn_dir_ = ctl;

            case (sn_dir_)
            5'h02: sn_head_pos_y_ <= sn_head_pos_y_ - 1; 
            5'h08: sn_head_pos_y_ <= sn_head_pos_y_ + 1; 
            5'h04: sn_head_pos_x_ <= sn_head_pos_x_ + 1;
            5'h10: sn_head_pos_x_ <= sn_head_pos_x_ - 1;
            endcase
        end else begin
            move_cnt_ <= move_cnt_ + 1;
        end
    end

    // Render
    always @(posedge clk) begin
        if (rst)
            c_addr <= 3'd0;
        else 
            c_addr <= c_addr + 1;

        for (i = 0; i < 8; i = i + 1) begin
            fb_[i] <= 8'h00;
        end 

        fb_[sn_head_pos_y_] <= fb_[sn_head_pos_y_] | (8'h01 << sn_head_pos_x_); 
    end

endmodule