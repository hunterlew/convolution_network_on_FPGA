`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:56:39 02/26/2017 
// Design Name: 
// Module Name:    k2_out 
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
module k2_out(
	clk_in,
	rst_n,
	k_ready,
	k_ind,
	k1,k2,k3,k4,k5,k6,k7,k8,k9,
	k10,k11,k12,k13,k14,k15,k16,k17,k18
    );

//##需要输出核参数
parameter num_kernel = 5'd24;	//每个核参数数目-1

input clk_in;
input rst_n;
input k_ready;
input [5:0] k_ind;	//控制输出哪一部分的参数
output signed [15:0] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18;

wire [9:0] addr_k_tmp;	//基准地址
reg [9:0] addr_k = 0;	//卷积核参数地址
reg [4:0] out_cnt = 0;	//计数

always @ (posedge clk_in)
begin
	if (rst_n) 
	begin
		addr_k <= addr_k_tmp;
		out_cnt <= 0;
	end
	else
	begin
		if (k_ready) 
		begin
			if (out_cnt == num_kernel)	//在此基础上循环输出卷积参数以完成卷积	
			begin
				addr_k <= addr_k_tmp;
				out_cnt <= 0;
			end
			else
			begin
				addr_k <= addr_k + 1;
				out_cnt <= out_cnt + 1;
			end
		end
		else 
			addr_k <= addr_k_tmp;
	end
end

k_ind_mult u1(.clk(clk_in),.ce(~rst_n),.p(addr_k_tmp),.a(k_ind));

k2_1_out uk1(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k1));
k2_2_out uk2(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k2));
k2_3_out uk3(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k3));
k2_4_out uk4(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k4));
k2_5_out uk5(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k5));
k2_6_out uk6(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k6));
k2_7_out uk7(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k7));
k2_8_out uk8(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k8));
k2_9_out uk9(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k9));
k2_10_out uk10(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k10));
k2_11_out uk11(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k11));
k2_12_out uk12(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k12));
k2_13_out uk13(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k13));
k2_14_out uk14(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k14));
k2_15_out uk15(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k15));
k2_16_out uk16(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k16));
k2_17_out uk17(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k17));
k2_18_out uk18(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k18));

endmodule
