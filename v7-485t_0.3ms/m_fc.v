`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:43:47 04/15/2017 
// Design Name: 
// Module Name:    m_fc 
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
module m_fc(
	clk_in,
	rst_n,
	fan_in,
	fan_out,
	ready
    );

parameter num_in = 7'd120;	//输入数量
parameter num_out = 4'd10;	//输出数量

input clk_in;
input rst_n;
input signed [15:0] fan_in;
output reg signed [19:0] fan_out = 0;
output reg ready = 1;

wire signed [15:0] k [num_out-1:0];
wire signed [31:0] mult [num_out-1:0];
reg signed [31:0] out_tmp [num_out-1:0];
reg signed [19:0] out_tmp2 [num_out-1:0];
reg signed [15:0] out_tmp3 [num_out-1:0];

reg [10:0] addr_k [num_out-1:0];
wire [10:0] addr_k_tmp [num_out-1:0];
reg [6:0] out_cnt = 0;
reg [3:0] j;

reg rst_tmp = 1;
reg rst_tmp2 = 1;
reg rst_tmp3 = 1;
reg rst_tmp4 = 1;

reg [3:0] out_cnt2 = 0;

always @ (posedge clk_in)
begin
	rst_tmp <= rst_n;
	rst_tmp2 <= rst_tmp;
	rst_tmp3 <= rst_tmp2;
	rst_tmp4 <= rst_tmp3;
end

always @ (posedge clk_in)
begin
	if (rst_tmp4) 
	begin
		for(j=0;j<num_out;j=j+1)	
			addr_k[j] <= addr_k_tmp[j];
		out_cnt <= 0;
	end
	else
	begin
		if (out_cnt >= num_in-1)	//在此基础上循环输出卷积参数以完成卷积	
		begin
			for(j=0;j<num_out;j=j+1)	
				addr_k[j] <= addr_k[j];
		end
		else
		begin
			for(j=0;j<num_out;j=j+1)		
				addr_k[j] <= addr_k[j] + 1;
		end
		
		if(out_cnt == 125)
			out_cnt <= 125;
		else
			out_cnt <= out_cnt + 1;		
	end
end

genvar m;	
generate
	for (m = 0 ; m < 10 ; m = m + 1)
	begin	: t
		k_ind_mult3 u1 (.clk(clk_in),.ce(~rst_n),.p(addr_k_tmp[m]),.a(m));
		fc_k_out u2 (.clka(clk_in),.ena(~rst_tmp3),.addra(addr_k[m]),.douta(k[m]));
		mult_16 u3 (.clk(clk_in),.a(fan_in),.b(k[m]),.ce(~rst_tmp3),.p(mult[m]));
	end
endgenerate

always @ (posedge clk_in)
begin
	if(rst_n)
	begin	//用偏置初始化
		for(j=0;j<num_out;j=j+1)
			out_tmp[j] <= 0;
		out_tmp2[0] <= 20'd1998;
		out_tmp2[1] <= 20'd357;
		out_tmp2[2] <= 20'd671;
		out_tmp2[3] <= -20'd899;
		out_tmp2[4] <= -20'd2305;
		out_tmp2[5] <= 20'd209;
		out_tmp2[6] <= 20'd2178;
		out_tmp2[7] <= -20'd862;
		out_tmp2[8] <= 20'd826;
		out_tmp2[9] <= -20'd2172;		
	end
	else
	begin
		if(out_cnt==124)	//延迟
		begin
			for(j=0;j<num_out;j=j+1)
			begin
				out_tmp[j] <= 0;
				if (out_tmp[j][11])	//用右移代替除法，注意四舍五入
					out_tmp2[j] <= out_tmp2[j] + (out_tmp[j] >> 12) + 1;
				else
					out_tmp2[j] <= out_tmp2[j] + (out_tmp[j] >> 12);
			end
		end
		else
		begin			
			for(j=0;j<num_out;j=j+1)
			begin
				out_tmp[j] <= out_tmp[j] + mult[j];
				out_tmp2[j] <= out_tmp2[j];
			end
		end
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		for(j=0;j<num_out;j=j+1)	
			out_tmp3[j] <= 0;
		ready <= 1;
	end
	else
	begin
		if(out_cnt==125)	//延迟
		begin
			for(j=0;j<num_out;j=j+1)
			begin
				if (out_tmp2[j] < 0)	//后面没有池化了，只能在这算激活
					out_tmp3[j] <= 0;
				else if (out_tmp2[j] >= 20'sd32767)
					out_tmp3[j] <= 16'sd32767;
				else
					out_tmp3[j] <= out_tmp2[j][15:0];
			end
			ready <= 0;
		end
		else
		begin
			for(j=0;j<num_out;j=j+1)	
				out_tmp3[j] <= 0;
			ready <= 1;
		end
	end
end

always @ (posedge clk_in)
begin
	if(ready)
	begin
		out_cnt2 <= 0;
		fan_out <= 0;
	end
	else
	begin
		if(out_cnt2 == num_out-1)
			out_cnt2 <= out_cnt2;
		else
			out_cnt2 <= out_cnt2 + 1;
		fan_out <= out_tmp2[out_cnt2];
	end
end

endmodule
