`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:08:07 02/24/2017
// Design Name:   CNN_top
// Module Name:   D:/CNN_FPGA_v1..1/mstar/tb.v
// Project Name:  mstar
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CNN_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk_in;
	reg rst_n;

	// Outputs
	wire [3:0] class;

	// Instantiate the Unit Under Test (UUT)
	CNN_top uut (
		.clk_in(clk_in), 
		.rst_n(rst_n), 
		.class(class)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst_n = 1;

		// Wait 100 ns for global reset to finish
		#100;
      rst_n = 0;  
		// Add stimulus here
		
		#310000 $stop;

	end
	
	always #5 clk_in = ~clk_in;	//100M
      
endmodule
