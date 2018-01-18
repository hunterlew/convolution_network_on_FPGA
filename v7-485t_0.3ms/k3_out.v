`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:46 03/01/2017 
// Design Name: 
// Module Name:    k3_out 
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
module k3_out(
	clk_in,
	rst_n,
	k_ready,
	k_ind,
	k1,k2,k3,k4,k5,k6,k7,k8,k9,
	k10,k11,k12,k13,k14,k15,k16,k17,k18,
	k19,k20,k21,k22,k23,k24,k25,k26,k27,
	k28,k29,k30,k31,k32,k33,k34,k35,k36
    );

//##需要输出核参数
parameter num_kernel = 6'd35;	//每个核参数数目-1

input clk_in;
input rst_n;
input k_ready;
input [6:0] k_ind;	//控制输出哪一部分的参数
output signed [15:0] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,k17,k18;
output signed [15:0] k19,k20,k21,k22,k23,k24,k25,k26,k27,k28,k29,k30,k31,k32,k33,k34,k35,k36;

wire [12:0] addr_k_tmp;	
reg [12:0] addr_k = 0;	//卷积核参数地址
reg [5:0] out_cnt = 0;	//计数

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

k_ind_mult2 u1(.clk(clk_in),.ce(~rst_n),.p(addr_k_tmp),.a(k_ind));

k3_1_out uk1(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k1));
k3_2_out uk2(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k2));
k3_3_out uk3(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k3));
k3_4_out uk4(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k4));
k3_5_out uk5(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k5));
k3_6_out uk6(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k6));
k3_7_out uk7(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k7));
k3_8_out uk8(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k8));
k3_9_out uk9(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k9));
k3_10_out uk10(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k10));
k3_11_out uk11(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k11));
k3_12_out uk12(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k12));
k3_13_out uk13(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k13));
k3_14_out uk14(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k14));
k3_15_out uk15(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k15));
k3_16_out uk16(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k16));
k3_17_out uk17(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k17));
k3_18_out uk18(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k18));

k3_19_out uk19(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k19));
k3_20_out uk20(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k20));
k3_21_out uk21(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k21));
k3_22_out uk22(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k22));
k3_23_out uk23(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k23));
k3_24_out uk24(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k24));
k3_25_out uk25(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k25));
k3_26_out uk26(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k26));
k3_27_out uk27(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k27));
k3_28_out uk28(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k28));
k3_29_out uk29(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k29));
k3_30_out uk30(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k30));
k3_31_out uk31(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k31));
k3_32_out uk32(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k32));
k3_33_out uk33(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k33));
k3_34_out uk34(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k34));
k3_35_out uk35(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k35));
k3_36_out uk36(.clka(clk_in),.ena(k_ready),.addra(addr_k),.douta(k36));

endmodule
