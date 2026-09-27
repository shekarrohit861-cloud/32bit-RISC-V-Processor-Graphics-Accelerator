module riscv_gpu_soc(
    input clk,
    input reset,
    output hsync,
    output vsync,
    output [3:0] vga_r, vga_g, vga_b,
    output [31:0] debug_pc,
    output [31:0] debug_instruction,
    output [31:0] debug_gpu_status,
    output debug_gpu_start,
    output debug_gpu_busy,
    output debug_gpu_done,
    output debug_pixel_valid
);
    wire [31:0] instr;
    wire [31:0] daddr, dwdata, drdata;
    wire dwe, dre;

    instruction_rom imem(.addr(debug_pc), .data(instr));
    riscv32_single_cycle cpu(
        .clk(clk), .reset(reset), .instruction(instr), .mem_rdata(drdata),
        .pc(debug_pc), .mem_addr(daddr), .mem_wdata(dwdata),
        .mem_we(dwe), .mem_re(dre),
        .debug_alu(), .debug_rs1(), .debug_rs2(), .debug_wb()
    );
    assign debug_instruction = instr;

    wire ram_sel = (daddr[31:10] == 22'd0);
    wire gpu_sel = (daddr[31:16] == 16'h4000);

    wire [31:0] ram_rdata;
    data_memory ram(
        .clk(clk), .we(dwe && ram_sel), .re(dre && ram_sel),
        .addr(daddr), .wdata(dwdata), .rdata(ram_rdata)
    );

    wire gpu_start, gpu_busy, gpu_done;
    wire [9:0] gx0, gy0, gx1, gy1;
    wire [11:0] gcolor;
    wire [31:0] status;

    gpu_mmio mmio(
        .clk(clk), .reset(reset),
        .we(dwe && gpu_sel), .addr(daddr), .wdata(dwdata),
        .start(gpu_start), .x0(gx0), .y0(gy0), .x1(gx1), .y1(gy1),
        .color(gcolor), .busy(gpu_busy), .done(gpu_done), .status(status)
    );

    wire [9:0] gpu_px, gpu_py;
    wire [11:0] gpu_color;
    wire gpu_pvalid;

    parallel_graphics_accelerator gpu(
        .clk(clk), .reset(reset), .start(gpu_start),
        .x0(gx0), .y0(gy0), .x1(gx1), .y1(gy1), .color(gcolor),
        .busy(gpu_busy), .done(gpu_done),
        .pixel_x(gpu_px), .pixel_y(gpu_py), .pixel_color(gpu_color),
        .pixel_valid(gpu_pvalid)
    );

    assign drdata = ram_sel ? ram_rdata : gpu_sel ? status : 32'h00000000;

    wire [8:0] vga_x;
    wire [7:0] vga_y;
    wire [11:0] framebuffer_pixel;

    framebuffer fb(
        .clk(clk),
        .we(gpu_pvalid && (gpu_px < 320) && (gpu_py < 240)),
        .wx(gpu_px[8:0]), .wy(gpu_py[7:0]), .wdata(gpu_color),
        .rx(vga_x), .ry(vga_y), .rdata(framebuffer_pixel)
    );

    vga_controller vga(
        .clk100(clk), .reset(reset), .pixel(framebuffer_pixel),
        .fb_x(vga_x), .fb_y(vga_y),
        .hsync(hsync), .vsync(vsync), .r(vga_r), .g(vga_g), .b(vga_b)
    );

    assign debug_gpu_status = status;
    assign debug_gpu_start = gpu_start;
    assign debug_gpu_busy = gpu_busy;
    assign debug_gpu_done = gpu_done;
    assign debug_pixel_valid = gpu_pvalid;
endmodule
