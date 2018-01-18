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
//reg [119:0] ram_ready2 = 120'hfffffffffffffffffff`fffffffffff;	//控制最后一起输出同一层卷积结果

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
	if (i == 0)
	begin
		m_layer_input_1 layer_1_b(.clk_in(clk_in),.rst_n(layer_1_a_ready),.map_in(layer_1_conv_tmp[i]),.wr(layer_1_wr),.map_out(layer_1_conv[i]),.ready(layer_1_b_ready));
		m_max_relu_2 layer_2_a(.clk_in(clk_in),.rst_n(layer_1_b_ready),.map_in(layer_1_conv[i]),.map_out(layer_2_max_tmp[i]),.wr(layer_2_wr),.ready(layer_2_a_ready));
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

//六组参数线，每组6个
wire signed [15:0] k2_1, k2_2, k2_3, k2_4, k2_5, k2_6, k2_7, k2_8, k2_9, k2_10, k2_11, k2_12, k2_13, k2_14, k2_15, k2_16, k2_17, k2_18;
wire signed [15:0] k2_19, k2_20, k2_21, k2_22, k2_23, k2_24, k2_25, k2_26, k2_27, k2_28, k2_29, k2_30, k2_31, k2_32, k2_33, k2_34, k2_35, k2_36;
wire signed [15:0] k2_37, k2_38, k2_39, k2_40, k2_41, k2_42, k2_43, k2_44, k2_45, k2_46, k2_47, k2_48, k2_49, k2_50, k2_51, k2_52, k2_53, k2_54;
wire signed [15:0] k2_55, k2_56, k2_57, k2_58, k2_59, k2_60, k2_61, k2_62, k2_63, k2_64, k2_65, k2_66, k2_67, k2_68, k2_69, k2_70, k2_71, k2_72;
wire signed [15:0] k2_73, k2_74, k2_75, k2_76, k2_77, k2_78, k2_79, k2_80, k2_81, k2_82, k2_83, k2_84, k2_85, k2_86, k2_87, k2_88, k2_89, k2_90;
wire signed [15:0] k2_91, k2_92, k2_93, k2_94, k2_95, k2_96, k2_97, k2_98, k2_99, k2_100, k2_101, k2_102, k2_103, k2_104, k2_105, k2_106, k2_107, k2_108;
wire signed [15:0] k2_109, k2_110, k2_111, k2_112, k2_113, k2_114, k2_115, k2_116, k2_117, k2_118, k2_119, k2_120, k2_121, k2_122, k2_123, k2_124, k2_125, k2_126;
wire signed [15:0] k2_127, k2_128, k2_129, k2_130, k2_131, k2_132, k2_133, k2_134, k2_135, k2_136, k2_137, k2_138, k2_139, k2_140, k2_141, k2_142, k2_143, k2_144;
wire signed [15:0] k2_145, k2_146, k2_147, k2_148, k2_149, k2_150, k2_151, k2_152, k2_153, k2_154, k2_155, k2_156, k2_157, k2_158, k2_159, k2_160, k2_161, k2_162;

wire signed [15:0] layer_3_conv_tmp_1;
wire signed [15:0] layer_3_conv_tmp_2;
wire signed [15:0] layer_3_conv_tmp_3;
wire signed [15:0] layer_3_conv_tmp_4;
wire signed [15:0] layer_3_conv_tmp_5;
wire signed [15:0] layer_3_conv_tmp_6;
wire signed [15:0] layer_3_conv_tmp_7;
wire signed [15:0] layer_3_conv_tmp_8;
wire signed [15:0] layer_3_conv_tmp_9;
wire signed [15:0] layer_3_conv_tmp_10;
wire signed [15:0] layer_3_conv_tmp_11;
wire signed [15:0] layer_3_conv_tmp_12;
wire signed [15:0] layer_3_conv_tmp_13;
wire signed [15:0] layer_3_conv_tmp_14;
wire signed [15:0] layer_3_conv_tmp_15;
wire signed [15:0] layer_3_conv_tmp_16;
wire signed [15:0] layer_3_conv_tmp_17;
wire signed [15:0] layer_3_conv_tmp_18;

wire signed [15:0] layer_3_conv_tmp2_1;
wire signed [15:0] layer_3_conv_tmp2_2;
wire signed [15:0] layer_3_conv_tmp2_3;
wire signed [15:0] layer_3_conv_tmp2_4;
wire signed [15:0] layer_3_conv_tmp2_5;
wire signed [15:0] layer_3_conv_tmp2_6;
wire signed [15:0] layer_3_conv_tmp2_7;
wire signed [15:0] layer_3_conv_tmp2_8;
wire signed [15:0] layer_3_conv_tmp2_9;
wire signed [15:0] layer_3_conv_tmp2_10;
wire signed [15:0] layer_3_conv_tmp2_11;
wire signed [15:0] layer_3_conv_tmp2_12;
wire signed [15:0] layer_3_conv_tmp2_13;
wire signed [15:0] layer_3_conv_tmp2_14;
wire signed [15:0] layer_3_conv_tmp2_15;
wire signed [15:0] layer_3_conv_tmp2_16;
wire signed [15:0] layer_3_conv_tmp2_17;
wire signed [15:0] layer_3_conv_tmp2_18;

wire signed [15:0] layer_3_conv_tmp3_1;
wire signed [15:0] layer_3_conv_tmp3_2;
wire signed [15:0] layer_3_conv_tmp3_3;
wire signed [15:0] layer_3_conv_tmp3_4;
wire signed [15:0] layer_3_conv_tmp3_5;
wire signed [15:0] layer_3_conv_tmp3_6;
wire signed [15:0] layer_3_conv_tmp3_7;
wire signed [15:0] layer_3_conv_tmp3_8;
wire signed [15:0] layer_3_conv_tmp3_9;
wire signed [15:0] layer_3_conv_tmp3_10;
wire signed [15:0] layer_3_conv_tmp3_11;
wire signed [15:0] layer_3_conv_tmp3_12;
wire signed [15:0] layer_3_conv_tmp3_13;
wire signed [15:0] layer_3_conv_tmp3_14;
wire signed [15:0] layer_3_conv_tmp3_15;
wire signed [15:0] layer_3_conv_tmp3_16;
wire signed [15:0] layer_3_conv_tmp3_17;
wire signed [15:0] layer_3_conv_tmp3_18;

wire signed [15:0] layer_3_conv_tmp4_1;
wire signed [15:0] layer_3_conv_tmp4_2;
wire signed [15:0] layer_3_conv_tmp4_3;
wire signed [15:0] layer_3_conv_tmp4_4;
wire signed [15:0] layer_3_conv_tmp4_5;
wire signed [15:0] layer_3_conv_tmp4_6;
wire signed [15:0] layer_3_conv_tmp4_7;
wire signed [15:0] layer_3_conv_tmp4_8;
wire signed [15:0] layer_3_conv_tmp4_9;
wire signed [15:0] layer_3_conv_tmp4_10;
wire signed [15:0] layer_3_conv_tmp4_11;
wire signed [15:0] layer_3_conv_tmp4_12;
wire signed [15:0] layer_3_conv_tmp4_13;
wire signed [15:0] layer_3_conv_tmp4_14;
wire signed [15:0] layer_3_conv_tmp4_15;
wire signed [15:0] layer_3_conv_tmp4_16;
wire signed [15:0] layer_3_conv_tmp4_17;
wire signed [15:0] layer_3_conv_tmp4_18;

wire signed [15:0] layer_3_conv_tmp5_1;
wire signed [15:0] layer_3_conv_tmp5_2;
wire signed [15:0] layer_3_conv_tmp5_3;
wire signed [15:0] layer_3_conv_tmp5_4;
wire signed [15:0] layer_3_conv_tmp5_5;
wire signed [15:0] layer_3_conv_tmp5_6;
wire signed [15:0] layer_3_conv_tmp5_7;
wire signed [15:0] layer_3_conv_tmp5_8;
wire signed [15:0] layer_3_conv_tmp5_9;
wire signed [15:0] layer_3_conv_tmp5_10;
wire signed [15:0] layer_3_conv_tmp5_11;
wire signed [15:0] layer_3_conv_tmp5_12;
wire signed [15:0] layer_3_conv_tmp5_13;
wire signed [15:0] layer_3_conv_tmp5_14;
wire signed [15:0] layer_3_conv_tmp5_15;
wire signed [15:0] layer_3_conv_tmp5_16;
wire signed [15:0] layer_3_conv_tmp5_17;
wire signed [15:0] layer_3_conv_tmp5_18;

wire signed [15:0] layer_3_conv_tmp6_1;
wire signed [15:0] layer_3_conv_tmp6_2;
wire signed [15:0] layer_3_conv_tmp6_3;
wire signed [15:0] layer_3_conv_tmp6_4;
wire signed [15:0] layer_3_conv_tmp6_5;
wire signed [15:0] layer_3_conv_tmp6_6;
wire signed [15:0] layer_3_conv_tmp6_7;
wire signed [15:0] layer_3_conv_tmp6_8;
wire signed [15:0] layer_3_conv_tmp6_9;
wire signed [15:0] layer_3_conv_tmp6_10;
wire signed [15:0] layer_3_conv_tmp6_11;
wire signed [15:0] layer_3_conv_tmp6_12;
wire signed [15:0] layer_3_conv_tmp6_13;
wire signed [15:0] layer_3_conv_tmp6_14;
wire signed [15:0] layer_3_conv_tmp6_15;
wire signed [15:0] layer_3_conv_tmp6_16;
wire signed [15:0] layer_3_conv_tmp6_17;
wire signed [15:0] layer_3_conv_tmp6_18;

wire signed [15:0] layer_3_conv_tmp7_1;
wire signed [15:0] layer_3_conv_tmp7_2;
wire signed [15:0] layer_3_conv_tmp7_3;
wire signed [15:0] layer_3_conv_tmp7_4;
wire signed [15:0] layer_3_conv_tmp7_5;
wire signed [15:0] layer_3_conv_tmp7_6;
wire signed [15:0] layer_3_conv_tmp7_7;
wire signed [15:0] layer_3_conv_tmp7_8;
wire signed [15:0] layer_3_conv_tmp7_9;
wire signed [15:0] layer_3_conv_tmp7_10;
wire signed [15:0] layer_3_conv_tmp7_11;
wire signed [15:0] layer_3_conv_tmp7_12;
wire signed [15:0] layer_3_conv_tmp7_13;
wire signed [15:0] layer_3_conv_tmp7_14;
wire signed [15:0] layer_3_conv_tmp7_15;
wire signed [15:0] layer_3_conv_tmp7_16;
wire signed [15:0] layer_3_conv_tmp7_17;
wire signed [15:0] layer_3_conv_tmp7_18;

wire signed [15:0] layer_3_conv_tmp8_1;
wire signed [15:0] layer_3_conv_tmp8_2;
wire signed [15:0] layer_3_conv_tmp8_3;
wire signed [15:0] layer_3_conv_tmp8_4;
wire signed [15:0] layer_3_conv_tmp8_5;
wire signed [15:0] layer_3_conv_tmp8_6;
wire signed [15:0] layer_3_conv_tmp8_7;
wire signed [15:0] layer_3_conv_tmp8_8;
wire signed [15:0] layer_3_conv_tmp8_9;
wire signed [15:0] layer_3_conv_tmp8_10;
wire signed [15:0] layer_3_conv_tmp8_11;
wire signed [15:0] layer_3_conv_tmp8_12;
wire signed [15:0] layer_3_conv_tmp8_13;
wire signed [15:0] layer_3_conv_tmp8_14;
wire signed [15:0] layer_3_conv_tmp8_15;
wire signed [15:0] layer_3_conv_tmp8_16;
wire signed [15:0] layer_3_conv_tmp8_17;
wire signed [15:0] layer_3_conv_tmp8_18;

wire signed [15:0] layer_3_conv_tmp9_1;
wire signed [15:0] layer_3_conv_tmp9_2;
wire signed [15:0] layer_3_conv_tmp9_3;
wire signed [15:0] layer_3_conv_tmp9_4;
wire signed [15:0] layer_3_conv_tmp9_5;
wire signed [15:0] layer_3_conv_tmp9_6;
wire signed [15:0] layer_3_conv_tmp9_7;
wire signed [15:0] layer_3_conv_tmp9_8;
wire signed [15:0] layer_3_conv_tmp9_9;
wire signed [15:0] layer_3_conv_tmp9_10;
wire signed [15:0] layer_3_conv_tmp9_11;
wire signed [15:0] layer_3_conv_tmp9_12;
wire signed [15:0] layer_3_conv_tmp9_13;
wire signed [15:0] layer_3_conv_tmp9_14;
wire signed [15:0] layer_3_conv_tmp9_15;
wire signed [15:0] layer_3_conv_tmp9_16;
wire signed [15:0] layer_3_conv_tmp9_17;
wire signed [15:0] layer_3_conv_tmp9_18;

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
		if (k_loop)	//控制九组
			k_ind <= k_ind + 9;
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
				ram_ready <= (ram_ready << 9);	//trick
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

k2_out layer_2_c(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind),
						.k1(k2_1),.k2(k2_2),.k3(k2_3),.k4(k2_4),.k5(k2_5),.k6(k2_6),.k7(k2_7),.k8(k2_8),.k9(k2_9),
						.k10(k2_10),.k11(k2_11),.k12(k2_12),.k13(k2_13),.k14(k2_14),.k15(k2_15),.k16(k2_16),.k17(k2_17),.k18(k2_18));
						
k2_out layer_2_c2(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+1),
						.k1(k2_19),.k2(k2_20),.k3(k2_21),.k4(k2_22),.k5(k2_23),.k6(k2_24),.k7(k2_25),.k8(k2_26),.k9(k2_27),
						.k10(k2_28),.k11(k2_29),.k12(k2_30),.k13(k2_31),.k14(k2_32),.k15(k2_33),.k16(k2_34),.k17(k2_35),.k18(k2_36));
						
k2_out layer_2_c3(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+2),
						.k1(k2_37),.k2(k2_38),.k3(k2_39),.k4(k2_40),.k5(k2_41),.k6(k2_42),.k7(k2_43),.k8(k2_44),.k9(k2_45),
						.k10(k2_46),.k11(k2_47),.k12(k2_48),.k13(k2_49),.k14(k2_50),.k15(k2_51),.k16(k2_52),.k17(k2_53),.k18(k2_54));

k2_out layer_2_c4(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+3),
						.k1(k2_55),.k2(k2_56),.k3(k2_57),.k4(k2_58),.k5(k2_59),.k6(k2_60),.k7(k2_61),.k8(k2_62),.k9(k2_63),
						.k10(k2_64),.k11(k2_65),.k12(k2_66),.k13(k2_67),.k14(k2_68),.k15(k2_69),.k16(k2_70),.k17(k2_71),.k18(k2_72));
						
k2_out layer_2_c5(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+4),
						.k1(k2_73),.k2(k2_74),.k3(k2_75),.k4(k2_76),.k5(k2_77),.k6(k2_78),.k7(k2_79),.k8(k2_80),.k9(k2_81),
						.k10(k2_82),.k11(k2_83),.k12(k2_84),.k13(k2_85),.k14(k2_86),.k15(k2_87),.k16(k2_88),.k17(k2_89),.k18(k2_90));
						
k2_out layer_2_c6(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+5),
						.k1(k2_91),.k2(k2_92),.k3(k2_93),.k4(k2_94),.k5(k2_95),.k6(k2_96),.k7(k2_97),.k8(k2_98),.k9(k2_99),
						.k10(k2_100),.k11(k2_101),.k12(k2_102),.k13(k2_103),.k14(k2_104),.k15(k2_105),.k16(k2_106),.k17(k2_107),.k18(k2_108));
						
k2_out layer_2_c7(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+6),
						.k1(k2_109),.k2(k2_110),.k3(k2_111),.k4(k2_112),.k5(k2_113),.k6(k2_114),.k7(k2_115),.k8(k2_116),.k9(k2_117),
						.k10(k2_118),.k11(k2_119),.k12(k2_120),.k13(k2_121),.k14(k2_122),.k15(k2_123),.k16(k2_124),.k17(k2_125),.k18(k2_126));
						
k2_out layer_2_c8(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+7),
						.k1(k2_127),.k2(k2_128),.k3(k2_129),.k4(k2_130),.k5(k2_131),.k6(k2_132),.k7(k2_133),.k8(k2_134),.k9(k2_135),
						.k10(k2_136),.k11(k2_137),.k12(k2_138),.k13(k2_139),.k14(k2_140),.k15(k2_141),.k16(k2_142),.k17(k2_143),.k18(k2_144));
						
k2_out layer_2_c9(.clk_in(clk_in),.rst_n(layer_2_a_ready),.k_ready(k2_ready),.k_ind(k_ind+8),
						.k1(k2_145),.k2(k2_146),.k3(k2_147),.k4(k2_148),.k5(k2_149),.k6(k2_150),.k7(k2_151),.k8(k2_152),.k9(k2_153),
						.k10(k2_154),.k11(k2_155),.k12(k2_156),.k13(k2_157),.k14(k2_158),.k15(k2_159),.k16(k2_160),.k17(k2_161),.k18(k2_162));						

m_conv_3 layer_3_1_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_1),.map_out(layer_3_conv_tmp_1),.ready(layer_3_a_ready));
m_conv_3 layer_3_2_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_2),.map_out(layer_3_conv_tmp_2));
m_conv_3 layer_3_3_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_3),.map_out(layer_3_conv_tmp_3));
m_conv_3 layer_3_4_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_4),.map_out(layer_3_conv_tmp_4));
m_conv_3 layer_3_5_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_5),.map_out(layer_3_conv_tmp_5));
m_conv_3 layer_3_6_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_6),.map_out(layer_3_conv_tmp_6));
m_conv_3 layer_3_7_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_7),.map_out(layer_3_conv_tmp_7));
m_conv_3 layer_3_8_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_8),.map_out(layer_3_conv_tmp_8));
m_conv_3 layer_3_9_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_9),.map_out(layer_3_conv_tmp_9));
m_conv_3 layer_3_10_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_10),.map_out(layer_3_conv_tmp_10));	
m_conv_3 layer_3_11_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_11),.map_out(layer_3_conv_tmp_11));
m_conv_3 layer_3_12_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_12),.map_out(layer_3_conv_tmp_12));
m_conv_3 layer_3_13_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_13),.map_out(layer_3_conv_tmp_13));
m_conv_3 layer_3_14_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_14),.map_out(layer_3_conv_tmp_14));
m_conv_3 layer_3_15_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_15),.map_out(layer_3_conv_tmp_15));
m_conv_3 layer_3_16_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_16),.map_out(layer_3_conv_tmp_16));
m_conv_3 layer_3_17_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_17),.map_out(layer_3_conv_tmp_17));
m_conv_3 layer_3_18_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_18),.map_out(layer_3_conv_tmp_18));

m_conv_3 layer_3_19_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_19),.map_out(layer_3_conv_tmp2_1));
m_conv_3 layer_3_20_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_20),.map_out(layer_3_conv_tmp2_2));
m_conv_3 layer_3_21_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_21),.map_out(layer_3_conv_tmp2_3));
m_conv_3 layer_3_22_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_22),.map_out(layer_3_conv_tmp2_4));
m_conv_3 layer_3_23_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_23),.map_out(layer_3_conv_tmp2_5));
m_conv_3 layer_3_24_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_24),.map_out(layer_3_conv_tmp2_6));
m_conv_3 layer_3_25_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_25),.map_out(layer_3_conv_tmp2_7));
m_conv_3 layer_3_26_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_26),.map_out(layer_3_conv_tmp2_8));
m_conv_3 layer_3_27_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_27),.map_out(layer_3_conv_tmp2_9));	
m_conv_3 layer_3_28_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_28),.map_out(layer_3_conv_tmp2_10));
m_conv_3 layer_3_29_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_29),.map_out(layer_3_conv_tmp2_11));
m_conv_3 layer_3_30_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_30),.map_out(layer_3_conv_tmp2_12));
m_conv_3 layer_3_31_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_31),.map_out(layer_3_conv_tmp2_13));
m_conv_3 layer_3_32_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_32),.map_out(layer_3_conv_tmp2_14));
m_conv_3 layer_3_33_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_33),.map_out(layer_3_conv_tmp2_15));
m_conv_3 layer_3_34_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_34),.map_out(layer_3_conv_tmp2_16));
m_conv_3 layer_3_35_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_35),.map_out(layer_3_conv_tmp2_17));
m_conv_3 layer_3_36_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_36),.map_out(layer_3_conv_tmp2_18));

m_conv_3 layer_3_37_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_37),.map_out(layer_3_conv_tmp3_1));
m_conv_3 layer_3_38_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_38),.map_out(layer_3_conv_tmp3_2));
m_conv_3 layer_3_39_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_39),.map_out(layer_3_conv_tmp3_3));
m_conv_3 layer_3_40_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_40),.map_out(layer_3_conv_tmp3_4));
m_conv_3 layer_3_41_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_41),.map_out(layer_3_conv_tmp3_5));
m_conv_3 layer_3_42_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_42),.map_out(layer_3_conv_tmp3_6));
m_conv_3 layer_3_43_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_43),.map_out(layer_3_conv_tmp3_7));
m_conv_3 layer_3_44_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_44),.map_out(layer_3_conv_tmp3_8));
m_conv_3 layer_3_45_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_45),.map_out(layer_3_conv_tmp3_9));	
m_conv_3 layer_3_46_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_46),.map_out(layer_3_conv_tmp3_10));
m_conv_3 layer_3_47_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_47),.map_out(layer_3_conv_tmp3_11));
m_conv_3 layer_3_48_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_48),.map_out(layer_3_conv_tmp3_12));
m_conv_3 layer_3_49_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_49),.map_out(layer_3_conv_tmp3_13));
m_conv_3 layer_3_50_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_50),.map_out(layer_3_conv_tmp3_14));
m_conv_3 layer_3_51_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_51),.map_out(layer_3_conv_tmp3_15));
m_conv_3 layer_3_52_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_52),.map_out(layer_3_conv_tmp3_16));
m_conv_3 layer_3_53_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_53),.map_out(layer_3_conv_tmp3_17));
m_conv_3 layer_3_54_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_54),.map_out(layer_3_conv_tmp3_18));

m_conv_3 layer_3_55_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_55),.map_out(layer_3_conv_tmp4_1));
m_conv_3 layer_3_56_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_56),.map_out(layer_3_conv_tmp4_2));
m_conv_3 layer_3_57_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_57),.map_out(layer_3_conv_tmp4_3));
m_conv_3 layer_3_58_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_58),.map_out(layer_3_conv_tmp4_4));
m_conv_3 layer_3_59_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_59),.map_out(layer_3_conv_tmp4_5));
m_conv_3 layer_3_60_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_60),.map_out(layer_3_conv_tmp4_6));
m_conv_3 layer_3_61_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_61),.map_out(layer_3_conv_tmp4_7));
m_conv_3 layer_3_62_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_62),.map_out(layer_3_conv_tmp4_8));
m_conv_3 layer_3_63_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_63),.map_out(layer_3_conv_tmp4_9));	
m_conv_3 layer_3_64_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_64),.map_out(layer_3_conv_tmp4_10));
m_conv_3 layer_3_65_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_65),.map_out(layer_3_conv_tmp4_11));
m_conv_3 layer_3_66_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_66),.map_out(layer_3_conv_tmp4_12));
m_conv_3 layer_3_67_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_67),.map_out(layer_3_conv_tmp4_13));
m_conv_3 layer_3_68_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_68),.map_out(layer_3_conv_tmp4_14));
m_conv_3 layer_3_69_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_69),.map_out(layer_3_conv_tmp4_15));
m_conv_3 layer_3_70_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_70),.map_out(layer_3_conv_tmp4_16));
m_conv_3 layer_3_71_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_71),.map_out(layer_3_conv_tmp4_17));
m_conv_3 layer_3_72_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_72),.map_out(layer_3_conv_tmp4_18));

m_conv_3 layer_3_73_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_73),.map_out(layer_3_conv_tmp5_1));
m_conv_3 layer_3_74_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_74),.map_out(layer_3_conv_tmp5_2));
m_conv_3 layer_3_75_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_75),.map_out(layer_3_conv_tmp5_3));
m_conv_3 layer_3_76_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_76),.map_out(layer_3_conv_tmp5_4));
m_conv_3 layer_3_77_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_77),.map_out(layer_3_conv_tmp5_5));
m_conv_3 layer_3_78_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_78),.map_out(layer_3_conv_tmp5_6));
m_conv_3 layer_3_79_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_79),.map_out(layer_3_conv_tmp5_7));
m_conv_3 layer_3_80_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_80),.map_out(layer_3_conv_tmp5_8));
m_conv_3 layer_3_81_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_81),.map_out(layer_3_conv_tmp5_9));
m_conv_3 layer_3_82_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_82),.map_out(layer_3_conv_tmp5_10));	
m_conv_3 layer_3_83_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_83),.map_out(layer_3_conv_tmp5_11));
m_conv_3 layer_3_84_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_84),.map_out(layer_3_conv_tmp5_12));
m_conv_3 layer_3_85_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_85),.map_out(layer_3_conv_tmp5_13));
m_conv_3 layer_3_86_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_86),.map_out(layer_3_conv_tmp5_14));
m_conv_3 layer_3_87_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_87),.map_out(layer_3_conv_tmp5_15));
m_conv_3 layer_3_88_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_88),.map_out(layer_3_conv_tmp5_16));
m_conv_3 layer_3_89_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_89),.map_out(layer_3_conv_tmp5_17));
m_conv_3 layer_3_90_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_90),.map_out(layer_3_conv_tmp5_18));

m_conv_3 layer_3_91_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_91),.map_out(layer_3_conv_tmp6_1));
m_conv_3 layer_3_92_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_92),.map_out(layer_3_conv_tmp6_2));
m_conv_3 layer_3_93_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_93),.map_out(layer_3_conv_tmp6_3));
m_conv_3 layer_3_94_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_94),.map_out(layer_3_conv_tmp6_4));
m_conv_3 layer_3_95_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_95),.map_out(layer_3_conv_tmp6_5));
m_conv_3 layer_3_96_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_96),.map_out(layer_3_conv_tmp6_6));
m_conv_3 layer_3_97_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_97),.map_out(layer_3_conv_tmp6_7));
m_conv_3 layer_3_98_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_98),.map_out(layer_3_conv_tmp6_8));
m_conv_3 layer_3_99_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_99),.map_out(layer_3_conv_tmp6_9));	
m_conv_3 layer_3_100_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_100),.map_out(layer_3_conv_tmp6_10));
m_conv_3 layer_3_101_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_101),.map_out(layer_3_conv_tmp6_11));
m_conv_3 layer_3_102_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_102),.map_out(layer_3_conv_tmp6_12));
m_conv_3 layer_3_103_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_103),.map_out(layer_3_conv_tmp6_13));
m_conv_3 layer_3_104_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_104),.map_out(layer_3_conv_tmp6_14));
m_conv_3 layer_3_105_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_105),.map_out(layer_3_conv_tmp6_15));
m_conv_3 layer_3_106_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_106),.map_out(layer_3_conv_tmp6_16));
m_conv_3 layer_3_107_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_107),.map_out(layer_3_conv_tmp6_17));
m_conv_3 layer_3_108_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_108),.map_out(layer_3_conv_tmp6_18));

m_conv_3 layer_3_109_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_109),.map_out(layer_3_conv_tmp7_1));
m_conv_3 layer_3_110_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_110),.map_out(layer_3_conv_tmp7_2));
m_conv_3 layer_3_111_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_111),.map_out(layer_3_conv_tmp7_3));
m_conv_3 layer_3_112_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_112),.map_out(layer_3_conv_tmp7_4));
m_conv_3 layer_3_113_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_113),.map_out(layer_3_conv_tmp7_5));
m_conv_3 layer_3_114_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_114),.map_out(layer_3_conv_tmp7_6));
m_conv_3 layer_3_115_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_115),.map_out(layer_3_conv_tmp7_7));
m_conv_3 layer_3_116_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_116),.map_out(layer_3_conv_tmp7_8));
m_conv_3 layer_3_117_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_117),.map_out(layer_3_conv_tmp7_9));	
m_conv_3 layer_3_118_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_118),.map_out(layer_3_conv_tmp7_10));
m_conv_3 layer_3_119_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_119),.map_out(layer_3_conv_tmp7_11));
m_conv_3 layer_3_120_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_120),.map_out(layer_3_conv_tmp7_12));
m_conv_3 layer_3_121_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_121),.map_out(layer_3_conv_tmp7_13));
m_conv_3 layer_3_122_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_122),.map_out(layer_3_conv_tmp7_14));
m_conv_3 layer_3_123_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_123),.map_out(layer_3_conv_tmp7_15));
m_conv_3 layer_3_124_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_124),.map_out(layer_3_conv_tmp7_16));
m_conv_3 layer_3_125_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_125),.map_out(layer_3_conv_tmp7_17));
m_conv_3 layer_3_126_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_126),.map_out(layer_3_conv_tmp7_18));

m_conv_3 layer_3_127_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_127),.map_out(layer_3_conv_tmp8_1));
m_conv_3 layer_3_128_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_128),.map_out(layer_3_conv_tmp8_2));
m_conv_3 layer_3_129_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_129),.map_out(layer_3_conv_tmp8_3));
m_conv_3 layer_3_130_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_130),.map_out(layer_3_conv_tmp8_4));
m_conv_3 layer_3_131_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_131),.map_out(layer_3_conv_tmp8_5));
m_conv_3 layer_3_132_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_132),.map_out(layer_3_conv_tmp8_6));
m_conv_3 layer_3_133_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_133),.map_out(layer_3_conv_tmp8_7));
m_conv_3 layer_3_134_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_134),.map_out(layer_3_conv_tmp8_8));
m_conv_3 layer_3_135_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_135),.map_out(layer_3_conv_tmp8_9));	
m_conv_3 layer_3_136_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_136),.map_out(layer_3_conv_tmp8_10));
m_conv_3 layer_3_137_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_137),.map_out(layer_3_conv_tmp8_11));
m_conv_3 layer_3_138_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_138),.map_out(layer_3_conv_tmp8_12));
m_conv_3 layer_3_139_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_139),.map_out(layer_3_conv_tmp8_13));
m_conv_3 layer_3_140_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_140),.map_out(layer_3_conv_tmp8_14));
m_conv_3 layer_3_141_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_141),.map_out(layer_3_conv_tmp8_15));
m_conv_3 layer_3_142_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_142),.map_out(layer_3_conv_tmp8_16));
m_conv_3 layer_3_143_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_143),.map_out(layer_3_conv_tmp8_17));
m_conv_3 layer_3_144_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_144),.map_out(layer_3_conv_tmp8_18));

m_conv_3 layer_3_145_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[0]),.k_in(k2_145),.map_out(layer_3_conv_tmp9_1));
m_conv_3 layer_3_146_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[1]),.k_in(k2_146),.map_out(layer_3_conv_tmp9_2));
m_conv_3 layer_3_147_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[2]),.k_in(k2_147),.map_out(layer_3_conv_tmp9_3));
m_conv_3 layer_3_148_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[3]),.k_in(k2_148),.map_out(layer_3_conv_tmp9_4));
m_conv_3 layer_3_149_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[4]),.k_in(k2_149),.map_out(layer_3_conv_tmp9_5));
m_conv_3 layer_3_150_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[5]),.k_in(k2_150),.map_out(layer_3_conv_tmp9_6));
m_conv_3 layer_3_151_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[6]),.k_in(k2_151),.map_out(layer_3_conv_tmp9_7));
m_conv_3 layer_3_152_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[7]),.k_in(k2_152),.map_out(layer_3_conv_tmp9_8));
m_conv_3 layer_3_153_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[8]),.k_in(k2_153),.map_out(layer_3_conv_tmp9_9));	
m_conv_3 layer_3_154_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[9]),.k_in(k2_154),.map_out(layer_3_conv_tmp9_10));
m_conv_3 layer_3_155_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[10]),.k_in(k2_155),.map_out(layer_3_conv_tmp9_11));
m_conv_3 layer_3_156_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[11]),.k_in(k2_156),.map_out(layer_3_conv_tmp9_12));
m_conv_3 layer_3_157_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[12]),.k_in(k2_157),.map_out(layer_3_conv_tmp9_13));
m_conv_3 layer_3_158_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[13]),.k_in(k2_158),.map_out(layer_3_conv_tmp9_14));
m_conv_3 layer_3_159_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[14]),.k_in(k2_159),.map_out(layer_3_conv_tmp9_15));
m_conv_3 layer_3_160_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[15]),.k_in(k2_160),.map_out(layer_3_conv_tmp9_16));
m_conv_3 layer_3_161_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[16]),.k_in(k2_161),.map_out(layer_3_conv_tmp9_17));
m_conv_3 layer_3_162_a(.clk_in(clk_in),.rst_n(layer_2_b_ready),.map_in(layer_2_max[17]),.k_in(k2_162),.map_out(layer_3_conv_tmp9_18));

genvar j;	
generate
	for (j = 0 ; j < 36 ; j = j + 9)
	begin	: g2			
		//需要将前一层的几个结果加起来，再加上偏置
		conv_adder18 layer_3_b2(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp2_1),	
				.a2(layer_3_conv_tmp2_2),	
				.a3(layer_3_conv_tmp2_3),	
				.a4(layer_3_conv_tmp2_4),	
				.a5(layer_3_conv_tmp2_5),	
				.a6(layer_3_conv_tmp2_6),	
				.a7(layer_3_conv_tmp2_7),	
				.a8(layer_3_conv_tmp2_8),	
				.a9(layer_3_conv_tmp2_9),
				.a10(layer_3_conv_tmp2_10),	
				.a11(layer_3_conv_tmp2_11),	
				.a12(layer_3_conv_tmp2_12),	
				.a13(layer_3_conv_tmp2_13),	
				.a14(layer_3_conv_tmp2_14),	
				.a15(layer_3_conv_tmp2_15),	
				.a16(layer_3_conv_tmp2_16),	
				.a17(layer_3_conv_tmp2_17),	
				.a18(layer_3_conv_tmp2_18),
				.b_ind(j+1),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+1]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c2(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+1]),.map_in(layer_3_conv[j+1]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+1]));
		m_max_relu_4 layer_4_a2(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+1]),.map_out(layer_4_max_tmp[j+1]));
		m_layer_input_4 layer_4_b2(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+1]),.wr(layer_4_wr),.map_out(layer_4_max[j+1]));
		
		conv_adder18 layer_3_b3(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp3_1),	
				.a2(layer_3_conv_tmp3_2),	
				.a3(layer_3_conv_tmp3_3),	
				.a4(layer_3_conv_tmp3_4),	
				.a5(layer_3_conv_tmp3_5),	
				.a6(layer_3_conv_tmp3_6),	
				.a7(layer_3_conv_tmp3_7),	
				.a8(layer_3_conv_tmp3_8),	
				.a9(layer_3_conv_tmp3_9),
				.a10(layer_3_conv_tmp3_10),	
				.a11(layer_3_conv_tmp3_11),	
				.a12(layer_3_conv_tmp3_12),	
				.a13(layer_3_conv_tmp3_13),	
				.a14(layer_3_conv_tmp3_14),	
				.a15(layer_3_conv_tmp3_15),	
				.a16(layer_3_conv_tmp3_16),	
				.a17(layer_3_conv_tmp3_17),	
				.a18(layer_3_conv_tmp3_18),
				.b_ind(j+2),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+2]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c3(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+2]),.map_in(layer_3_conv[j+2]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+2]));
		m_max_relu_4 layer_4_a3(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+2]),.map_out(layer_4_max_tmp[j+2]));
		m_layer_input_4 layer_4_b3(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+2]),.wr(layer_4_wr),.map_out(layer_4_max[j+2]));
		
		conv_adder18 layer_3_b4(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp4_1),	
				.a2(layer_3_conv_tmp4_2),	
				.a3(layer_3_conv_tmp4_3),	
				.a4(layer_3_conv_tmp4_4),	
				.a5(layer_3_conv_tmp4_5),	
				.a6(layer_3_conv_tmp4_6),	
				.a7(layer_3_conv_tmp4_7),	
				.a8(layer_3_conv_tmp4_8),	
				.a9(layer_3_conv_tmp4_9),
				.a10(layer_3_conv_tmp4_10),	
				.a11(layer_3_conv_tmp4_11),	
				.a12(layer_3_conv_tmp4_12),	
				.a13(layer_3_conv_tmp4_13),	
				.a14(layer_3_conv_tmp4_14),	
				.a15(layer_3_conv_tmp4_15),	
				.a16(layer_3_conv_tmp4_16),	
				.a17(layer_3_conv_tmp4_17),	
				.a18(layer_3_conv_tmp4_18),
				.b_ind(j+3),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+3]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c4(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+3]),.map_in(layer_3_conv[j+3]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+3]));
		m_max_relu_4 layer_4_a4(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+3]),.map_out(layer_4_max_tmp[j+3]));
		m_layer_input_4 layer_4_b4(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+3]),.wr(layer_4_wr),.map_out(layer_4_max[j+3]));
		
		conv_adder18 layer_3_b5(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp5_1),	
				.a2(layer_3_conv_tmp5_2),	
				.a3(layer_3_conv_tmp5_3),	
				.a4(layer_3_conv_tmp5_4),	
				.a5(layer_3_conv_tmp5_5),	
				.a6(layer_3_conv_tmp5_6),	
				.a7(layer_3_conv_tmp5_7),	
				.a8(layer_3_conv_tmp5_8),	
				.a9(layer_3_conv_tmp5_9),
				.a10(layer_3_conv_tmp5_10),	
				.a11(layer_3_conv_tmp5_11),	
				.a12(layer_3_conv_tmp5_12),	
				.a13(layer_3_conv_tmp5_13),	
				.a14(layer_3_conv_tmp5_14),	
				.a15(layer_3_conv_tmp5_15),	
				.a16(layer_3_conv_tmp5_16),	
				.a17(layer_3_conv_tmp5_17),	
				.a18(layer_3_conv_tmp5_18),
				.b_ind(j+4),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+4]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c5(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+4]),.map_in(layer_3_conv[j+4]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+4]));
		m_max_relu_4 layer_4_a5(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+4]),.map_out(layer_4_max_tmp[j+4]));
		m_layer_input_4 layer_4_b5(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+4]),.wr(layer_4_wr),.map_out(layer_4_max[j+4]));
		
		conv_adder18 layer_3_b6(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp6_1),	
				.a2(layer_3_conv_tmp6_2),	
				.a3(layer_3_conv_tmp6_3),	
				.a4(layer_3_conv_tmp6_4),	
				.a5(layer_3_conv_tmp6_5),	
				.a6(layer_3_conv_tmp6_6),	
				.a7(layer_3_conv_tmp6_7),	
				.a8(layer_3_conv_tmp6_8),	
				.a9(layer_3_conv_tmp6_9),
				.a10(layer_3_conv_tmp6_10),	
				.a11(layer_3_conv_tmp6_11),	
				.a12(layer_3_conv_tmp6_12),	
				.a13(layer_3_conv_tmp6_13),	
				.a14(layer_3_conv_tmp6_14),	
				.a15(layer_3_conv_tmp6_15),	
				.a16(layer_3_conv_tmp6_16),	
				.a17(layer_3_conv_tmp6_17),	
				.a18(layer_3_conv_tmp6_18),
				.b_ind(j+5),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+5]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c6(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+5]),.map_in(layer_3_conv[j+5]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+5]));
		m_max_relu_4 layer_4_a6(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+5]),.map_out(layer_4_max_tmp[j+5]));
		m_layer_input_4 layer_4_b6(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+5]),.wr(layer_4_wr),.map_out(layer_4_max[j+5]));
		
		conv_adder18 layer_3_b7(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp7_1),	
				.a2(layer_3_conv_tmp7_2),	
				.a3(layer_3_conv_tmp7_3),	
				.a4(layer_3_conv_tmp7_4),	
				.a5(layer_3_conv_tmp7_5),	
				.a6(layer_3_conv_tmp7_6),	
				.a7(layer_3_conv_tmp7_7),	
				.a8(layer_3_conv_tmp7_8),	
				.a9(layer_3_conv_tmp7_9),
				.a10(layer_3_conv_tmp7_10),	
				.a11(layer_3_conv_tmp7_11),	
				.a12(layer_3_conv_tmp7_12),	
				.a13(layer_3_conv_tmp7_13),	
				.a14(layer_3_conv_tmp7_14),	
				.a15(layer_3_conv_tmp7_15),	
				.a16(layer_3_conv_tmp7_16),	
				.a17(layer_3_conv_tmp7_17),	
				.a18(layer_3_conv_tmp7_18),
				.b_ind(j+6),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+6]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c7(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+6]),.map_in(layer_3_conv[j+6]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+6]));
		m_max_relu_4 layer_4_a7(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+6]),.map_out(layer_4_max_tmp[j+6]));
		m_layer_input_4 layer_4_b7(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+6]),.wr(layer_4_wr),.map_out(layer_4_max[j+6]));
		
		conv_adder18 layer_3_b8(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp8_1),	
				.a2(layer_3_conv_tmp8_2),	
				.a3(layer_3_conv_tmp8_3),	
				.a4(layer_3_conv_tmp8_4),	
				.a5(layer_3_conv_tmp8_5),	
				.a6(layer_3_conv_tmp8_6),	
				.a7(layer_3_conv_tmp8_7),	
				.a8(layer_3_conv_tmp8_8),	
				.a9(layer_3_conv_tmp8_9),
				.a10(layer_3_conv_tmp8_10),	
				.a11(layer_3_conv_tmp8_11),	
				.a12(layer_3_conv_tmp8_12),	
				.a13(layer_3_conv_tmp8_13),	
				.a14(layer_3_conv_tmp8_14),	
				.a15(layer_3_conv_tmp8_15),	
				.a16(layer_3_conv_tmp8_16),	
				.a17(layer_3_conv_tmp8_17),	
				.a18(layer_3_conv_tmp8_18),
				.b_ind(j+7),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+7]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c8(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+7]),.map_in(layer_3_conv[j+7]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+7]));
		m_max_relu_4 layer_4_a8(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+7]),.map_out(layer_4_max_tmp[j+7]));
		m_layer_input_4 layer_4_b8(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+7]),.wr(layer_4_wr),.map_out(layer_4_max[j+7]));
		
		conv_adder18 layer_3_b9(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp9_1),	
				.a2(layer_3_conv_tmp9_2),	
				.a3(layer_3_conv_tmp9_3),	
				.a4(layer_3_conv_tmp9_4),	
				.a5(layer_3_conv_tmp9_5),	
				.a6(layer_3_conv_tmp9_6),	
				.a7(layer_3_conv_tmp9_7),	
				.a8(layer_3_conv_tmp9_8),	
				.a9(layer_3_conv_tmp9_9),
				.a10(layer_3_conv_tmp9_10),	
				.a11(layer_3_conv_tmp9_11),	
				.a12(layer_3_conv_tmp9_12),	
				.a13(layer_3_conv_tmp9_13),	
				.a14(layer_3_conv_tmp9_14),	
				.a15(layer_3_conv_tmp9_15),	
				.a16(layer_3_conv_tmp9_16),	
				.a17(layer_3_conv_tmp9_17),	
				.a18(layer_3_conv_tmp9_18),
				.b_ind(j+8),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j+8]));
		//控制陆续写入，最后ram_ready[35]一起读出来
		m_layer_input_3 layer_3_c9(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j+8]),.map_in(layer_3_conv[j+8]),.wr(layer_3_wr),.map_out(layer_3_conv2[j+8]));
		m_max_relu_4 layer_4_a9(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j+8]),.map_out(layer_4_max_tmp[j+8]));
		m_layer_input_4 layer_4_b9(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j+8]),.wr(layer_4_wr),.map_out(layer_4_max[j+8]));

		if (j == 0)
		begin
			conv_adder18 layer_3_b(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp_1),	
				.a2(layer_3_conv_tmp_2),	
				.a3(layer_3_conv_tmp_3),	
				.a4(layer_3_conv_tmp_4),	
				.a5(layer_3_conv_tmp_5),	
				.a6(layer_3_conv_tmp_6),	
				.a7(layer_3_conv_tmp_7),	
				.a8(layer_3_conv_tmp_8),	
				.a9(layer_3_conv_tmp_9),
				.a10(layer_3_conv_tmp_10),	
				.a11(layer_3_conv_tmp_11),	
				.a12(layer_3_conv_tmp_12),	
				.a13(layer_3_conv_tmp_13),	
				.a14(layer_3_conv_tmp_14),	
				.a15(layer_3_conv_tmp_15),	
				.a16(layer_3_conv_tmp_16),	
				.a17(layer_3_conv_tmp_17),	
				.a18(layer_3_conv_tmp_18),
				.b_ind(j),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j]),.wr(layer_3_wr),.ready(layer_3_b_ready));
			m_layer_input_3 layer_3_c(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j]),.map_in(layer_3_conv[j]),.wr(layer_3_wr),.map_out(layer_3_conv2[j]),.ready(layer_3_c_ready));
			m_max_relu_4 layer_4_a(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j]),.map_out(layer_4_max_tmp[j]),.wr(layer_4_wr),.ready(layer_4_a_ready));
			m_layer_input_4 layer_4_b(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j]),.wr(layer_4_wr),.map_out(layer_4_max[j]),.k_loop(k_loop2),.k_ready(k4_ready),.ready(layer_4_b_ready));

		end
		else
		begin
			conv_adder18 layer_3_b(.clk_in(clk_in),.rst_n(layer_2_b_ready),
				.a1(layer_3_conv_tmp_1),	
				.a2(layer_3_conv_tmp_2),	
				.a3(layer_3_conv_tmp_3),	
				.a4(layer_3_conv_tmp_4),	
				.a5(layer_3_conv_tmp_5),	
				.a6(layer_3_conv_tmp_6),	
				.a7(layer_3_conv_tmp_7),	
				.a8(layer_3_conv_tmp_8),	
				.a9(layer_3_conv_tmp_9),
				.a10(layer_3_conv_tmp_10),	
				.a11(layer_3_conv_tmp_11),	
				.a12(layer_3_conv_tmp_12),	
				.a13(layer_3_conv_tmp_13),	
				.a14(layer_3_conv_tmp_14),	
				.a15(layer_3_conv_tmp_15),	
				.a16(layer_3_conv_tmp_16),	
				.a17(layer_3_conv_tmp_17),	
				.a18(layer_3_conv_tmp_18),
				.b_ind(j),.last_ready(layer_3_a_ready),.add_out(layer_3_conv[j]));
			m_layer_input_3 layer_3_c(.clk_in(clk_in),.rst_n(ram_ready[35]),.rst_n_tmp(ram_ready[j]),.map_in(layer_3_conv[j]),.wr(layer_3_wr),.map_out(layer_3_conv2[j]));
			m_max_relu_4 layer_4_a(.clk_in(clk_in),.rst_n(layer_3_c_ready),.map_in(layer_3_conv2[j]),.map_out(layer_4_max_tmp[j]));
			m_layer_input_4 layer_4_b(.clk_in(clk_in),.rst_n(layer_4_a_ready),.map_in(layer_4_max_tmp[j]),.wr(layer_4_wr),.map_out(layer_4_max[j]));

		end
	end
endgenerate

wire signed [15:0] k3_1, k3_2, k3_3, k3_4, k3_5, k3_6, k3_7, k3_8, k3_9, k3_10, k3_11, k3_12, k3_13, k3_14, k3_15, k3_16, k3_17, k3_18;
wire signed [15:0] k3_19, k3_20, k3_21, k3_22, k3_23, k3_24, k3_25, k3_26, k3_27, k3_28, k3_29, k3_30, k3_31, k3_32, k3_33, k3_34, k3_35, k3_36;

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
   .clk_in(clk_in),.rst_n(layer_4_b_ready_delay6),
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
