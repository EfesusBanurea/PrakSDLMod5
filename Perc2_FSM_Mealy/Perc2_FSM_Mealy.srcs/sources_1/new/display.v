module display(
    input wire clk,
    input wire w_in,
    input wire y_out,
    input wire [1:0] state,
    output reg [6:0] seg,
    output reg [7:0] an
);
    reg [16:0] scan; // Digunakan untuk multiplexing tampilan agar tidak berkedip
    wire [2:0] sel = scan[16:14];

    always @(posedge clk) scan <= scan + 1;

    always @(*) begin
        an = 8'b11111111; // Matikan semua anoda (active high)
        an[sel] = 1'b0;    // Nyalakan satu anoda secara bergantian (active low)
        
        case (sel)
            3'd7: seg = 7'b1100011; // Label 'w'
            3'd6: seg = (w_in) ? 7'b1111001 : 7'b1000000; // Nilai w (1/0)
            3'd5: seg = 7'b0010001; // Label 'y'
            3'd4: seg = (y_out) ? 7'b1111001 : 7'b1000000; // Nilai y (1/0)
            3'd3: seg = 7'b0010010; // Huruf 'S' (Perbaikan garis kiri atas)
            3'd2: seg = 7'b0000111; // Huruf 't'
            3'd1: seg = 7'b1000000; // Angka '0'
            3'd0: begin             // Angka State (0-3)
                case (state)
                    2'b00: seg = 7'b1000000; 2'b01: seg = 7'b1111001;
                    2'b10: seg = 7'b0100100; 2'b11: seg = 7'b0110000;
                    default: seg = 7'b1111111;
                endcase
            end
            default: seg = 7'b1111111;
        endcase
    end
endmodule