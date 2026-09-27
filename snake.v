module verisnake (
    input   wire          clk,
    input   wire          reset,
    input   wire [2:0]    ctl,
    output  wire [7:0]    score,
    output  wire [7:0]    r_data,
    output  reg  [2:0]    c_addr 
);
    parameter MOVE_DIV = 8'd20;

    reg [4:0] sn_head_pos_x_;
    reg [4:0] sn_head_pos_y_;
    reg [4:0] sn_speed_;
    reg [7:0] score_;
    reg [4:0] ap_pos_x_;
    reg [4:0] ap_pos_y_;
    reg [7:0] fb_ [7:0];
    reg [7:0] move_cnt_;
    reg [3:0] sn_dir_;
    integer i;

    initial begin
        sn_head_pos_x_  = 8 / 2;
        sn_head_pos_y_  = 8 / 2;
        sn_speed_       = 1;
        score_          = 0;
        ap_pos_x_       = 2;
        ap_pos_y_       = 2;
        c_addr          = 0;
        move_cnt_       = 0;
        sn_dir_         = 4'h01;

        for (i = 0; i < 8; i = i + 1)
            fb_[i] = 8'h00;
    end

    // Assign to data pin
    assign r_data   = fb_[c_addr];
    assign score    = score_;

    // Game logic
    always @(posedge clk) begin
        if (move_cnt_ == MOVE_DIV - 1) begin
            move_cnt_ <= 0;

            if (ctl)
                sn_dir_ = ctl;

            case (ctl)
            2'b010: sn_head_pos_y_ <= sn_head_pos_y_ - 3'd1;
            2'b100: sn_head_pos_x_ <= sn_head_pos_x_ - 3'd1;
            2'b011: sn_head_pos_y_ <= sn_head_pos_y_ + 3'd1;
            2'b100: sn_head_pos_x_ <= sn_head_pos_x_ + 3'd1;
            endcase
        end else begin
            move_cnt_ <= move_cnt_ + 1;
        end
    end

    // Render
    always @(posedge clk) begin
        for (i = 0; i < 8; i = i + 1) begin
            /*
            if (i == 0 || i == 7) 
                fb_[i] = 8'hff;
            else
                fb_[i] = 8'b10000001;
            */
            fb_[i] = 8'h00;
        end 

        fb_[sn_head_pos_y_] = fb_[sn_head_pos_y_] | (8'h01 << sn_head_pos_x_); 
        c_addr <= c_addr + 3'd1;
    end

endmodule