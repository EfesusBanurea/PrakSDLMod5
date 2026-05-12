module clock_divider(
    input wire clk_100MHz,
    input wire reset,
    output reg ce_2s,        // Pulse "izin jalan" FSM tiap 2 detik
    output reg led_hb        // LED LD15 berkedip sebagai detak jantung sistem
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
                ce_2s <= 1;          // Aktif hanya 1 cycle tiap 2 detik
                led_hb <= ~led_hb;   // Toggle LED
            end else begin
                ce_2s <= 0;
                count <= count + 1;
            end
        end
    end
endmodule