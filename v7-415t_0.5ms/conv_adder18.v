`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:51:45 02/26/2017 
// Design Name: 
// Module Name:    conv_adder18 
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
module conv_adder18(
   clk_in,
	rst_n,
	a1,	a2,	a3,	a4,	a5,	a6,	a7,	a8,	a9,
	a10,	a11,	a12,	a13,	a14,	a15,	a16,	a17,	a18,
	b_ind,
	last_ready,
	add_out,
	wr,
	ready
   );
	
parameter num_kernel = 5'd24;	//每个核参数数目-1
parameter num_out = 9'd324;	//输出map数目

input clk_in;
input rst_n;
input signed [15:0] a1;
input signed [15:0] a2;
input signed [15:0] a3;
input signed [15:0] a4;
input signed [15:0] a5;
input signed [15:0] a6;
input signed [15:0] a7;
input signed [15:0] a8;
input signed [15:0] a9;
input signed [15:0] a10;
input signed [15:0] a11;
input signed [15:0] a12;
input signed [15:0] a13;
input signed [15:0] a14;
input signed [15:0] a15;
input signed [15:0] a16;
input signed [15:0] a17;
input signed [15:0] a18;
input [5:0] b_ind;
input last_ready;	//卷积相乘结束，延迟流水线周期则本模块结束
output reg signed [15:0] add_out = 0;
output reg wr = 0;
output reg ready = 1;

//流水线缓冲器
reg signed [17:0] tmp1 = 0;
reg signed [17:0] tmp2 = 0;
reg signed [17:0] tmp3 = 0;
reg signed [17:0] tmp4 = 0;
reg signed [17:0] tmp5 = 0;
reg signed [17:0] tmp6 = 0;
reg signed [21:0] add_out_tmp = 0;

reg signed [15:0] b_in = 0;

reg [4:0] delay = 0;
reg delay_rst = 1;
reg [2:0] delay_cnt = 0;
reg ready_tmp = 1;
reg ready_tmp1 = 1;


//延时，由于卷积乘法需要3个周期，再加上本模块由于流水线需要3个周期，再加上自身，共需要延迟了7个周期
//延时复位后，每经过参数数量个周期后，出来一个加法结果
always @ (posedge clk_in)
begin
	if (rst_n)
	begin
		delay_cnt <= 0;
		delay_rst <= delay_rst;
	end
	else
	begin		
		if (delay_cnt == 7)
		begin
			delay_cnt <= 7;
			delay_rst <= rst_n;
		end
		else
		begin
			delay_cnt <= delay_cnt + 1;
			delay_rst <= delay_rst;
		end
	end
end

always @ (posedge clk_in)
begin
	if (delay_rst)
	begin
		add_out_tmp <= 0;
		add_out <= 0;
		tmp1 <= 0;
		tmp2 <= 0;
		tmp3 <= 0;
		tmp4 <= 0;
		tmp5 <= 0;
		tmp6 <= 0;

	end
	else
	begin
		tmp1 <= a1 + a2 + a3;
		tmp2 <= a4 + a5 + a6;
		tmp3 <= a7 + a8 + a9;
		tmp4 <= a10 + a11 + a12;
		tmp5 <= a13 + a14 + a15;
		tmp6 <= a16 + a17 + a18;	
		
		add_out_tmp <= tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + b_in;
		
		if (add_out_tmp <= -22'sd32768)
			add_out <= -16'sd32768;
		else if (add_out_tmp >= 22'sd32767)
			add_out <= 16'sd32767;
		else
			add_out <= add_out_tmp[15:0];
	end
end

always @ (posedge clk_in)
begin
	if (delay_rst) 
		b_in <= 0;
	else 
	begin
		case (b_ind)
			0:	b_in <= 991;
			1: 	b_in <= 63819;
			2:	b_in <= 64743;
			3:	b_in <= 64790;
			4:	b_in <= 63266;
			5: 	b_in <= 62229;
			6: 	b_in <= 64976;
			7: 	b_in <= 64225;
			8: 	b_in <= 51;
			9: 	b_in <= 2369;
			10:	b_in <= 367;
			11:	b_in <= 64368;
			12:	b_in <= 136;
			13:	b_in <= 64819;
			14:	b_in <= 250;
			15:	b_in <= 236;
			16:	b_in <= 16;
			17:	b_in <= 1365;
			18:	b_in <= 65052;
			19: b_in <= 64769;
			20:	b_in <= 60880;
			21:	b_in <= 63707;
			22:	b_in <= 397;
			23: b_in <= 218;
			24: b_in <= 64900;
			25: b_in <= 954;
			26: b_in <= 1419;
			27: b_in <= 380;
			28: b_in <= 64410;
			29: b_in <= 65306;
			30: b_in <= 62728;
			31: b_in <= 1419;
			32: b_in <= 64866;
			33: b_in <= 64125;
			34: b_in <= 8;
			35: b_in <= 64903;
			default: b_in <= 0;
		endcase
	end
end

always @ (posedge clk_in)
begin
	if (delay_rst)
	begin
		delay <= 0;	
		wr <= 0;
	end
	else
	begin
		if (delay == num_kernel)	
		begin
			delay <= 0;
			wr <= 1;
		end
		else
		begin
			delay <= delay + 1;
			wr <= 0;
		end
	end
end

always @ (posedge clk_in)
begin
	ready_tmp <= last_ready;
	ready_tmp1 <= ready_tmp;
	ready <= ready_tmp1;	
end	
	
endmodule
