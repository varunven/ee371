// Varun Venkatesh
// 2/11/2022
// EE/CSE 371
// Lab #3, animate

//animate is a module that creates parameters to draw specific lines on the monitor

//It accepts 2 boolean logics clk, reset
//It outputs 1 boolean logic pixel_color, two 10-bit logics x0, x1, and two 9-bit...
//logics y0, y1

//It accepts 2 boolean logics clk and reset, two 10-bit logics x0 and x1,
// three 9-bit logics y0 and y1
//It outputs a 10-bit logic x, a 9-bit logic y

//It uses intermediate 12-bit logic error, 10-bit logics (dx, abs_dx, currx0,...
//currx1, wr_x), 9-bit logics (dy, abs_dy, curry0, curry1, wr_y), 2-bit logic yjump,
//3 bit logic state, 1-bit logic steep
module animate(clk, reset, pixel_color, x0, y0, x1, y1, change);
	
	input logic clk, reset, change;
	output logic pixel_color;
	output logic [9:0] x0, x1;
	output logic [8:0] y0, y1;
	
	//used for FSM
	enum {line1, line2, line3, line4, eraseline1, eraseline2, eraseline3, eraseline4} ps, ns;
	
	//parameters used to decide color
	parameter black = 1'b0;
	parameter white = 1'b1;

	//always_comb used to change the states to the corresponding following lines
	always_comb begin
		case(ps)
			line1: begin ns = eraseline1; pixel_color = white; x0 = 0; y0 = 0; x1 = 60; y1 = 60; end
			line2: begin ns = eraseline2; pixel_color = white; x0 = 0; y0 = 0; x1 = 20; y1 = 20; end
			line3: begin ns = eraseline3; pixel_color = white; x0 = 50; y0 = 50; x1 = 200; y1 = 50; end
			line4: begin ns = eraseline4; pixel_color = white; x0 = 200; y0 = 200; x1 = 400; y1 = 50; end
			eraseline1: begin ns = line2; pixel_color = white; x0 = 0; y0 = 0; x1 = 60; y1 = 60; end
			eraseline2: begin ns = line3; pixel_color = white; x0 = 0; y0 = 0; x1 = 20; y1 = 20; end
			eraseline3: begin ns = line4; pixel_color = white; x0 = 50; y0 = 50; x1 = 200; y1 = 50; end
			eraseline4: begin ns = line1; pixel_color = white; x0 = 200; y0 = 200; x1 = 400; y1 = 50; end
		endcase
	end
	
	//always_ff on clock edge used to update x0, x1, y0, y1, pixel_color, and the state
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= line1;
		end else begin
			ps <= ns;
			change <= 1;
		end
	end
endmodule

//animate_testbench tests specific inputs on the main module- specifically common cases, unexpected cases, and edge cases
module animate_testbench();
	logic clk, reset;
	logic [9:0] x0, x1;
	logic [8:0] y0, y1;
	logic pixel_color;
	
	animate dut (.clk, .reset, .pixel_color, .x0, .x1, .y0, .y1);
	
	parameter CLOCK_PERIOD=25;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
	reset <= 1; @(posedge clk);
	reset <= 0; @(posedge clk);
				   @(posedge clk);
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);	
				   @(posedge clk);
				   @(posedge clk);
	$stop; //end simulation							
					
	end //initial
endmodule