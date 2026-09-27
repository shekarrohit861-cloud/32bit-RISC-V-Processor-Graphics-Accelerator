// 640x480 @ 60 Hz VGA using the Nexys A7 100 MHz board clock.
// A clock-enable pulse every 4 system-clock cycles gives an exact 25 MHz
// pixel rate without creating a second fabric clock.
module vga_controller(
    input        clk100,
    input        reset,
    input [11:0] pixel,
    output reg [8:0]  fb_x,
    output reg [7:0]  fb_y,
    output reg        hsync,
    output reg        vsync,
    output reg [3:0]  r,
    output reg [3:0]  g,
    output reg [3:0]  b
);
    reg [1:0] div4;
    reg [9:0] h;
    reg [9:0] v;

    // Framebuffer is 320x240. Each framebuffer pixel is shown as a 2x2
    // block on the 640x480 VGA output.
    wire [8:0] read_x = h[9:1];
    wire [7:0] read_y = v[8:1];

    always @(posedge clk100) begin
        if (reset) begin
            div4 <= 2'd0;
            h <= 10'd0;
            v <= 10'd0;
            fb_x <= 9'd0;
            fb_y <= 8'd0;
            hsync <= 1'b1;
            vsync <= 1'b1;
            r <= 4'h0;
            g <= 4'h0;
            b <= 4'h0;
        end else begin
            if (div4 == 2'd3) begin
                div4 <= 2'd0;

                // 640 active + 16 front porch + 96 sync + 48 back porch = 800
                if (h == 10'd799) begin
                    h <= 10'd0;
                    if (v == 10'd524)
                        v <= 10'd0;
                    else
                        v <= v + 10'd1;
                end else begin
                    h <= h + 10'd1;
                end

                // Active-low sync pulses.
                hsync <= !((h >= 10'd656) && (h < 10'd752));
                vsync <= !((v >= 10'd490) && (v < 10'd492));

                fb_x <= read_x;
                fb_y <= read_y;

                if ((h < 10'd640) && (v < 10'd480)) begin
                    r <= pixel[11:8];
                    g <= pixel[7:4];
                    b <= pixel[3:0];
                end else begin
                    r <= 4'h0;
                    g <= 4'h0;
                    b <= 4'h0;
                end
            end
        end
    end
endmodule
