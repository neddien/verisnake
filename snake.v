module verisnake (
    input  logic          clk,
    input  logic          rst,
    input  logic [4:0]    ctl,
    output logic [7:0]    score,
    output logic [7:0]    r_data,
    output logic [2:0]    c_addr 
);
    parameter MOVE_DIV = 16'd50;

    typedef enum logic [4:0] {
        NONE    = 5'h00,
        UP      = 5'h02, 
        DOWN    = 5'h08, 
        LEFT    = 5'h04,
        RIGHT   = 5'h10
    } dir_t;

    typedef enum logic [2:0] {
        FLOOR,
        WALL,
        SNAKE,
        SEGMENT,
        APPLE   
    } cell_t;

    logic [4:0]     sn_head_pos_x_  = 5'd4;
    logic [4:0]     sn_head_pos_y_  = 5'd4;
    logic [4:0]     sn_speed_       = 5'd1;
    logic [7:0]     score_          = 8'd0;
    logic [4:0]     ap_pos_x_       = 5'd2;
    logic [4:0]     ap_pos_y_       = 5'd2;
    logic [15:0]    move_cnt_       = '0;
    logic [2:0]     col_            = '0;
    dir_t           sn_dir_         = LEFT;
    cell_t          scene_[8][8];
    logic [23:0]    blink_cnt_;
    logic           blink_;

    dir_t dir_next_;

    // Assign to data pin
    assign score    = score_;
    assign c_addr   = col_;
    assign blink_   = blink_cnt_[23];

    function automatic logic pixel_on(cell_t e, logic blink);
        case(e)
            FLOOR:      return 1'b0;
            APPLE:      return blink;
            default:    return 1'b1;
        endcase
    endfunction

    // Column output
    always_comb begin
        for (int r = 0; r < 8; r++) 
            r_data[r] = pixel_on(scene_[r][c_addr], blink_);
    end

    always_comb begin
        dir_next_ = sn_dir_;
        case (ctl)
            UP, DOWN, LEFT, RIGHT: dir_next_ = dir_t'(ctl);
            default: ;
        endcase
    end

    // Game logic
    always_ff @(posedge clk) begin
        blink_cnt_ <= blink_cnt_ + 1;
        col_ <= col_ + 1;

        if (move_cnt_ == MOVE_DIV - 1) begin
            move_cnt_   <= '0;
            sn_dir_     <= dir_next_; 

            // Clear
            scene_[sn_head_pos_y_][sn_head_pos_x_] = FLOOR;

            case (sn_dir_)
                UP:     sn_head_pos_y_ <= sn_head_pos_y_ - 1; 
                DOWN:   sn_head_pos_y_ <= sn_head_pos_y_ + 1; 
                LEFT:   sn_head_pos_x_ <= sn_head_pos_x_ - 1;
                RIGHT:  sn_head_pos_x_ <= sn_head_pos_x_ + 1;
                default: ;
            endcase

            // New pos
        end else begin
            move_cnt_ <= move_cnt_ + 1;
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 8; i++) 
                for (int j = 0; j < 8; j++)
                    scene_[i][j] <= FLOOR;
                
            sn_head_pos_x_  = 5'd4;
            sn_head_pos_y_  = 5'd4;
            sn_speed_       = 5'd1;
            score_          = 8'd0;
            ap_pos_x_       = 5'd2;
            ap_pos_y_       = 5'd2;
            move_cnt_       = '0;
            col_            = '0;
            sn_dir_         = LEFT;
            blink_cnt_      = '0;
        end

        scene_[sn_head_pos_y_][sn_head_pos_x_] = SNAKE;
    end

endmodule