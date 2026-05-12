module clock_divider(
    input wire clk_100MHz,
    input wire reset,        // Input dari debouncer Reset
    output reg ce_2s,        // Clock Enable (aktif 1 cycle tiap 2 detik)
    output reg led_hb        // Indikator visual sistem bekerja (LD15)
);
    localparam MAX = 200_000_000; // 100MHz * 2 detik
    reg [27:0] count;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            count <= 0;
            ce_2s <= 0;
            led_hb <= 0;
        end else begin
            if (count >= MAX - 1) begin
                count <= 0;
                ce_2s <= 1;          // Memberi izin FSM untuk pindah state
                led_hb <= ~led_hb;   // Berkedip sebagai heartbeat
            end else begin
                ce_2s <= 0;
                count <= count + 1;
            end
        end
    end
endmodule