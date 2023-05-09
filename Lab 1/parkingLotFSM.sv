// Varun Venkatesh
// 1/15/2022
// EE/CSE 371
// Lab #1, parkingLotFSM

//parkingLotFSM generates a finite state machine to solve for the current state of a car in the parking lot 
//Calculates if the current car is entering or exiting and the total number of cars currently entered but not exited

//It accepts a 1-bit clock parameter, a 1-bit reset parameter, a 1-bit a-sensor parameter, and a 1-bit b-sensor parameter
//The a and b parameters represent if a car is in front of the a and b sensors or not, respectively

//It uses a 5-bit logic counts to keep track of the total number of cars currently entered but not exited

//It returns 2 specific 1-bit outputs from the GPIO_0 to satisfy 'enter' and 'exit' values
//It also returns a display through six 7-bit hex displays (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5)

//The hexes display CLeAr0 if the total count is 0, FULL if the total count has exceeded the max of 25, or the total count
//Implements the counter module to calculate necessary outputs

module parkingLotFSM(clock, reset, a, b, enter, exit, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    
	input logic clock, reset, a, b;
	output logic enter, exit;
	logic [4:0] counts;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		
	enum {none, entera, enterab, enterb, exitb, exitab, exita} ps, ns;

	//The always_comb block is used to move from state to state with the car either being in the entry or exiting process
	always_comb begin
		case(ps)
			none:
				if(a && !b) begin enter = 0; exit = 0; ns = entera; end
				else if(b && !a) begin enter = 0; exit = 0; ns = exitb; end
				else begin enter = 0; exit = 0; ns = none; end
			entera:
				if(!a) begin enter = 0; exit = 0; ns = none; end
				else if (b) begin enter = 0; exit = 0; ns = enterab; end
				else begin enter = 0; exit = 0; ns = entera; end
			enterab:
				if(!a && !b) begin enter = 0; exit = 0; ns = none; end
				else if(!a) begin enter = 0; exit = 0; ns = enterb; end
				else if(!b) begin enter = 0; exit = 0; ns = entera; end
				else begin enter = 0; exit = 0; ns = enterab; end
			enterb:
				if(!b && !a) begin enter = 1; exit = 0; ns = none; end
				else if(a) begin enter = 0; exit = 0; ns = enterab; end
				else begin enter = 0; exit = 0; ns = enterb; end	
			exitb: 
				if(!b) begin enter = 0; exit = 0; ns = none; end
				else if(a) begin enter = 0; exit = 0; ns = exitab; end
				else begin enter = 0; exit = 0; ns = exitb; end
			exitab:
				if(!a && !b) begin enter = 0; exit = 0; ns = none; end
				else if(!a) begin enter = 0; exit = 0; ns = exitb; end
				else if(!b) begin enter = 0; exit = 0; ns = exita; end
				else begin enter = 0; exit = 0; ns = exitab; end
			exita:
				if(a && b) begin enter = 0; exit = 0; ns = exitab; end
				else if(!a) begin enter = 0; exit = 1; ns = none; end
				else begin enter = 0; exit = 0; ns = exita; end
		endcase		
	end
	
	//uses the counter module
	//uses the parkingLotFSM module
	//provided clock as clock, reset as reset, counts as counts, enter as inc, exit as dec, 
	//and HEX0 through HEX5 as HEX0 through HEX5
	counter countUp (.clock(clock), .reset(reset), .counts(counts), .inc(enter), .dec(exit), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));

	//always_ff block is used to either transition from current state to next state, or reset the machine
	always_ff @(posedge clock) begin
		if (reset)
			ps <= none;
		else
			ps <= ns;
	end
    
endmodule

//parkingLotFSMTestBench tests common cases, unexpected cases, and edge cases on parkingLotFSM
module parkingLotFSMTestBench();

	logic clk;
   logic [2:0] SW;
	logic [1:0] LEDR;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
   parkingLotFSM dut (.clock(clk), .reset(SW[2]), .a(SW[0]), .b(SW[1]), .enter(LEDR[0]), .exit(LEDR[1]), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
    
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
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 1; @(posedge clk);		
		
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 1; SW[1] = 1; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 1; SW[1] = 1; @(posedge clk);	
		
		SW[0] = 1; SW[1] = 1; @(posedge clk);	
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		
		SW[0] = 1; SW[1] = 1; @(posedge clk);	
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 1; SW[1] = 1; @(posedge clk);	
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		
		SW[0] = 1; SW[1] = 1; @(posedge clk);	
		SW[0] = 1; SW[1] = 0; @(posedge clk);
		SW[0] = 0; SW[1] = 1; @(posedge clk);
		SW[0] = 0; SW[1] = 0; @(posedge clk);
		$stop;
	end
endmodule