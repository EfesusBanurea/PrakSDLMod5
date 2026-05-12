module fsm_moore(
    input wire clk,
    input wire reset,
    input wire ce,           // Pemicu otomatis dari clock_divider
    input wire w,            // Input dari Switch 0
    output reg y,            // Output hasil deteksi
    output wire [1:0] state_display // Untuk ditampilkan di 7-segment
);
    // Definisi State
    parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
    reg [1:0] curr, next;

    assign state_display = curr;

    // Register State: Update state saat clock edge jika diizinkan oleh 'ce'
    always @(posedge clk or posedge reset) begin
        if (reset) curr <= S0;
        else if (ce) curr <= next;
    end

    // Logika Kombinasional: Menentukan Next State & Output
    always @(*) begin
        y = (curr == S3);    // Ciri khas Moore: Output hanya patuh pada state sekarang
        case (curr)
            S0: next = (w) ? S1 : S0; // Mencari '1'
            S1: next = (w) ? S1 : S2; // Mencari '0'
            S2: next = (w) ? S3 : S0; // Mencari '1' penutup
            S3: next = (w) ? S1 : S2; // Overlapping: 1-0-1-(0-1)
            default: next = S0;
        endcase
    end
endmodule