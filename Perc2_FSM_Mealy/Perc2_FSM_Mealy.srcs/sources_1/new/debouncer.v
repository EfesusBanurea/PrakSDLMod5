module debouncer(
    input wire clk,
    input wire btn_in,
    output reg btn_pulse, // Sinyal satu denyut untuk Enter
    output reg btn_level // Sinyal stabil untuk Reset
);
    reg [19:0] count;
    reg btn_stable;
    reg btn_sync_0, btn_sync_1;
    reg btn_prev;

    always @(posedge clk) begin
        // Sinkronisasi input untuk mencegah ketidakstabilan sinyal (metastability)
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        // Jika sinyal stabil selama ~10ms (1.000.000 detak), sinyal dianggap valid
        if (btn_sync_1 == btn_stable) begin
            count <= 0;
        end else begin
            count <= count + 1;
            if (count == 20'd1_000_000) begin
                btn_stable <= btn_sync_1;
            end
        end
        
        btn_level <= btn_stable;                // Output stabil terus-menerus
        btn_prev  <= btn_stable;
        btn_pulse <= (btn_stable && !btn_prev); // Hanya aktif sesaat saat transisi (Rising Edge)
    end
endmodule