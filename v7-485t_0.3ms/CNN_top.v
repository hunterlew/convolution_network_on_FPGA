`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:46:59 03/23/2017 
// Design Name: 
// Module Name:    CNN 
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
module CNN_top(
	clk_in,
	rst_n,
	class	
	);

input clk_in;
input rst_n;
output [3:0] class;

wire signed [15:0] im;										
wire layer_0_ready;

// 96*96图像rom输出
m_layer_input_0 layer_0(.clk_in(clk_in),.rst_n(rst_n),.map_out(im),.start(layer_0_ready));				

wire signed [15:0] layer_1_conv_tmp [17:0];
wire signed [15:0] layer_1_conv [17:0];
wire layer_1_wr;
wire layer_1_a_ready;
wire layer_1_b_ready;

wire signed [15:0] layer_2_max_tmp [17:0];
wire signed [15:0] layer_2_max [17:0];
wire layer_2_wr;
wire layer_2_a_ready;
wire layer_2_b_ready;

wire k2_ready;	//k2开始循环输出复用的标志
wire k_loop;	//每次循环标志
reg [5:0] k_ind = 0;	//控制当前输出哪个k2
reg [8:0] wr_cnt = 0;	//每个循环写入数计数
reg [35:0] ram_ready = 36'hfffffffff;	//控制最后一起输出同一层卷积结果

wire k4_ready;	//k2开始循环输出复用的标志
wire k_loop2;	//每次循环标志
reg [6:0] k_ind2 = 0;	//控制当前输出哪个k3

// 18通道并行输出第一层卷积结果，采用以为寄存器结构（参数分别内置）
m_conv_1_1 layer_1_a_1(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[0]),.save(layer_1_wr),.ready(layer_1_a_ready));
m_conv_1_2 layer_1_a_2(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[1]));
m_conv_1_3 layer_1_a_3(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[2]));
m_conv_1_4 layer_1_a_4(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[3]));
m_conv_1_5 layer_1_a_5(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[4]));
m_conv_1_6 layer_1_a_6(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[5]));
m_conv_1_7 layer_1_a_7(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[6]));
m_conv_1_8 layer_1_a_8(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[7]));
m_conv_1_9 layer_1_a_9(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[8]));
m_conv_1_10 layer_1_a_10(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[9]));
m_conv_1_11 layer_1_a_11(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[10]));
m_conv_1_12 layer_1_a_12(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[11]));
m_conv_1_13 layer_1_a_13(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[12]));
m_conv_1_14 layer_1_a_14(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[13]));
m_conv_1_15 layer_1_a_15(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[14]));
m_conv_1_16 layer_1_a_16(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[15]));
m_conv_1_17 layer_1_a_17(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[16]));
m_conv_1_18 layer_1_a_18(.clk_in(clk_in),.rst_n(rst_n),.map_in(im),.start(layer_0_ready),.map_out(layer_1_conv_tmp[17]));

genvar i;	
generate
	for (i = 0 ; i < 18 ; i = i + 1)
	begin	: g1
	if (i == 0)	// 加以区分仅仅减少ready线
	begin
		// 第一层卷积缓存
		m_layer_input_1 layer_1_b(.clk_in(clk_in),.rst_n(layer_1_a_ready),.map_in(layer_1_conv_tmp[i]),.wr(layer_1_wr),.map_out(layer_1_conv[i]),.ready(layer_1_b_ready));
		// 第二层池化，18通道并行
		m_max_relu_2 layer_2_a(.clk_in(clk_in),.rst_n(layer_1_b_ready),.map_in(layer_1_conv[i]),.map_out(layer_2_max_tmp[i]),.wr(layer_2_wr),.ready(layer_2_a_ready));
		// 第二层池化缓存
		m_layer_input_2 layer_2_b(.clk_in(clk_in),.rst_n(layer_2_a_ready),.map_in(layer_2_max_tmp[i]),.wr(layer_2_wr),.map_out(layer_2_max[i]),.k_loop(k_loop),.k_ready(k2_ready),.ready(layer_2_b_ready));
	end
	else
	begin
		m_layer_input_1 layer_1_b(.clk_in(clk_in),.rst_n(layer_1_a_ready),.map_in(layer_1_conv_tmp[i]),.wr(layer_1_wr),.map_out(layer_1_conv[i]));
		m_max_relu_2 layer_2_a(.clk_in(clk_in),.rst_n(layer_1_b_ready),.map_in(layer_1_conv[i]),.map_out(layer_2_max_tmp[i]));
		m_layer_input_2 layer_2_b(.clk_in(clk_in),.rst_n(layer_2_a_ready),.map_in(layer_2_max_tmp[i]),.wr(layer_2_wr),.map_out(layer_2_max[i]));
	end
	end
endgenerate                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

wire signed [15:0] k2_1 [35:0];
wire signed [15:0] k2_2 [35:0];
wire signed [15:0] k2_3 [35:0];
wire signed [15:0] k2_4 [35:0];
wire signed [15:0] k2_5 [35:0];
wire signed [15:0] k2_6 [35:0];
wire signed [15:0] k2_7 [35:0];
wire signed [15:0] k2_8 [35:0];
wire signed [15:0] k2_9 [35:0];
wire signed [15:0] k2_10 [35:0];
wire signed [15:0] k2_11 [35:0];
wire signed [15:0] k2_12 [35:0];
wire signed [15:0] k2_13 [35:0];
wire signed [15:0] k2_14 [35:0];
wire signed [15:0] k2_15 [35:0];
wire signed [15:0] k2_16 [35:0];
wire signed [15:0] k2_17 [35:0];
wire signed [15:0] k2_18 [35:0];

wire signed [15:0] layer_3_conv_tmp_1 [35:0];
wire signed [15:0] layer_3_conv_tmp_2 [35:0];
wire signed [15:0] layer_3_conv_tmp_3 [35:0];
wire signed [15:0] layer_3_conv_tmp_4 [35:0];
wire signed [15:0] layer_3_conv_tmp_5 [35:0];
wire signed [15:0] layer_3_conv_tmp_6 [35:0];
wire signed [15:0] layer_3_conv_tmp_7 [35:0];
wire signed [15:0] layer_3_conv_tmp_8 [35:0];
wire signed [15:0] layer_3_conv_tmp_9 [35:0];
wire signed [15:0] layer_3_conv_tmp_10 [35:0];
wire signed [15:0] layer_3_conv_tmp_11 [35:0];
wire signed [15:0] layer_3_conv_tmp_12 [35:0];
wire signed [15:0] layer_3_conv_tmp_13 [35:0];
wire signed [15:0] layer_3_conv_tmp_14 [35:0];
wire signed [15:0] layer_3_conv_tmp_15 [35:0];
wire signed [15:0] layer_3_conv_tmp_16 [35:0];
wire signed [15:0] layer_3_conv_tmp_17 [35:0];
wire signed [15:0] layer_3_conv_tmp_18 [35:0];

wire signed [15:0] layer_3_conv [35:0];
wire signed [15:0] layer_3_conv2[35:0];
wire layer_3_wr;
wire layer_3_a_ready;
wire layer_3_b_ready;
wire layer_3_c_ready;

wire signed [15:0] layer_4_max_tmp [35:0];
wire signed [15:0] layer_4_max [35:0];
wire layer_4_wr;
wire layer_4_a_ready;
wire layer_4_b_ready;

always @ (posedge clk_in)
begin
	if (rst_n)
		k_ind <= 0;
	else
	begin
		if (k_loop)	//控制36组（用于控制分组并行，存储资源足够直接36组，不够的话可以分成9*4）
			k_ind <= k_ind + 36;
		else
			k_ind <= k_ind;
	end
end

always @ (posedge clk_in)
begin
	if (rst_n)
	begin
		wr_cnt <= 0;
		ram_ready <= 36'hfffffffff;
	end
	else
	begin
		if (layer_3_wr)
		begin
			if (wr_cnt == 323)
			begin
				wr_cnt <= 0;
				ram_ready <= (ram_ready << 36);	//trick
			end
			else	
			begin
				wr_cnt <= wr_cnt + 1;
				ram_ready <= ram_ready;
			end
		end
		else
			wr_cnt <= wr_cnt;
	end
end

always @ (posedge clk_in)
begin
	if (rst_n)
		k_ind2 <= 0;
	else
	begin
		if (k_loop2)	//
			k_ind2 <= k_ind2 + 1;
		else
			k_ind2 <= k_ind2;
	end
end

genvar m;	
generate
	for (m = 0 ; m < 36 ; m = m + 1)
	begin	: t1
		// 导入第三层卷积参数
		k2_out layer_2_c(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+m),
							.k1(k2_1[m]),.k2(k2_2[m]),.k3(k2_3[m]),.k4(k2_4[m]),.k5(k2_5[m]),.k6(k2_6[m]),.k7(k2_7[m]),.k8(k2_8[m]),.k9(k2_9[m]),
							.k10(k2_10[m]),.k11(k2_11[m]),.k12(k2_12[m]),.k13(k2_13[m]),.k14(k2_14[m]),.k15(k2_15[m]),.k16(k2_16[m]),.k17(k2_17[m]),.k18(k2_18[m]));
		// 总共18*36组卷积，缓存在tmp中等待累加
		if(m==0)
			m_conv_3 layer_3_1_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_1[m]),.map_out(layer_3_conv_tmp_1[m]),.ready(layer_3_a_ready));
		else
			m_conv_3 layer_3_1_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_1[m]),.map_out(layer_3_conv_tmp_1[m]));		
		m_conv_3 layer_3_2_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_2[m]),.map_out(layer_3_conv_tmp_2[m]));
		m_conv_3 layer_3_3_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_3[m]),.map_out(layer_3_conv_tmp_3[m]));
		m_conv_3 layer_3_4_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_4[m]),.map_out(layer_3_conv_tmp_4[m]));
		m_conv_3 layer_3_5_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_5[m]),.map_out(layer_3_conv_tmp_5[m]));
		m_conv_3 layer_3_6_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_6[m]),.map_out(layer_3_conv_tmp_6[m]));
		m_conv_3 layer_3_7_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_7[m]),.map_out(layer_3_conv_tmp_7[m]));
		m_conv_3 layer_3_8_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_8[m]),.map_out(layer_3_conv_tmp_8[m]));
		m_conv_3 layer_3_9_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_9[m]),.map_out(layer_3_conv_tmp_9[m]));
		m_conv_3 layer_3_10_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_10[m]),.map_out(layer_3_conv_tmp_10[m]));	
		m_conv_3 layer_3_11_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_11[m]),.map_out(layer_3_conv_tmp_11[m]));
		m_conv_3 layer_3_12_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_12[m]),.map_out(layer_3_conv_tmp_12[m]));
		m_conv_3 layer_3_13_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_13[m]),.map_out(layer_3_conv_tmp_13[m]));
		m_conv_3 layer_3_14_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_14[m]),.map_out(layer_3_conv_tmp_14[m]));
		m_conv_3 layer_3_15_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_15[m]),.map_out(layer_3_conv_tmp_15[m]));
		m_conv_3 layer_3_16_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_16[m]),.map_out(layer_3_conv_tmp_16[m]));
		m_conv_3 layer_3_17_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_17[m]),.map_out(layer_3_conv_tmp_17[m]));
		m_conv_3 layer_3_18_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_18[m]),.map_out(layer_3_conv_tmp_18[m]));
	end
endgenerate

genvar j;	
genvar n;
generate
	for (j = 0 ; j < 36 ; j = j + 36)
	begin	: g2
		for (n = 0 ; n < 36 ; n = n + 1)
		begin : g3	
		if(n+j==0)
		begin
			// 与18个通道输出卷积后累加，总共36组输出
			conv_adder18 layer_3_b(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp_1[0]),	
				.a2(layer_3_conv_tmp_2[0]),	
				.a3(layer_3_conv_tmp_3[0]),	
				.a4(layer_3_conv_tmp_4[0]),	
				.a5(layer_3_conv_tmp_5[0]),	
				.a6(layer_3_conv_tmp_6[0]),	
				.a7(layer_3_conv_tmp_7[0]),	
				.a8(layer_3_conv_tmp_8[0]),	
				.a9(layer_3_conv_tmp_9[0]),
				.a10(layer_3_conv_tmp_10[0]),	
				.a11(layer_3_conv_tmp_11[0]),	
				.a12(layer_3_conv_tmp_12[0]),	
				.a13(layer_3_conv_tmp_13[0]),	
				.a14(layer_3_conv_tmp_14[0]),	
				.a15(layer_3_conv_tmp_15[0]),	
				.a16(layer_3_conv_tmp_16[0]),	
				.a17(layer_3_conv_tmp_17[0]),	
				.a18(layer_3_conv_tmp_18[0]),
				.b_ind(0),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[0]),.wr(layer_3_wr),.ready(layer_3_b_ready));
			// 36组卷积并行输出缓存
			m_layer_input_3 layer_3_c(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[0]),.map_in(layer_3_conv[0]),.wr(layer_3_wr),.map_out(layer_3_conv2[0]),.ready(layer_3_c_ready));
			// 第四层池化，36通道并行
			m_max_relu_4 layer_4_a(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[0]),.map_out(layer_4_max_tmp[0]),.wr(layer_4_wr),.ready(layer_4_a_ready));
			// 第四层池化缓存
			m_layer_input_4 layer_4_b(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[0]),.wr(layer_4_wr),.map_out(layer_4_max[0]),.k_loop(k_loop2),.k_ready(k4_ready),.ready(layer_4_b_ready));
		end
		else
		begin
			//需要将前一层的几个结果加起来，再加上偏置
			conv_adder18 layer_3_b(.clk_in(clk_in),.rst_n(layer_2_b_ready),
					.a1(layer_3_conv_tmp_1[n]),	
					.a2(layer_3_conv_tmp_2[n]),	
					.a3(layer_3_conv_tmp_3[n]),	
					.a4(layer_3_conv_tmp_4[n]),	
					.a5(layer_3_conv_tmp_5[n]),	
					.a6(layer_3_conv_tmp_6[n]),	
					.a7(layer_3_conv_tmp_7[n]),	
					.a8(layer_3_conv_tmp_8[n]),	
					.a9(layer_3_conv_tmp_9[n]),
					.a10(layer_3_conv_tmp_10[n]),	
					.a11(layer_3_conv_tmp_11[n]),	
					.a12(layer_3_conv_tmp_12[n]),	
					.a13(layer_3_conv_tmp_13[n]),	
					.a14(layer_3_conv_tmp_14[n]),	
					.a15(layer_3_conv_tmp_15[n]),	
					.a16(layer_3_conv_tmp_16[n]),	
					.a17(layer_3_conv_tmp_17[n]),	
					.a18(layer_3_conv_tmp_18[n]),
					.b_ind(n+j),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[n+j]));
			//控制陆续写入，最后ram_ready[35]一起读出来
			m_layer_input_3 layer_3_c(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[n+j]),.map_in(layer_3_conv[n+j]),.wr(layer_3_wr),.map_out(layer_3_conv2[n+j]));
			m_max_relu_4 layer_4_a(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[n+j]),.map_out(layer_4_max_tmp[n+j]));
			m_layer_input_4 layer_4_b(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[n+j]),.wr(layer_4_wr),.map_out(layer_4_max[n+j]));
		end
		end
	end
endgenerate

wire signed [15:0] k3_1, k3_2, k3_3, k3_4, k3_5, k3_6, k3_7, k3_8, k3_9, k3_10, k3_11, k3_12, k3_13, k3_14, k3_15, k3_16, k3_17, k3_18;
wire signed [15:0] k3_19, k3_20, k3_21, k3_22, k3_23, k3_24, k3_25, k3_26, k3_27, k3_28, k3_29, k3_30, k3_31, k3_32, k3_33, k3_34, k3_35, k3_36;

// 导入第五层卷积参数
k3_out layer_4_c(.clk_in(clk_in),.rst_n(layer_4_a_ready),.k_ready(k4_ready),.k_ind(k_ind2),
						.k1(k3_1),.k2(k3_2),.k3(k3_3),.k4(k3_4),.k5(k3_5),.k6(k3_6),.k7(k3_7),.k8(k3_8),.k9(k3_9),
						.k10(k3_10),.k11(k3_11),.k12(k3_12),.k13(k3_13),.k14(k3_14),.k15(k3_15),.k16(k3_16),.k17(k3_17),.k18(k3_18),
						.k19(k3_19),.k20(k3_20),.k21(k3_21),.k22(k3_22),.k23(k3_23),.k24(k3_24),.k25(k3_25),.k26(k3_26),.k27(k3_27),
						.k28(k3_28),.k29(k3_29),.k30(k3_30),.k31(k3_31),.k32(k3_32),.k33(k3_33),.k34(k3_34),.k35(k3_35),.k36(k3_36));

wire signed [15:0] layer_5_conv_tmp_1; 
wire signed [15:0] layer_5_conv_tmp_2;
wire signed [15:0] layer_5_conv_tmp_3; 
wire signed [15:0] layer_5_conv_tmp_4; 
wire signed [15:0] layer_5_conv_tmp_5; 
wire signed [15:0] layer_5_conv_tmp_6; 
wire signed [15:0] layer_5_conv_tmp_7; 
wire signed [15:0] layer_5_conv_tmp_8; 
wire signed [15:0] layer_5_conv_tmp_9; 
wire signed [15:0] layer_5_conv_tmp_10;
wire signed [15:0] layer_5_conv_tmp_11;
wire signed [15:0] layer_5_conv_tmp_12;
wire signed [15:0] layer_5_conv_tmp_13;
wire signed [15:0] layer_5_conv_tmp_14;
wire signed [15:0] layer_5_conv_tmp_15;
wire signed [15:0] layer_5_conv_tmp_16;
wire signed [15:0] layer_5_conv_tmp_17;
wire signed [15:0] layer_5_conv_tmp_18;
wire signed [15:0] layer_5_conv_tmp_19;
wire signed [15:0] layer_5_conv_tmp_20;
wire signed [15:0] layer_5_conv_tmp_21;
wire signed [15:0] layer_5_conv_tmp_22;
wire signed [15:0] layer_5_conv_tmp_23;
wire signed [15:0] layer_5_conv_tmp_24;
wire signed [15:0] layer_5_conv_tmp_25;
wire signed [15:0] layer_5_conv_tmp_26;
wire signed [15:0] layer_5_conv_tmp_27;
wire signed [15:0] layer_5_conv_tmp_28;
wire signed [15:0] layer_5_conv_tmp_29;
wire signed [15:0] layer_5_conv_tmp_30;
wire signed [15:0] layer_5_conv_tmp_31;
wire signed [15:0] layer_5_conv_tmp_32;
wire signed [15:0] layer_5_conv_tmp_33;
wire signed [15:0] layer_5_conv_tmp_34;
wire signed [15:0] layer_5_conv_tmp_35;
wire signed [15:0] layer_5_conv_tmp_36;

wire layer_5_a_wr;
wire layer_5_a_ready;

// 36通道卷积，由于输出是1*1，每个通道串行输出120个数
m_conv_5 layer_5_1_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[0]),.k_in(k3_1),.map_out(layer_5_conv_tmp_1),.wr(layer_5_a_wr),.ready(layer_5_a_ready));
m_conv_5 layer_5_2_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[1]),.k_in(k3_2),.map_out(layer_5_conv_tmp_2));
m_conv_5 layer_5_3_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[2]),.k_in(k3_3),.map_out(layer_5_conv_tmp_3));
m_conv_5 layer_5_4_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[3]),.k_in(k3_4),.map_out(layer_5_conv_tmp_4));
m_conv_5 layer_5_5_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[4]),.k_in(k3_5),.map_out(layer_5_conv_tmp_5));
m_conv_5 layer_5_6_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[5]),.k_in(k3_6),.map_out(layer_5_conv_tmp_6));
m_conv_5 layer_5_7_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[6]),.k_in(k3_7),.map_out(layer_5_conv_tmp_7));
m_conv_5 layer_5_8_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[7]),.k_in(k3_8),.map_out(layer_5_conv_tmp_8));
m_conv_5 layer_5_9_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[8]),.k_in(k3_9),.map_out(layer_5_conv_tmp_9));
m_conv_5 layer_5_10_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[9]),.k_in(k3_10),.map_out(layer_5_conv_tmp_10));	
m_conv_5 layer_5_11_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[10]),.k_in(k3_11),.map_out(layer_5_conv_tmp_11));
m_conv_5 layer_5_12_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[11]),.k_in(k3_12),.map_out(layer_5_conv_tmp_12));
m_conv_5 layer_5_13_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[12]),.k_in(k3_13),.map_out(layer_5_conv_tmp_13));
m_conv_5 layer_5_14_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[13]),.k_in(k3_14),.map_out(layer_5_conv_tmp_14));
m_conv_5 layer_5_15_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[14]),.k_in(k3_15),.map_out(layer_5_conv_tmp_15));
m_conv_5 layer_5_16_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[15]),.k_in(k3_16),.map_out(layer_5_conv_tmp_16));
m_conv_5 layer_5_17_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[16]),.k_in(k3_17),.map_out(layer_5_conv_tmp_17));
m_conv_5 layer_5_18_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[17]),.k_in(k3_18),.map_out(layer_5_conv_tmp_18));         
m_conv_5 layer_5_19_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[18]),.k_in(k3_19),.map_out(layer_5_conv_tmp_19));
m_conv_5 layer_5_20_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[19]),.k_in(k3_20),.map_out(layer_5_conv_tmp_20));
m_conv_5 layer_5_21_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[20]),.k_in(k3_21),.map_out(layer_5_conv_tmp_21));
m_conv_5 layer_5_22_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[21]),.k_in(k3_22),.map_out(layer_5_conv_tmp_22));
m_conv_5 layer_5_23_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[22]),.k_in(k3_23),.map_out(layer_5_conv_tmp_23));
m_conv_5 layer_5_24_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[23]),.k_in(k3_24),.map_out(layer_5_conv_tmp_24));
m_conv_5 layer_5_25_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[24]),.k_in(k3_25),.map_out(layer_5_conv_tmp_25));
m_conv_5 layer_5_26_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[25]),.k_in(k3_26),.map_out(layer_5_conv_tmp_26));
m_conv_5 layer_5_27_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[26]),.k_in(k3_27),.map_out(layer_5_conv_tmp_27));	
m_conv_5 layer_5_28_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[27]),.k_in(k3_28),.map_out(layer_5_conv_tmp_28));
m_conv_5 layer_5_29_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[28]),.k_in(k3_29),.map_out(layer_5_conv_tmp_29));
m_conv_5 layer_5_30_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[29]),.k_in(k3_30),.map_out(layer_5_conv_tmp_30));
m_conv_5 layer_5_31_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[30]),.k_in(k3_31),.map_out(layer_5_conv_tmp_31));
m_conv_5 layer_5_32_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[31]),.k_in(k3_32),.map_out(layer_5_conv_tmp_32));
m_conv_5 layer_5_33_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[32]),.k_in(k3_33),.map_out(layer_5_conv_tmp_33));
m_conv_5 layer_5_34_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[33]),.k_in(k3_34),.map_out(layer_5_conv_tmp_34));
m_conv_5 layer_5_35_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[34]),.k_in(k3_35),.map_out(layer_5_conv_tmp_35));
m_conv_5 layer_5_36_a(.clk_in(clk_in),.rst_n(layer_4_b_ready),.map_in(layer_4_max[35]),.k_in(k3_36),.map_out(layer_5_conv_tmp_36));	

reg [6:0] b_in = 0;
wire signed [15:0] layer_5_conv_tmp;
wire signed [15:0] layer_5_conv;
wire k5_ready;
wire layer_5_b_ready;
wire layer_5_c_ready;

reg layer_4_b_ready_delay1 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay2 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay3 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay4 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay5 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay6 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay7 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay8 = 1;	//为加法器做适当延迟
reg layer_4_b_ready_delay9 = 1;	//为加法器做适当延迟

always @(posedge clk_in)
begin
	if(layer_5_a_wr)
		b_in <= b_in + 1;
	else
		b_in <= b_in;
	layer_4_b_ready_delay1 <= layer_4_b_ready;
	layer_4_b_ready_delay2 <= layer_4_b_ready_delay1;
	layer_4_b_ready_delay3 <= layer_4_b_ready_delay2;
	layer_4_b_ready_delay4 <= layer_4_b_ready_delay3;
	layer_4_b_ready_delay5 <= layer_4_b_ready_delay4;
	layer_4_b_ready_delay6 <= layer_4_b_ready_delay5;
	layer_4_b_ready_delay7 <= layer_4_b_ready_delay6;
	layer_4_b_ready_delay8 <= layer_4_b_ready_delay7;
	layer_4_b_ready_delay9 <= layer_4_b_ready_delay8;
end

reg layer_5_b_wr_tmp = 0;
reg layer_5_b_wr_tmp1 = 0;
reg layer_5_b_wr_tmp2 = 0;
reg layer_5_b_wr = 0;

always @(posedge clk_in)	//加法结果延迟三个周期
begin
	layer_5_b_wr_tmp <= layer_5_a_wr;
	layer_5_b_wr_tmp1 <= layer_5_b_wr_tmp;
	layer_5_b_wr_tmp2 <= layer_5_b_wr_tmp1;
	layer_5_b_wr <= layer_5_b_wr_tmp2;	
end

conv_adder36 layer_5_b(
   .clk_in(clk_in),.rst_n(layer_4_b_ready_delay9),
	.a1(layer_5_conv_tmp_1),	
	.a2(layer_5_conv_tmp_2),	
	.a3(layer_5_conv_tmp_3),	
	.a4(layer_5_conv_tmp_4),	
	.a5(layer_5_conv_tmp_5),
	.a6(layer_5_conv_tmp_6),	
	.a7(layer_5_conv_tmp_7),	
	.a8(layer_5_conv_tmp_8),
	.a9(layer_5_conv_tmp_9),
	.a10(layer_5_conv_tmp_10),	
	.a11(layer_5_conv_tmp_11),	
	.a12(layer_5_conv_tmp_12),	
	.a13(layer_5_conv_tmp_13),	
	.a14(layer_5_conv_tmp_14),	
	.a15(layer_5_conv_tmp_15),	
	.a16(layer_5_conv_tmp_16),	
	.a17(layer_5_conv_tmp_17),	
	.a18(layer_5_conv_tmp_18),
	.a19(layer_5_conv_tmp_19),	
	.a20(layer_5_conv_tmp_20),	
	.a21(layer_5_conv_tmp_21),	
	.a22(layer_5_conv_tmp_22),	
	.a23(layer_5_conv_tmp_23),	
	.a24(layer_5_conv_tmp_24),	
	.a25(layer_5_conv_tmp_25),	
	.a26(layer_5_conv_tmp_26),	
	.a27(layer_5_conv_tmp_27),
	.a28(layer_5_conv_tmp_28),	
	.a29(layer_5_conv_tmp_29),	
	.a30(layer_5_conv_tmp_30),	
	.a31(layer_5_conv_tmp_31),	
	.a32(layer_5_conv_tmp_32),	
	.a33(layer_5_conv_tmp_33),	
	.a34(layer_5_conv_tmp_34),	
	.a35(layer_5_conv_tmp_35),	
	.a36(layer_5_conv_tmp_36),
	.b_ind(b_in-1),.last_ready(layer_5_a_ready),.add_out(layer_5_conv_tmp),.ready(layer_5_b_ready));	  
	
m_layer_input_5 layer_5_c(.clk_in(clk_in),.rst_n(layer_5_b_ready),.map_in(layer_5_conv_tmp),.wr(layer_5_b_wr),.map_out(layer_5_conv),.k_ready(k5_ready),.ready(layer_5_c_ready));

wire signed [19:0] layer_6_fc;
wire layer_6_a_ready;

m_fc layer_6_a(.clk_in(clk_in),.rst_n(layer_5_b_ready),.fan_in(layer_5_conv),.fan_out(layer_6_fc),.ready(layer_6_a_ready));
max_output layer_6_b(.clk_in(clk_in),.rst_n(layer_6_a_ready),.p_in(layer_6_fc),.class_out(class));

endmodule
