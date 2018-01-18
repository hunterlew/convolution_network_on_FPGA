`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:49 04/19/2017 
// Design Name: 
// Module Name:    max_output 
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
module max_output(
	clk_in,
	rst_n,
	p_in,
	class_out
    );

input clk_in;
input rst_n;
input signed [19:0] p_in;
output reg [3:0] class_out = 0;

reg signed [19:0] max_tmp = 0;
reg [3:0] class_tmp = 0;
reg [3:0] cnt = 0;

always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		max_tmp <= 0;
		class_tmp <= 0;
	end
	else
	begin
		if(p_in > max_tmp)
		begin
			max_tmp <= p_in;
			class_tmp <= cnt;
		end
		else
		begin
			max_tmp <= max_tmp;
			class_tmp <= class_tmp;
		end
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		cnt <= 0;
		class_out <= 0;
	end
	else
	begin
		if(cnt == 11)
		begin
			cnt <= 11;
			class_out <= class_tmp;
		end
		else
		begin
			cnt <= cnt + 1;
			class_out <= 0;
		end
	end
end

endmodule
