`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:28 02/24/2017 
// Design Name: 
// Module Name:    m_conv_1 
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
module m_conv_1_8(
	clk_in,
	rst_n,
	map_in,
	start,
	map_out,
	save,
	ready
    );

parameter nun_in = 14'd9215;
parameter len_shift = 10'd864;
parameter kernel_size = 4'd9;
parameter num_mult = 7'd81;
parameter num_out = 13'd7744;

input clk_in;
input rst_n;
input signed [15:0] map_in;
input start;
output reg signed [15:0] map_out = 0;
output reg save = 0;
output reg ready = 1;

reg [6:0] res_cnt = 0;

reg signed [15:0] shift_reg [len_shift-1:0];
reg [9:0] i = 0;

reg signed [15:0] mult_tmp [80:0];
wire signed [15:0] k1 [80:0];
wire signed [31:0] mult [80:0];
reg [3:0] j = 0;

reg signed [31:0] adder_1 = 0;
reg signed [31:0] adder_2 = 0;
reg signed [31:0] adder_3 = 0;
reg signed [31:0] adder_4 = 0;
reg signed [31:0] adder_5 = 0;
reg signed [31:0] adder_6 = 0;
reg signed [31:0] adder_7 = 0;
reg signed [31:0] adder_8 = 0;
reg signed [31:0] adder_9 = 0;
reg signed [31:0] adder_10 = 0;

reg [12:0] out_cnt = 0;

always @ (posedge clk_in)
begin
	if(rst_n)
		res_cnt <= 0;
	else
	begin
		if(start)
		begin
			if(res_cnt == 100)	
				res_cnt <= 5;	
			else
				res_cnt <= res_cnt + 1;
		end
		else
			res_cnt <= 0;
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		for(i=0;i<len_shift;i=i+1)
			shift_reg[i] <= 0;
	end
	else
	begin
		shift_reg[len_shift-1] <= map_in;
		for(i=1;i<len_shift;i=i+1)
			shift_reg[i-1] <= shift_reg[i];
	end
end
always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		mult_tmp[0] <= 0;
		mult_tmp[1] <= 0;
		mult_tmp[2] <= 0;
		mult_tmp[3] <= 0;
		mult_tmp[4] <= 0;
		mult_tmp[5] <= 0;
		mult_tmp[6] <= 0;
		mult_tmp[7] <= 0;
		mult_tmp[8] <= 0;
		mult_tmp[9] <= 0;
		mult_tmp[10] <= 0;
		mult_tmp[11] <= 0;
		mult_tmp[12] <= 0;
		mult_tmp[13] <= 0;
		mult_tmp[14] <= 0;
		mult_tmp[15] <= 0;
		mult_tmp[16] <= 0;
		mult_tmp[17] <= 0;
		mult_tmp[18] <= 0;
		mult_tmp[19] <= 0;
		mult_tmp[20] <= 0;
		mult_tmp[21] <= 0;
		mult_tmp[22] <= 0;
		mult_tmp[23] <= 0;
		mult_tmp[24] <= 0;
		mult_tmp[25] <= 0;
		mult_tmp[26] <= 0;
		mult_tmp[27] <= 0;
		mult_tmp[28] <= 0;
		mult_tmp[29] <= 0;
		mult_tmp[30] <= 0;
		mult_tmp[31] <= 0;
		mult_tmp[32] <= 0;
		mult_tmp[33] <= 0;
		mult_tmp[34] <= 0;
		mult_tmp[35] <= 0;
		mult_tmp[36] <= 0;
		mult_tmp[37] <= 0;
		mult_tmp[38] <= 0;
		mult_tmp[39] <= 0;
		mult_tmp[40] <= 0;
		mult_tmp[41] <= 0;
		mult_tmp[42] <= 0;
		mult_tmp[43] <= 0;
		mult_tmp[44] <= 0;
		mult_tmp[45] <= 0;
		mult_tmp[46] <= 0;
		mult_tmp[47] <= 0;
		mult_tmp[48] <= 0;
		mult_tmp[49] <= 0;
		mult_tmp[50] <= 0;
		mult_tmp[51] <= 0;
		mult_tmp[52] <= 0;
		mult_tmp[53] <= 0;
		mult_tmp[54] <= 0;
		mult_tmp[55] <= 0;
		mult_tmp[56] <= 0;
		mult_tmp[57] <= 0;
		mult_tmp[58] <= 0;
		mult_tmp[59] <= 0;
		mult_tmp[60] <= 0;
		mult_tmp[61] <= 0;
		mult_tmp[62] <= 0;
		mult_tmp[63] <= 0;
		mult_tmp[64] <= 0;
		mult_tmp[65] <= 0;
		mult_tmp[66] <= 0;
		mult_tmp[67] <= 0;
		mult_tmp[68] <= 0;
		mult_tmp[69] <= 0;
		mult_tmp[70] <= 0;
		mult_tmp[71] <= 0;
		mult_tmp[72] <= 0;
		mult_tmp[73] <= 0;
		mult_tmp[74] <= 0;
		mult_tmp[75] <= 0;
		mult_tmp[76] <= 0;
		mult_tmp[77] <= 0;
		mult_tmp[78] <= 0;
		mult_tmp[79] <= 0;
		mult_tmp[80] <= 0;
		
//		for(j=0;j<num_mult;j=j+1)
//			mult_tmp[j] <= 0;
	end
	else
	begin	//!!根据卷积核大小详细修改
		mult_tmp[8]  <= shift_reg[0];
		mult_tmp[17] <= shift_reg[96];
		mult_tmp[26] <= shift_reg[192];
		mult_tmp[35] <= shift_reg[288];
		mult_tmp[44] <= shift_reg[384];
		mult_tmp[53] <= shift_reg[480];
		mult_tmp[62] <= shift_reg[576];
		mult_tmp[71] <= shift_reg[672];
		mult_tmp[80] <= shift_reg[768];
		for(j=0;j<kernel_size-1;j=j+1)
		begin
			mult_tmp[j]    <= mult_tmp[j+1];
			mult_tmp[j+9]  <= mult_tmp[j+9+1];
			mult_tmp[j+18] <= mult_tmp[j+18+1];
			mult_tmp[j+27] <= mult_tmp[j+27+1];
			mult_tmp[j+36] <= mult_tmp[j+36+1];
			mult_tmp[j+45] <= mult_tmp[j+45+1];
			mult_tmp[j+54] <= mult_tmp[j+54+1];
			mult_tmp[j+63] <= mult_tmp[j+63+1];
			mult_tmp[j+72] <= mult_tmp[j+72+1];
		end
	end
end

//按行顺序初始化卷积核参数
assign k1[0]  = 16'd355;
assign k1[1]  = 16'd664;
assign k1[2]  = 16'd966;
assign k1[3]  = 16'd471;
assign k1[4]  = 16'd375;
assign k1[5]  = 16'd608;
assign k1[6]  = 16'd289;
assign k1[7]  = 16'd347;
assign k1[8]  = 16'd65146;
assign k1[9]  = 16'd614;
assign k1[10] = 16'd237;
assign k1[11] = 16'd781;
assign k1[12] = 16'd167;
assign k1[13] = 16'd423;
assign k1[14] = 16'd349;
assign k1[15] = 16'd65532;
assign k1[16] = 16'd65414;
assign k1[17] = 16'd65261;
assign k1[18] = 16'd951;
assign k1[19] = 16'd550;
assign k1[20] = 16'd614;
assign k1[21] = 16'd353;
assign k1[22] = 16'd397;
assign k1[23] = 16'd446;
assign k1[24] = 16'd402;
assign k1[25] = 16'd65465;
assign k1[26] = 16'd65373;
assign k1[27] = 16'd885;
assign k1[28] = 16'd363;
assign k1[29] = 16'd458;
assign k1[30] = 16'd269;
assign k1[31] = 16'd498;
assign k1[32] = 16'd335;
assign k1[33] = 16'd334;
assign k1[34] = 16'd321;
assign k1[35] = 16'd65153;
assign k1[36] = 16'd617;
assign k1[37] = 16'd120;
assign k1[38] = 16'd177;
assign k1[39] = 16'd225;
assign k1[40] = 16'd575;
assign k1[41] = 16'd584;
assign k1[42] = 16'd359;
assign k1[43] = 16'd42 ;
assign k1[44] = 16'd316;
assign k1[45] = 16'd115;
assign k1[46] = 16'd280;
assign k1[47] = 16'd279;
assign k1[48] = 16'd439;
assign k1[49] = 16'd404;
assign k1[50] = 16'd917;
assign k1[51] = 16'd914;
assign k1[52] = 16'd338;
assign k1[53] = 16'd894;
assign k1[54] = 16'd65451;
assign k1[55] = 16'd39;
assign k1[56] = 16'd166;
assign k1[57] = 16'd335;
assign k1[58] = 16'd647;
assign k1[59] = 16'd662;
assign k1[60] = 16'd754;
assign k1[61] = 16'd571;
assign k1[62] = 16'd710;
assign k1[63] = 16'd65197;
assign k1[64] = 16'd65204;
assign k1[65] = 16'd155;
assign k1[66] = 16'd564;
assign k1[67] = 16'd858;
assign k1[68] = 16'd641;
assign k1[69] = 16'd1075;
assign k1[70] = 16'd1020;
assign k1[71] = 16'd1002;
assign k1[72] = 16'd64642;
assign k1[73] = 16'd64742;
assign k1[74] = 16'd65533;
assign k1[75] = 16'd381;
assign k1[76] = 16'd719;
assign k1[77] = 16'd876;
assign k1[78] = 16'd814;
assign k1[79] = 16'd1013;
assign k1[80] = 16'd1165;

genvar k;
generate
	for (k = 0 ; k < num_mult ; k = k + 1)
	begin	: g1
		mult_16 m1 (.clk(clk_in),.a(k1[k]),.b(mult_tmp[k]),.ce(start),.p(mult[k]));
	end
endgenerate

always @ (posedge clk_in)
begin
	if(rst_n)
	begin
		adder_1 <= 0;
		adder_2 <= 0;
		adder_3 <= 0;
		adder_4 <= 0;
		adder_5 <= 0;
		adder_6 <= 0;
		adder_7 <= 0;
		adder_8 <= 0;
		adder_9 <= 0;
		adder_10 <= 0;
		map_out <= 0;
		save <= 0;
	end
	else
	begin
		if(start)
		begin	//!!根据卷积核大小详细修改
			adder_1 <= mult[0] +mult[1] +mult[2] +mult[3] +mult[4] +mult[5] +mult[6] +mult[7] +mult[8];
			adder_2 <= mult[9] +mult[10]+mult[11]+mult[12]+mult[13]+mult[14]+mult[15]+mult[16]+mult[17];
			adder_3 <= mult[18]+mult[19]+mult[20]+mult[21]+mult[22]+mult[23]+mult[24]+mult[25]+mult[26];
			adder_4 <= mult[27]+mult[28]+mult[29]+mult[30]+mult[31]+mult[32]+mult[33]+mult[34]+mult[35];
			adder_5 <= mult[36]+mult[37]+mult[38]+mult[39]+mult[40]+mult[41]+mult[42]+mult[43]+mult[44];
			adder_6 <= mult[45]+mult[46]+mult[47]+mult[48]+mult[49]+mult[50]+mult[51]+mult[52]+mult[53];
			adder_7 <= mult[54]+mult[55]+mult[56]+mult[57]+mult[58]+mult[59]+mult[60]+mult[61]+mult[62];
			adder_8 <= mult[63]+mult[64]+mult[65]+mult[66]+mult[67]+mult[68]+mult[69]+mult[70]+mult[71];
			adder_9 <= mult[72]+mult[73]+mult[74]+mult[75]+mult[76]+mult[77]+mult[78]+mult[79]+mult[80];
		
			adder_10 <= adder_1 + adder_2 + adder_3 + adder_4 + adder_5 + adder_6 + adder_7 + adder_8 + adder_9;
			
			if (adder_10[11])	//用右移代替除法，注意四舍五入
				map_out <= (adder_10 >> 12) + 1 + 16'd59748;
			else
				map_out <= (adder_10 >> 12) + 16'd59748;
//			map_out <= ((adder_10 + 1) >> 12) + 16'd64037;
			
			if(res_cnt>=5 && res_cnt<=92)	//5、6、7是有用结果
				save <= 1;
			else 
				save <= 0;
		end
		else
		begin
			adder_1 <= 0;
			adder_2 <= 0;
			adder_3 <= 0;
			adder_4 <= 0;
			adder_5 <= 0;
			adder_6 <= 0;
			adder_7 <= 0;
			adder_8 <= 0;
			adder_9 <= 0;
			adder_10 <= 0;
			map_out <= 0;
			save <= 0;
		end
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
		out_cnt <= 0;
	else
	begin
		if(save)
		begin
			if(out_cnt == num_out)
				out_cnt <= num_out;
			else
				out_cnt <= out_cnt + 1;
		end
		else
			out_cnt <= out_cnt;		
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
		ready <= 1;
	else
	begin
		if(out_cnt == num_out)
			ready <= 0;
		else
			ready <= 1;
	end
end

endmodule
