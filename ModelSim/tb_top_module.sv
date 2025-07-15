// tb_top_module.sv
`timescale 1ns/1ps

module tb_top_module;

    // VGA 1024x768 @60Hz requires a pixel clock of 65 MHz
    // Clock period = 1 / 65 MHz = 15.3846153846 ns
    parameter CLK_PERIOD_NS = 15.3846153846;

    logic clk;
    logic reset;
    logic [7:0] R, G, B;
    logic hsync, vsync;

    // Internal signals to monitor from the UUT
    logic [10:0] pixel_x;
    logic [9:0]  pixel_y;
    logic active_video;
    
    // Delayed active_video signals to match data pipeline latency
    // Data (R,G,B) from mem_interfacing is 2 cycles delayed relative to pixel_x, pixel_y, active_video
    logic active_video_d1; // active_video delayed by 1 cycle
    logic active_video_d2; // active_video delayed by 2 cycles

    // Instantiate the Top Module (Unit Under Test)
    top_module uut (
        .clk(clk),
        .reset(reset),
        .R(R),
        .G(G),
        .B(B),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Connect internal signals for monitoring in the testbench
    assign pixel_x      = uut.sync_gen.pixel_x;
    assign pixel_y      = uut.sync_gen.pixel_y;
    assign active_video = uut.sync_gen.active_video;

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD_NS / 2.0) clk = ~clk;

    // Reset sequence
    initial begin
        reset = 1;
        #20; // Hold reset for a bit longer
        reset = 0;
    end

    // Waveform dumping for simulation analysis
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top_module);
    end

    // File I/O for capturing output pixels
    integer img_file;
    integer pixel_count = 0;

    initial begin
        // Open the output file for writing
        img_file = $fopen("ReconstructedImage.txt", "w");
        if (img_file == 0) begin
            $display("ERROR: Could not open ReconstructedImage.txt");
            $finish;
        end
    end

    // Pipeline the active_video signal to match the data latency
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            active_video_d1 <= 1'b0;
            active_video_d2 <= 1'b0;
        end else begin
            active_video_d1 <= active_video;
            active_video_d2 <= active_video_d1;
        end
    end

    // Capture pixels only during the active video region,
    // ensuring synchronization with the 2-cycle delayed RGB data.
    always_ff @(posedge clk) begin
        if (!reset && active_video_d2) begin // Use the 2-cycle delayed active_video
            $fwrite(img_file, "%0d %0d %0d\n", R, G, B);
            pixel_count++;
        end

        // Stop simulation after one full frame is captured
        if (pixel_count == 1024 * 768) begin
            $display("Captured full frame: 1024x768 pixels.");
            $fclose(img_file);
            $finish;
        end
    end

endmodule
