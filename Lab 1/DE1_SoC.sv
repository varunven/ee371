// Varun Venkatesh
// 1/15/2022
// EE/CSE 371
// Lab #1, DE1_SoC

//DE1_SoC is the top-level entity for the parking lot finite state machine model

//It accepts a 1-bit clock parameter, and a 34 bit GPIO_0 parameter

//It returns 2 specific 1-bit outputs from the GPIO_0 to satisfy 'enter' and 'exit' values
//It also returns a display through six 7-bit hex displays (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5)

//The hexes display CLeAr0 if the total count is 0, FULL if the total count has exceeded the max of 25, or the total count
//Implements the parkingLotFSM module to calculate necessary outputs
module DE1_SoC(CLOCK_50, GPIO_0, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    
	input logic CLOCK_50;
	inout logic [33:0] GPIO_0;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic enter, exit;
		
	//uses the parkingLotFSM module
	//provided CLOCK_50 as clock, GPIO_0[10] as reset, GPIO_0[12] as a, GPIO_0[14] as b, GPIO_0[26] as enter
	//GPIO_0[27] as exit, and HEX0 through HEX5 as HEX0 through HEX5
	parkingLotFSM fsm (.clock(CLOCK_50), .reset(GPIO_0[10]), .a(GPIO_0[12]), .b(GPIO_0[14]), .enter(enter), .exit(exit), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
	assign GPIO_0[26] = GPIO_0[12];
	assign GPIO_0[27] = GPIO_0[14];
endmodule
 
//DE1_SoCTestBench tests specific inputs on the DE1_SoC module- specifically common cases, unexpected cases, and edge cases
module DE1_SoCTestBench();

	logic clk;
	logic [33:0] GPIO_0;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
   DE1_SoC dut (.clock(clk), .GPIO_0(GPIO_0), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));
    
	parameter CLOCK_PERIOD=25;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.	
	initial begin
																
		GPIO_0[10] <= 1;	@(posedge clk);
		GPIO_0[10] <= 0; @(posedge clk);

		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);		
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);	
		GPIO_0[12] = 1; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 1; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 1; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);
		GPIO_0[12] = 0; GPIO_0[14] = 0; @(posedge clk);

		$stop;
	end
endmodule