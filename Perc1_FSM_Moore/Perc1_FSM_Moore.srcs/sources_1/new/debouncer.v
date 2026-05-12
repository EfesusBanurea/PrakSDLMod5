module debouncer(
    input wire clk,          // Clock utama 100MHz
    input wire btn_in,       // Input tombol fisik (BTND)
    output reg btn_pulse,    // Output 1 denyut clock saat ditekan
    output reg btn_level     // Output sinyal stabil (untuk Reset)
);
    reg [19:0] count;        // Counter untuk filter ~10ms
    reg btn_stable;
    reg btn_sync_0, btn_sync_1;
    reg btn_prev;

    always @(posedge clk) begin
        // Sinkronisasi untuk menghindari metastability
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        // Jika sinyal stabil selama hitungan tertentu, update btn_stable
        if (btn_sync_1 == btn_stable) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 20'd1_000_000) begin
                btn_stable <= btn_sync_1;
            end
        end
        
        btn_level <= btn_stable;                // Digunakan untuk Reset level-triggered
        btn_prev  <= btn_stable;
        btn_pulse <= (btn_stable && !btn_prev); // Digunakan jika butuh trigger sekali tekan
    end
endmodule