`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:36:39 02/28/2017 
// Design Name: 
// Module Name:    m_max_relu_4 
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
module m_max_relu_4(
	clk_in,
	rst_n,
	map_in,
	map_out,
	wr,
	ready
    );

parameter max_stride = 4'd8;	//在多少个数中取最大值-1
parameter num_out = 6'd36;	//输出map大小

input clk_in;
input rst_n;
input signed [15:0] map_in;
output reg signed [15:0] map_out = 0;
output reg wr = 0;	//前后数据速率不一样，要用ram缓存
output reg ready = 1;	//下一级的低复位

reg signed [15:0] tmp_max = 0;
reg [3:0] cnt_stride = 0;

reg [5:0] out_cnt = 0;

always @ (posedge clk_in)
begin
	if (rst_n)
	begin
		tmp_max <= 0;	//把relu考虑进去
		cnt_stride <= 0;
		map_out <= 0;
		wr <= 0;
		out_cnt <= out_cnt;
	end
	else
	begin
		if (cnt_stride == max_stride)
		begin
			tmp_max <= 0;
			cnt_stride <= 0;
			if (map_in > tmp_max)
				map_out <= map_in;
			else
				map_out <= tmp_max;
			wr <= 1;
			out_cnt <= out_cnt + 1;
		end
		else
		begin
			if (map_in > tmp_max)
				tmp_max <= map_in;
			else
				tmp_max <= tmp_max;
			cnt_stride <= cnt_stride + 1;
			map_out <= map_out;
			wr <= 0;
			out_cnt <= out_cnt;
		end
	end
end

always @ (posedge clk_in)
begin
	if (out_cnt == num_out)
		ready <= 0;
	else
		ready <= 1;
end		

endmodule
