module mem_interfacing (
	input logic clk,
	input logic [10:0] pixel_x,
	input logic [9:0]  pixel_y,
	output logic [7:0] red, green, blue
);

	logic [23:0] frame [0:786431];
	logic [19:0] addr;
	logic [23:0] pixel;

initial begin
	$readmemh("SourceImage.hex", frame);
end

assign addr = (pixel_y * 1024) + pixel_x;

always_ff @(posedge clk) begin
	pixel <= frame[addr];

	red   <= pixel[23:16];
	green <= pixel[15:8];
        blue  <= pixel[7:0];
end

endmodule

