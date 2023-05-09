// Varun Venkatesh
// 2/11/2022
// EE/CSE 371
// Lab #3, line_drawer

//line_drawer is a module that when given specific start and end coordinates,
//uses Bresenham's algorithm to draw pixels that make up a line between said coordinates

//It accepts 2 boolean logics clk and reset, two 10-bit logics x0 and x1,
// three 9-bit logics y0 and y1
//It outputs a 10-bit logic x, a 9-bit logic y, and an output logic done_drawing

//It uses intermediate 12-bit logic error, 10-bit logics (dx, abs_dx, currx0,...
//currx1, wr_x), 9-bit logics (dy, abs_dy, curry0, curry1, wr_y), 2-bit logic yjump,
//3 bit logic state, 1-bit logic steep

//It uses the make_abs_x and make_abs_y modules
module line_drawer(
	input logic clk, reset,
	
	// x and y coordinates for the start and end points of the line
	input logic [9:0]	x0, x1, 
	input logic [8:0] y0, y1,

	//outputs cooresponding to the coordinate pair (x, y)
	output logic [9:0] x,
	output logic [8:0] y,
	output logic change
	);
	
	//used to readjust pixels by whole numbers
	logic signed [11:0] error;
	//represent the change in x, absolute value of said change
	logic signed [9:0] dx, abs_dx;
	//represent the change in y, absolute value of said change
	logic signed [8:0] dy, abs_dy;
	//used to keep track of current pixel drawings and when to update colored pixels
	logic signed [9:0] currx0, currx1, wr_x;
	logic signed [8:0] curry0, curry1, wr_y;
	//used to keep track of which direction y is increasing/decreasing
	logic signed [1:0] yjump;
	//is_steep or not
	logic steep;
	
	//used to keep track of FSM
	
	enum {temps, swap, out, write_out} state;
	
	//generate abs_val of difference
	make_abs_x absdeltax (.in(dx), .out(abs_dx));
	make_abs_y absdeltay (.in(dy), .out(abs_dy));
	
	//runs on positive clock edge and creates the pixels that need to be colored
	//resets to starting position of (0,0), update certain values depending on state
	always_ff @(posedge clk) begin
		if(reset) begin
			dx <= 0;
			dy <= 0;
			error <= 0;
			yjump <= 1;
			steep <= 0;
			state <= temps;
			x <= 0;
			y <= 0;
			change <= 1;
		end
		else if(state == temps) begin
			dx <= x1 - x0;
			dy <= y1 - y0;
			steep <= abs_dy > abs_dx;
			currx0 <= x0;
			currx1 <= x1;
			curry0 <= y0;
			curry1 <= y1;
			state <= swap;
		end
		else if(state == swap) begin
			if(steep) begin
				if(curry0 > curry1) begin
					currx0 <= curry1; 
					currx1 <= curry0;
					curry0 <= currx1;
					curry1 <= currx0;
					dx <= curry0 - curry1;
					if(currx1 > currx0) begin dy<= currx1-currx0; end
					else begin dy<= currx0-x1; end
				end
				else begin 
					currx0 <= curry0;
					currx1 <= curry1; 
					curry0 <= currx0;
					curry1 <= currx1;
					dx <= curry1 - curry0;
					if(currx1 > currx0) begin dy<= currx1-currx0; end
					else begin dy<= currx0-currx1; end
				end
			end
			else begin
				if(currx0 > x1) begin
					currx0 <= currx1;
					currx1 <= currx0;
					curry0 <= curry1;
					curry1 <= curry0;
					dx <= currx0-currx1;
					if(curry1 > curry0) begin dy<= curry1-curry0; end
					else begin dy<= curry0-curry1; end
				end
				else begin 
					dx <= currx1 - currx0;
					if(curry1 > curry0) begin dy<= curry1-curry0; end
					else begin dy<= curry0-curry1; end
				end
				state <= out;
			end
		end
		else if (state == out) begin
			error <= dx/2;
			if(y0<y1) begin yjump <= 1; end 
			else begin yjump <= -1; end
			wr_x <= x0;
			wr_y <= y0;
			state <= write_out;
		end
		
		else if(state == write_out) begin
			if(steep) begin
				x <= wr_y;
				y <= wr_x;
			end
			else begin
				x <= wr_x;
				y <= wr_y;
			end
			
			wr_x <= wr_x + 1;
			
			if(error - dy <0) begin
					error <= error - dy + dx;
					wr_y <= wr_y + yjump;
			end
			else begin
				error <= error - dy;
			end
			
			if(x == x1) begin
				change <= 1;
				state <= temps;
			end
			else begin
				change <= 0;
			end
		end
		
	end	//end of always_ff
endmodule

//line_drawer_testbench tests specific inputs on the main module- specifically common cases, unexpected cases, and edge cases
module line_drawer_testbench();
	logic clk, reset;
	logic [9:0] x0, x1, x;
	logic [8:0]	y0, y1, y;
	
	line_drawer dut (.clk(clk), .reset(reset), .x0(x0), .x1(x1), .y0(y0), .y1(y1), .x(x), .y(y));
	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; 
		//(1,1) to (12,5)
		repeat(20) begin
			x0 <= 11'b00000000001; y0 <= 11'b00000000001; x1 <= 11'b00000001100; y1 <= 11'b00000000101; 	@(posedge clk); // diagonal																							
		end
		reset <= 1; @(posedge clk);
		reset <= 0;
		//(
		repeat(20) begin
			x0 <= 11'b00000000001; y0 <= 11'b00000000001; x1 <= 11'b00000000100; y1 <= 11'b00000000001; @(posedge clk); // horizontal
		end
		reset <= 1; @(posedge clk);
		reset <= 0;
		repeat(20) begin
			x0 <= 11'b00000000001; y0 <= 11'b00000000001; x1 <= 11'b0000000001; y1 <= 11'b00000001111; 	@(posedge clk); // vertical 
		end
																														
		$stop;
	end
endmodule