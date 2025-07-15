module top_module (
    input logic clk,
    input logic reset,
    output logic [7:0] R, G, B,
    output logic hsync, vsync
);
    logic active_video;
    logic [10:0] pixel_x;
    logic [9:0] pixel_y;
    logic [7:0] red, green, blue;
    
    // Pipeline registers to synchronize active_video with RGB data
    logic active_video_d1, active_video_d2;
    
    vga_timing sync_gen (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .active_video(active_video),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    
    mem_interfacing mem (
        .clk(clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    always_ff @(posedge clk) begin
        if (reset) begin
            active_video_d1 <= 1'b0;
            active_video_d2 <= 1'b0;
        end else begin
            active_video_d1 <= active_video;
            active_video_d2 <= active_video_d1;
        end
    end
    
    // Fixed: Remove extra always_ff block and use combinational logic
    // The RGB outputs should be driven combinationally to avoid additional delay
    assign R = active_video_d2 ? red : 8'b0;
    assign G = active_video_d2 ? green : 8'b0;
    assign B = active_video_d2 ? blue : 8'b0;
    
endmodule
