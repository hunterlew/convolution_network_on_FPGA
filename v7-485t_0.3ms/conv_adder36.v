`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:34:22 04/10/2017 
// Design Name: 
// Module Name:    conv_adder36 
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
module conv_adder36(
   clk_in,
	rst_n,
	a1,	a2,	a3,	a4,	a5,	a6,	a7,	a8,	a9,
	a10,	a11,	a12,	a13,	a14,	a15,	a16,	a17,	a18,
	a19,	a20,	a21,	a22,	a23,	a24,	a25,	a26,	a27,
	a28,	a29,	a30,	a31,	a32,	a33,	a34,	a35,	a36,
	b_ind,
	last_ready,
	add_out,
	ready
   );
	
parameter num_kernel = 1'd0;	//每个核参数数目-1	
parameter num_out = 7'd120;	//输出map数目

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
input signed [15:0] a19;
input signed [15:0] a20;
input signed [15:0] a21;
input signed [15:0] a22;
input signed [15:0] a23;
input signed [15:0] a24;
input signed [15:0] a25;
input signed [15:0] a26;
input signed [15:0] a27;
input signed [15:0] a28;
input signed [15:0] a29;
input signed [15:0] a30;
input signed [15:0] a31;
input signed [15:0] a32;
input signed [15:0] a33;
input signed [15:0] a34;
input signed [15:0] a35;
input signed [15:0] a36;

input [6:0] b_ind;
input last_ready;
output reg signed [15:0] add_out = 0;
output reg ready = 1;

//流水线缓冲器
reg signed [20:0] tmp1 = 0;
reg signed [20:0] tmp2 = 0;
reg signed [20:0] tmp3 = 0;
reg signed [20:0] tmp4 = 0;
reg signed [20:0] tmp5 = 0;
reg signed [20:0] tmp6 = 0;
reg signed [25:0] add_out_tmp = 0;

reg signed [15:0] b_in = 0;

reg ready_tmp = 1;
reg ready_tmp2 = 1;

always @ (posedge clk_in)
begin
	if (rst_n)
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
		tmp1 <= a1 + a2 + a3 + a4 + a5 + a6;
		tmp2 <= a7 + a8 + a9 + a10 + a11 + a12;
		tmp3 <= a13 + a14 + a15 + a16 + a17 + a18;
		tmp4 <= a19 + a20 + a21 + a22 + a23 + a24;
		tmp5 <= a25 + a26 + a27 + a28 + a29 + a30;
		tmp6 <= a31 + a32 + a33 + a34 + a35 + a36;
		
		add_out_tmp <= tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + b_in;
		
		if (add_out_tmp < 0)	//后面没有池化了，只能在这算激活
			add_out <= 0;
		else if (add_out_tmp >= 26'sd32767)
			add_out <= 16'sd32767;
		else
			add_out <= add_out_tmp[15:0];
	end
end

always @ (posedge clk_in)
begin
	if (rst_n) 
		b_in <= 0;
	else 
	begin
		case (b_ind)
			0:	b_in <= 352;
			1: 	b_in <= 19;
			2:	b_in <= 65512;
			3:	b_in <= 181;
			4:	b_in <= 65519;
			5: 	b_in <= 444;
			6: 	b_in <= 65514;
			7: 	b_in <= 65517;
			8: 	b_in <= 65022;
			9: 	b_in <= 44;
			10:	b_in <= 65451;
			11:	b_in <= 388;
			12:	b_in <= 65404;
			13:	b_in <= 65510;
			14:	b_in <= 65062;
			15:	b_in <= 19;
			16:	b_in <= 65527;
			17:	b_in <= 65441;
			18:	b_in <= 184;
			19: b_in <= 70;
			20:	b_in <= 345;
			21:	b_in <= 102;
			22:	b_in <= 347;
			23: b_in <= 29;
			24: b_in <= 65522;
			25: b_in <= 65415;
			26: b_in <= 8;
			27: b_in <= 207;
			28: b_in <= 65495;
			29: b_in <= 111;
			30: b_in <= 65523;
			31: b_in <= 85;
			32: b_in <= 65510;
			33: b_in <= 65495;
			34: b_in <= 65392;
			35: b_in <= 487;
			36:	b_in <= 65472;
			37: b_in <= 65339;
			38:	b_in <= 83;
			39:	b_in <= 35;
			40:	b_in <= 12;
			41: b_in <= 122;
			42: b_in <= 65346;
			43: b_in <= 65321;
			44: b_in <= 239;
			45: b_in <= 65469;
			46:	b_in <= 65509;
			47:	b_in <= 65;
			48:	b_in <= 9;
			49:	b_in <= 65492;
			50:	b_in <= 263;
			51:	b_in <= 165;
			52:	b_in <= 65521;
			53:	b_in <= 65471;
			54:	b_in <= 178;
			55: b_in <= 65134;
			56:	b_in <= 65471;
			57:	b_in <= 65209;
			58:	b_in <= 2;
			59: b_in <= 85;
			60: b_in <= 65120;
			61: b_in <= 27;
			62: b_in <= 189;
			63: b_in <= 31;
			64: b_in <= 65376;
			65: b_in <= 595;
			66: b_in <= 65244;
			67: b_in <= 65413;
			68: b_in <= 65318;
			69: b_in <= 65313;
			70: b_in <= 518;
			71: b_in <= 30;
			72:	b_in <= 361;
			73: b_in <= 65244;
			74:	b_in <= 43;
			75:	b_in <= 65495;
			76:	b_in <= 958;
			77: b_in <= 65450;
			78: b_in <= 77;
			79: b_in <= 507;
			80: b_in <= 65512;
			81: b_in <= 227;
			82:	b_in <= 65510;
			83:	b_in <= 65463;
			84:	b_in <= 65392;
			85:	b_in <= 68;
			86:	b_in <= 65128;
			87:	b_in <= 65115;
			88:	b_in <= 65454;
			89:	b_in <= 65522;
			90:	b_in <= 65526;
			91: b_in <= 65402;
			92:	b_in <= 65525;
			93:	b_in <= 594;
			94:	b_in <= 0;
			95: b_in <= 65420;
			96: b_in <= 35;
			97: b_in <= 65523;
			98: b_in <= 65092;
			99: b_in <= 46;
			100: b_in <= 65524;
			101: b_in <= 65382;
			102: b_in <= 238;
			103: b_in <= 65403;
			104: b_in <= 65529;
			105: b_in <= 136;
			106: b_in <= 65495;
			107: b_in <= 65001;
			108: b_in <= 65531;
			109: b_in <= 65526;
			110: b_in <= 22;
			111: b_in <= 635;
			112: b_in <= 47;
			113: b_in <= 65490;
			114: b_in <= 65292;
			115: b_in <= 173;
			116: b_in <= 57;
			117: b_in <= 213;
			118: b_in <= 36;
			119: b_in <= 495;
			default: b_in <= 0;
		endcase
	end
end

always @ (posedge clk_in)
begin
	ready_tmp <= last_ready;
	ready_tmp2 <= ready_tmp;
	ready <= ready_tmp2;	
end
	
endmodule
