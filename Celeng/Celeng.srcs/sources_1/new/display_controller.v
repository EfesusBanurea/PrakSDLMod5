module display_controller(
    input wire clk,
    input wire [2:0] sw_val,      
    input wire [2:0] current_val, 
    input wire moving_up,         
    input wire moving_down,       
    input wire [1:0] anim_step,
    output reg [7:0] seg,         // 8-bit untuk DP
    output reg [7:0] an
);
    reg [17:0] scan;
    wire [2:0] sel = scan[17:15];
    always @(posedge clk) scan <= scan + 1;

    always @(*) begin
        an = 8'b11111111; an[sel] = 1'b0;
        seg = 8'hFF; // Active Low (mati)
        case (sel)
            // TARGET: Lt:x
            3'd7: seg = 8'b11000111; // L (f, e, d)
            3'd6: seg = 8'b00000111 & 8'b01111111; // t + Titik (DP)
            3'd5: begin // x Target
                case (sw_val)
                    3'b000: seg = 8'hC0; 3'b001: seg = 8'hF9;
                    3'b010: seg = 8'hA4; 3'b011: seg = 8'hB0;
                    3'b100: seg = 8'h99; default: seg = 8'hBF;
                endcase
            end
            // PANAH TENGAH (Animasi)
            3'd4: if (moving_up) begin // Naik: c -> b -> a
                case (anim_step)
                    2'd0: seg = 8'b11111011; 2'd1: seg = 8'b11111101;
                    2'd2: seg = 8'b11111110; default: seg = 8'hFF;
                endcase
            end
            3'd3: if (moving_down) begin // Turun: f -> e -> d
                case (anim_step)
                    2'd0: seg = 8'b11011111; 2'd1: seg = 8'b11101111;
                    2'd2: seg = 8'b11110111; default: seg = 8'hFF;
                endcase
            end
            // STATUS: St:x
            3'd2: seg = 8'h92; // S
            3'd1: seg = 8'b00000111 & 8'b01111111; // t + Titik (DP)
            3'd0: begin // x Sekarang
                case (current_val)
                    3'b000: seg = 8'h82; // G
                    3'b001: seg = 8'hF9; 3'b010: seg = 8'hA4;
                    3'b011: seg = 8'hB0; 3'b100: seg = 8'h99;
                    default: seg = 8'hFF;
                endcase
            end
        endcase
    end
endmodule