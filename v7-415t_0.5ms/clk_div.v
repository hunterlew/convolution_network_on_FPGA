`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:01 02/24/2017 
// Design Name: 
// Module Name:    clk_div 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div(
   clk_in,
	rst_n,
	n,
   clk_out
   );

input clk_in;
input rst_n;	
input [3:0] n; 
output reg clk_out = 0;

reg [3:0] cnt = 1;	//trick

always @ (posedge clk_in)
begin
	if (rst_n)
	begin
		cnt <= 1;	//trick
		clk_out <= 0;
	end
	else
	begin
		if (cnt == (n - 1) >> 1)
		begin
			cnt <= cnt + 1;
			clk_out <= 0;	
		end
		else if (cnt == n - 1)
		begin
			cnt <= 0;
			clk_out <= 1;	
		end
		else
		begin
			cnt <= cnt + 1;
			clk_out <= clk_out;
		end
	end
end
		
endmodule
