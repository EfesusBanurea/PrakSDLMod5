module top(
    input wire clk_100MHz,
    input wire [2:0] sw,
    input wire btnc,
    input wire btnd,
    output wire [7:0] seg,
    output wire [7:0] an,
    output wire led_hb
);
    wire rst, ent_pulse, ce_2s;
    reg [2:0] target_reg, curr_floor;
    reg [24:0] anim_cnt;

    always @(posedge clk_100MHz) anim_cnt <= anim_cnt + 1;

    debouncer d_rst (.clk(clk_100MHz), .btn_in(btnd), .btn_pulse(), .btn_level(rst));
    debouncer d_ent (.clk(clk_100MHz), .btn_in(btnc), .btn_pulse(ent_pulse), .btn_level());
    
    // Pastikan koneksi port .clk cocok dengan modulnya!
    clock_divider div (.clk(clk_100MHz), .reset(rst), .ce_2s(ce_2s), .led_hb(led_hb));

    always @(posedge clk_100MHz or posedge rst) begin
        if (rst) begin target_reg <= 0; curr_floor <= 0; end
        else begin
            if (ent_pulse && sw <= 4) target_reg <= sw;
            if (ce_2s) begin
                if (curr_floor < target_reg) curr_floor <= curr_floor + 1;
                else if (curr_floor > target_reg) curr_floor <= curr_floor - 1;
            end
        end
    end

    display_controller disp (
        .clk(clk_100MHz), .sw_val(sw), .current_val(curr_floor),
        .moving_up(curr_floor < target_reg), .moving_down(curr_floor > target_reg),
        .anim_step(anim_cnt[24:23]), .seg(seg), .an(an)
    );
endmodule