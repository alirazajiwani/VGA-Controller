module vga_timing (
    input  logic clk,
    input  logic reset,
    output logic hsync,
    output logic vsync,
    output logic [10:0] pixel_x,
    output logic [9:0]  pixel_y,
    output logic active_video
);

    // VGA 1024x768 @ 60Hz timing parameters
    parameter H_A  = 1024;   // Horizontal active
    parameter H_FP = 24;
    parameter H_S  = 136;
    parameter H_BP = 160;
    parameter H_TOTAL = H_A + H_FP + H_S + H_BP;

    parameter V_A  = 768;    // Vertical active
    parameter V_FP = 3;
    parameter V_S  = 6;
    parameter V_BP = 29;
    parameter V_TOTAL = V_A + V_FP + V_S + V_BP;

    // FSM states
    typedef enum logic [2:0] {
        Idle,
        Vbp,
        Hbp,
        Ha,
        Hfp,
        Hs,
        Vfp,
        Vs
    } state_t;

    state_t CS;

    // Counters
    logic [10:0] h_count;
    logic [9:0]  v_count;
    logic [9:0]  v_line;  // Tracks visible line number

    // FSM
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            CS <= Idle;
            h_count <= 0;
            v_count <= 0;
            v_line  <= 0;
        end else begin
            case (CS)
                Idle: begin
                    CS <= Vbp;
                    h_count <= 0;
                    v_count <= 0;
                    v_line  <= 0;
                end

                Vbp: begin
                    if (v_count == V_BP - 1) begin
                        v_count <= 0;
                        CS <= Hbp;
                    end else begin
                        v_count <= v_count + 1;
                    end
                end

                Hbp: begin
                    if (h_count == H_BP - 1) begin
                        h_count <= 0;
                        CS <= Ha;
                    end else begin
                        h_count <= h_count + 1;
                    end
                end

                Ha: begin
                    if (h_count == H_A - 1) begin
                        h_count <= 0;
                        CS <= Hfp;
                    end else begin
                        h_count <= h_count + 1;
                    end
                end

                Hfp: begin
                    if (h_count == H_FP - 1) begin
                        h_count <= 0;
                        CS <= Hs;
                    end else begin
                        h_count <= h_count + 1;
                    end
                end

                Hs: begin
                    if (h_count == H_S - 1) begin
                        h_count <= 0;
                        if (v_line == V_A - 1) begin
                            v_line <= 0;
                            CS <= Vfp;
                        end else begin
                            v_line <= v_line + 1;
                            CS <= Hbp;
                        end
                    end else begin
                        h_count <= h_count + 1;
                    end
                end

                Vfp: begin
                    if (v_count == V_FP - 1) begin
                        v_count <= 0;
                        CS <= Vs;
                    end else begin
                        v_count <= v_count + 1;
                    end
                end

                Vs: begin
                    if (v_count == V_S - 1) begin
                        v_count <= 0;
                        CS <= Vbp;
                    end else begin
                        v_count <= v_count + 1;
                    end
                end

                default: CS <= Idle;
            endcase
        end
    end

    // Output assignments
    assign hsync        = (CS == Hs) ? 1'b0 : 1'b1;   // active low
    assign vsync        = (CS == Vs) ? 1'b0 : 1'b1;   // active low
    assign active_video = (CS == Ha);                // high during visible region
    assign pixel_x      = (CS == Ha) ? h_count : 11'd0;
    assign pixel_y      = (CS == Ha) ? v_line  : 10'd0;

endmodule

