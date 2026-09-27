// Simple rectangle graphics accelerator.
// One framebuffer pixel is generated per 100 MHz system clock.
module parallel_graphics_accelerator(
    input clk,
    input reset,
    input start,
    input [9:0] x0, y0, x1, y1,
    input [11:0] color,
    output reg busy,
    output reg done,
    output reg [9:0] pixel_x,
    output reg [9:0] pixel_y,
    output reg [11:0] pixel_color,
    output reg pixel_valid
);
    reg [9:0] cur_x, cur_y;
    reg [9:0] min_x, min_y, max_x, max_y;
    reg [11:0] draw_color;

    always @(posedge clk) begin
        if (reset) begin
            busy <= 1'b0;
            done <= 1'b0;
            pixel_valid <= 1'b0;
            pixel_x <= 10'd0;
            pixel_y <= 10'd0;
            pixel_color <= 12'h000;
            cur_x <= 10'd0;
            cur_y <= 10'd0;
            min_x <= 10'd0;
            min_y <= 10'd0;
            max_x <= 10'd0;
            max_y <= 10'd0;
            draw_color <= 12'h000;
        end else begin
            done <= 1'b0;
            pixel_valid <= 1'b0;

            if (start && !busy) begin
                min_x <= (x0 <= x1) ? x0 : x1;
                min_y <= (y0 <= y1) ? y0 : y1;
                max_x <= (x0 <= x1) ? x1 : x0;
                max_y <= (y0 <= y1) ? y1 : y0;
                cur_x <= (x0 <= x1) ? x0 : x1;
                cur_y <= (y0 <= y1) ? y0 : y1;
                draw_color <= color;
                busy <= 1'b1;
            end else if (busy) begin
                // Only generate coordinates that fit the 320x240 framebuffer.
                if (cur_x < 320 && cur_y < 240) begin
                    pixel_valid <= 1'b1;
                    pixel_x <= cur_x;
                    pixel_y <= cur_y;
                    pixel_color <= draw_color;
                end

                if (cur_x >= max_x) begin
                    if (cur_y >= max_y) begin
                        busy <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cur_x <= min_x;
                        cur_y <= cur_y + 10'd1;
                    end
                end else begin
                    cur_x <= cur_x + 10'd1;
                end
            end
        end
    end
endmodule
