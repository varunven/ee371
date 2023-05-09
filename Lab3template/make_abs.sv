// Varun Venkatesh
// 2/11/2022
// EE/CSE 371
// Lab #3, make_abs

//module make_abs_x is used for 10-bit logic and turns outputs their absolute value
//accepts a 10 bit logic in, outputs a 10-bit logic out
module make_abs_x(in, out);
	input logic [9:0] in;
	output logic [9:0] out;
	
	always_comb begin 
		if(in[9]) begin
			out = -in;
		end
		else begin
			out = in;
		end
	end
endmodule

//module make_abs_y is used for 9-bit logic and turns outputs their absolute value
//accepts a 9 bit logic in, outputs a 9-bit logic out
module make_abs_y(in, out);
	input logic [8:0] in;
	output logic [8:0] out;
	
	always_comb begin 
		if(in[8]) begin
			out = -in;
		end
		else begin
			out = in;
		end
	end
endmodule

//make_abs_testbench tests specific inputs on the main module- specifically common cases, unexpected cases, and edge cases
module make_abs_testbench();
	logic clk;
	logic [9:0] inx;
	logic [9:0] outx;
	logic [8:0] iny;
	logic [8:0] outy;
	
	make_abs_x xs (.in(inx), .out(outx));
	make_abs_y ys (.in(iny), .out(outy));
	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		inx <= 5; @(posedge clk);
		iny <= 3; @(posedge clk);
		inx <= -3; @(posedge clk);
		iny <= -9; @(posedge clk);
		inx <= 0; @(posedge clk);
		iny <= 0; @(posedge clk);
		$stop;
	end
endmodule
	

