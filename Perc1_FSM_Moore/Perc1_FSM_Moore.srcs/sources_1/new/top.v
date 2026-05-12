module top(
    input wire clk_100MHz,   // Pin E3
    input wire sw0,          // Pin J15 (Input w)
    input wire btnd,         // Pin P18 (Reset)
    output wire led_y,       // Pin H17 (LD0)
    output wire led_hb,      // Pin V11 (LD15)
    output wire [6:0] seg,   // Katoda 7-segment
    output wire [7:0] an     // Anoda 7-segment
);
    wire rst, ce_2s, y;
    wire [1:0] st;

    // 1. Bersihkan sinyal tombol Reset (BTND)
    debouncer db_r (
        .clk(clk_100MHz), 
        .btn_in(btnd), 
        .btn_pulse(), 
        .btn_level(rst)
    );
    
    // 2. Generate pemicu otomatis tiap 2 detik
    clock_divider div (
        .clk_100MHz(clk_100MHz), 
        .reset(rst), 
        .ce_2s(ce_2s), 
        .led_hb(led_hb)
    );

    // 3. Jalankan logika FSM Moore
    fsm_moore fsm (
        .clk(clk_100MHz), 
        .reset(rst), 
        .ce(ce_2s), 
        .w(sw0), 
        .y(y), 
        .state_display(st)
    );

    // 4. Update tampilan dashboard di board
    display disp (
        .clk(clk_100MHz), 
        .w_in(sw0), 
        .y_out(y), 
        .state(st), 
        .seg(seg), 
        .an(an)
    );

    assign led_y = y; // Hubungkan output ke LED fisik
endmodule