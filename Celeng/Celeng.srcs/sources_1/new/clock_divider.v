module clock_divider(
    input wire clk,          // Ini yang tadi bikin error!
    input wire reset,
    output reg ce_2s,        
    output reg led_hb        
);
    localparam MAX = 200_000_000; 
    reg [27:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0; ce_2s <= 0; led_hb <= 0;
        end else begin
            if (count >= MAX - 1) begin
                count <= 0; ce_2s <= 1; led_hb <= ~led_hb;
            end else begin
                ce_2s <= 0; count <= count + 1;
            end
        end
    end
endmodule