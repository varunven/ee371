// Varun Venkatesh
// 2/11/2022
// EE/CSE 371
// Lab #3, DE1_SoC

//DE1_SoC is the top-level entity for Lab 3, Tasks 1 and 2
//This is an implementation of Bresenham's line drawing algorithm 

//It accepts a 4 bit KEY, and a 10 bit switch, and an input CLOCK_50
//It outputs six 7 bit HEX diplays (HEX5, HEX4, HEX3, HEX2, HEX1, HEX0), a 
//10 bit LEDR, three 8-bit outputs (VGA_R, VGA_G, VGA_B), five output logics...
//(VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS)

//It uses three 10-bit logics x1, x0, x and three 9-bit logics y1, y0, y to...
// represent the line
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	logic [9:0] x0, x1, x;
	logic [8:0] y0, y1, y;
	logic frame_start;
	logic pixel_color, reset, change;
	
	assign reset = SW[8];
	
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
	
	// draw lines between (x0, y0) and (x1, y1)
	line_drawer lines (.clk(CLOCK_50), .reset, .change
				.x0, .y0, .x1, .y1, .x, .y);

	animate animation (.clk(CLOCK_50), .reset, .change, .pixel_color, .x0, .y0, .x1, .y1);

endmodule



//DE1_SoC_testbench tests specific inputs on the main module- specifically common cases, unexpected cases, and edge cases
module DE1_SoC_testbench();

	logic clk;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	logic [7:0] VGA_R;
	logic [7:0] VGA_G;
	logic [7:0] VGA_B;
	logic VGA_BLANK_N;
	logic VGA_CLK;
	logic VGA_HS;
	logic VGA_SYNC_N;
	logic VGA_VS;
	
	DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .CLOCK_50(clk), 
		.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.	
	integer i;
	initial begin
		SW[8] <= 1;
		SW[8] <= 0; repeat(500) @(posedge clk);
		$stop;
	end
endmodule