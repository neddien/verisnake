module led_mat_controller (
    input wire  [3:0] display_x;
    input wire  [3:0] display_y; 
    output reg  [7:0] led_mat_r;
    output reg  [2:0] led_mat_c;    
);

    always @(*) begin
        case (display_x)
            
        endcase
    end

    always @(*) begin
        case (display_y)
        
        endcase
    end

endmodule