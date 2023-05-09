// Varun Venkatesh
// 1/15/2022
// EE/CSE 371
// Lab #1, counter

//counter generates a finite state machine to solve for the current number of cars in the parking lot

//It accepts a 1-bit clock, a 1-bit reset, a 5-bit counts, a 1-bit inc, and a 1-bit dec
//inc represents if the total number of cars should be incremented, dec represents if it should be decremented

//It returns counts which represents the total number of cars currently in the lot, 
//counts has a maximum value of 25 and a minimum value of 0
//It also returns a display through six 7-bit hex displays (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5)

//It uses two 4-bit logics ones and tenss to keep track of the units and tens digit to show on the hex display
//The hexes display CLeAr0 if counts is 0, FULL if counts is greater than 25, or counts itself
module counter(clock, reset, counts, inc, dec, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input logic clock, reset, inc, dec;
	output logic [4:0] counts;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic [3:0] ones, tenss;
	
	//always_comb block is used to calculate first digit and second digit of counts and display it on the HEX
	//if counts is 0 then it shows CleAr0, if counts is greater than 25 it shows FULL
	always_comb begin
		ones = counts%10;
		tenss = (counts/10)%10;
		if(counts == 0) begin
			HEX0 = 7'b1000000;
			HEX1 = 7'b0101111;
			HEX2 = 7'b0001000; 
			HEX3 = 7'b0000110; 
			HEX4 = 7'b1000111; 
			HEX5 = 7'b1000110; 
		end
		else if(counts >= 25) begin
			HEX0 = 7'b1111111;
			HEX1 = 7'b1111111;
			HEX2 = 7'b1000111; 
			HEX3 = 7'b1000111; 
			HEX4 = 7'b1000001;  
			HEX5 = 7'b0001110; 
		end
		else begin
			HEX2 = 7'b1111111;
			HEX3 = 7'b1111111; 
			HEX4 = 7'b1111111; 
			HEX5 = 7'b1111111; 
			if (ones==1) begin
				HEX0 = 7'b1111001; 
			end else if (ones == 2) begin
				HEX0 = 7'b0100100; 
			end else if (ones == 3) begin
				HEX0 = 7'b0110000; 
			end else if (ones == 4) begin
				HEX0 = 7'b0011001; 
			end else if (ones == 5) begin
				HEX0 = 7'b0010010; 
			end else if (ones == 6) begin
				HEX0 = 7'b0000010; 
			end else if (ones == 7) begin
				HEX0 = 7'b1111000; 
			end else if (ones == 8) begin
				HEX0 = 7'b0000000; 
			end else if (ones == 9) begin
				HEX0 = 7'b0011000; 
			end else begin
				HEX0 = 7'b1000000; //default 0
			end
		
			if (tenss==1) begin
				HEX1 = 7'b1111001; 
			end else if (tenss == 2) begin
				HEX1 = 7'b0100100; 
			end else begin
				HEX1 = 7'b1000000; //default 0
			end
		end
	end
	
	//always_ff block is used to either increment or decrement counts based on inc and dec, or reset the machine
	//counts will no increment further if it is already 25 and it will not decrement any less if it is already 0
	always_ff @(posedge clock) begin
		if (reset) begin counts <= 0; end
		else begin 
			if(inc && counts<25) begin counts <= counts+1; end
			if(dec && counts>0) begin counts <= counts-1; end
		end
	end
endmodule

//counterTestBench tests common cases, unexpected cases, and edge cases on parkingLotFSM
module counterTestBench();

	logic clk;
	logic [4:0] counts;
	logic [2:0] SW;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	counter dut (.clock(clk), .reset(SW[2]), .counts(counts), .inc(SW[0]), .dec(SW[1]), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	parameter CLOCK_PERIOD=50;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																
		SW[2] <= 1;	@(posedge clk);
		SW[2] <= 0; @(posedge clk);

		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);

		SW[2] <= 1;	@(posedge clk);
		SW[2] <= 0; @(posedge clk);
		
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 1; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		$stop;
	end
endmodule