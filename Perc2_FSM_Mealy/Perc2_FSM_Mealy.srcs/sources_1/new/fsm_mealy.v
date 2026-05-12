module fsm_mealy(
    input wire clk,
    input wire reset,
    input wire ce,           // Sinyal dari tombol Enter (BTNC)
    input wire w,            // Input switch (SW0)
    output reg y,            // Output hasil deteksi (LED LD0)
    output wire [1:0] state_display // Indikator state untuk 7-segment
);
    parameter S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11;
    reg [1:0] curr, next;

    assign state_display = curr;

    // Bagian Sequential: Perpindahan state hanya terjadi jika tombol Enter (ce) ditekan
    always @(posedge clk or posedge reset) begin
        if (reset) curr <= S0;
        else if (ce) curr <= next;
    end

    // Bagian Combinational: Logika Next State & Output berdasarkan image_1e0d17.png
    always @(*) begin
        next = curr;
        y = 1'b0; // Default output adalah 0

        case (curr)
            S0: begin
                next = (w) ? S1 : S0;
                y = 1'b0;
            end
            S1: begin
                next = (w) ? S1 : S2;
                y = 1'b0;
            end
            S2: begin
                next = (w) ? S0 : S3;
                y = 1'b0;
            end
            S3: begin
                if (w == 1'b1) begin
                    y = 1'b1;   // MEALY: Output 1 saat di S3 dan input w=1
                    next = S2;  // Kembali ke State 2
                end else begin
                    y = 1'b0;
                    next = S0;  // Kembali ke State 0 jika w=0
                end
            end
            default: next = S0;
        endcase
    end
endmodule