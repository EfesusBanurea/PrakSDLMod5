module display(
    input wire clk,          // Clock cepat untuk scanning
    input wire w_in,         // Status Switch
    input wire y_out,        // Status Output y
    input wire [1:0] state,  // Kode State (00-11)
    output reg [6:0] seg,    // Katoda (a-g)
    output reg [7:0] an      // Anoda (Digit select)
);
    reg [16:0] scan;         // Counter untuk kecepatan refresh display
    wire [2:0] sel = scan[16:14];

    always @(posedge clk) scan <= scan + 1;

    always @(*) begin
        an = 8'b11111111;    // Matikan semua digit (active high reset)
        an[sel] = 1'b0;      // Nyalakan digit yang dipilih (active low)
        
        case (sel)
            3'd7: seg = 7'b1100011; // Huruf 'w'
            3'd6: seg = (w_in) ? 7'b1111001 : 7'b1000000; // Nilai w (1/0)
            3'd5: seg = 7'b0010001; // Huruf 'y'
            3'd4: seg = (y_out) ? 7'b1111001 : 7'b1000000; // Nilai y (1/0)
            3'd3: seg = 7'b0010010; // Huruf 'S' (Perbaikan: segmen f nyala)
            3'd2: seg = 7'b0000111; // Huruf 't'
            3'd1: seg = 7'b1000000; // Angka '0' (sebagai spasi label St0)
            3'd0: begin             // Nilai State dalam angka
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