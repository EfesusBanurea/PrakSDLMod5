module top(
    input wire clk_100MHz,   // E3
    input wire sw0,          // SW0 (w)
    input wire btnc,         // BTNC (Enter)
    input wire btnd,         // BTND (Reset)
    output wire led_y,       // LD0
    output wire led_hb,      // LD15 (Indikator detak jantung sistem)
    output wire [6:0] seg,   // Katoda 7-seg
    output wire [7:0] an     // Anoda 7-seg
);
    wire enter_p, rst_l, y;
    wire [1:0] st;

    // Instance Debouncer untuk tombol Enter (BTNC)
    debouncer db_e (.clk(clk_100MHz), .btn_in(btnc), .btn_pulse(enter_p), .btn_level());
    
    // Instance Debouncer untuk tombol Reset (BTND)
    debouncer db_r (.clk(clk_100MHz), .btn_in(btnd), .btn_pulse(), .btn_level(rst_l));
    
    // Detak jantung sistem (berkedip tiap 2 detik)
    clock_divider hb (.clk_100MHz(clk_100MHz), .reset(rst_l), .ce_2s(), .led_hb(led_hb));
    
    // Logika FSM Mealy
    fsm_mealy fsm (
        .clk(clk_100MHz), .reset(rst_l), .ce(enter_p), 
        .w(sw0), .y(y), .state_display(st)
    );

    // Kendali Tampilan 7-Segment
    display disp (
        .clk(clk_100MHz), .w_in(sw0), .y_out(y), 
        .state(st), .seg(seg), .an(an)
    );

    assign led_y = y;
endmodule