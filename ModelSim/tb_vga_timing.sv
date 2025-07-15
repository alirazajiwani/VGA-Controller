`timescale 1ns / 1ps

module tb_vga_timing;

    // Clock and reset
    logic clk;
    logic reset;

    // VGA signals
    logic hsync;
    logic vsync;
    logic active_video;
    logic [10:0] pixel_x;
    logic [9:0]  pixel_y;

    // Instantiate the DUT (Design Under Test)
    vga_timing dut (
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .active_video(active_video),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // Clock generation: 65 MHz => 15.38 ns period
    always #5 clk = ~clk; // Half-period toggle

    // Initial block to drive reset and monitor behavior
    initial begin

        // Initialize signals
        clk = 0;
        reset = 1;
        #50;
        reset = 0;

        // Run simulation for a few frames (~2 vertical frames)
        repeat (2 * 806 * 1344) @(posedge clk); // 2 full VGA frames

        $display("===== Simulation complete =====");
        $finish;
    end

endmodule

