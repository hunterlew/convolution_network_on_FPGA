`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:57:25 02/25/2017 
// Design Name: 
// Module Name:    m_layer_input_1 
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
module m_layer_input_1(
   clk_in,
	rst_n,
	map_in,
	wr,	
	map_out,
	ready	
   );
	 
//##需要按实际情况修改参数	 
parameter num_ind = 7'd87;	//索引数目大小-1，通过遍历第一行，得到索引地址
parameter max_ind = 9'd351;	//索引最大数，用于判断控制逻辑
parameter size_in = 7'd88;	//map_in大小
parameter num_in = 13'd7743;	//map_in数目-1
parameter size_kernel = 2'd3;	//卷积核或池化核的边长大小-1,也决定了分频系数
parameter size_out = 5'd21;	//map_out大小-1

//##需要输出核参数
//parameter num_kernel = 7'd80;	//每个核参数数目-1

input clk_in;
input rst_n;	//低复位
input signed [15:0] map_in;	//第1层：卷积后输入，以一定的顺序，需要缓存 
input wr;	//由于输入输出速度不同，需要缓存到ram中，此为写入信号
output signed [15:0] map_out;	//缓存后的输出 
output reg ready = 1;	//作为下一级的低复位


//##需要按实际情况修改位宽
reg [12:0] addr_wr = 0;	//ram地址
reg [6:0] addr_ind = 0;	//一定顺序的索引的地址
wire [8:0] ind_out;	//索引输出
reg [8:0] ind_out_tmp = 0;	//索引缓存，做加法后的结果
reg [1:0] ind_cnt = 0;	//索引做加法的计数器
reg [13:0] ind_out_tmp2 = 0;	//索引缓存，加偏置后的结果
reg [4:0] ind_cnt2 = 0;	//索引做乘法的计数器
wire [13:0] bias;	//需要偏置的距离
reg [13:0] addr_rd = 0;	//ram的地址

reg ind_ready = 0;	//表示无延迟条件下，map_out和k可以开始输出
reg ind_ready_tmp = 0;	//乘法核理想的输出需要延迟。作为ind_ready的延迟
reg ind_ready_tmp2 = 0;
reg ind_ready_tmp3 = 0;

reg [8:0] mult_tmp = 0;	//乘法核理想的输出需要延迟，地址运算的缓冲
reg [8:0] mult_tmp2 = 0;
reg [8:0] mult_tmp3 = 0;
wire clk_in_div_slow;	//慢时钟，倍数取决于卷积核或池化间隔的大小

always @ (posedge clk_in)
begin
	if (~rst_n)
	begin
		addr_wr <= 0;
	end
	else
	begin
		if (wr)
			addr_wr <= addr_wr + 1;	
		else
			addr_wr <= addr_wr;
	end
end

always @ (posedge clk_in_div_slow)	
begin
	if (rst_n) 
		addr_ind <= 0;
	else 
	begin
		if (addr_ind == num_ind)	
			addr_ind <= 0;
		else
			addr_ind <= addr_ind + 1;
	end
end

always @ (posedge clk_in)
begin
	if (rst_n) 
	begin
		ind_cnt <= 0;
		ind_out_tmp <= 0;
		mult_tmp <= 0;
		mult_tmp2 <= 0;
		mult_tmp3 <= 0;
		ind_out_tmp2 <= 0;
		addr_rd <= 0;
	end
	else 
	begin
		if (ind_cnt == size_kernel)
			ind_cnt <= 0;
		else 
			ind_cnt <= ind_cnt + 1;
		ind_out_tmp <= ind_out + ind_cnt;
		mult_tmp <= ind_out_tmp;
		mult_tmp2 <= mult_tmp;
		mult_tmp3 <= mult_tmp2;
		ind_out_tmp2 <= mult_tmp3 + bias;
		addr_rd <= ind_out_tmp2;
	end
end

always @ (posedge clk_in)
begin
	if (rst_n) 
		ind_cnt2 <= 0;
	else 
	begin
		if (ind_out_tmp == max_ind)
		begin	
			if (ind_cnt2 >= size_out)	//需要偏置的次数
				//##设置一个相同位宽下的最大数，表示结束
				ind_cnt2 <= 31;
			else
				ind_cnt2 <= ind_cnt2 + 1;
		end
		else
			ind_cnt2 <= ind_cnt2;
	end
end

always @ (posedge clk_in)
begin
	if (rst_n) 
	begin
		ind_ready <= 0;
		ind_ready_tmp <= 0;
		ind_ready_tmp2 <= 0;
		ind_ready_tmp3 <= 0;
		ready <= 1;
	end
	else
	begin
		if	(ind_out_tmp || ind_cnt2)
			ind_ready <= 1;	
		else
			ind_ready <= 0;
		ind_ready_tmp <= ind_ready;
		ind_ready_tmp2 <= ind_ready_tmp;
		if (ind_out_tmp2 > num_in)	//控制rom输出结束
			ind_ready_tmp3 <= 0;
		else
			ind_ready_tmp3 <= ind_ready_tmp2;	//控制rom输出开始
		ready <= ~ind_ready_tmp3;
	end
end
           
clk_div u1(.clk_in(clk_in),.rst_n(rst_n),.n(size_kernel+4'd1),.clk_out(clk_in_div_slow));

bias_mult2 u2(.clk(clk_in),.ce(~rst_n),.p(bias),.a(ind_cnt2));

ind_conv_in u3(.clka(clk_in),.ena(~rst_n),.addra(addr_ind),.douta(ind_out));

conv_ram u4(.clka(clk_in),.ena(rst_n),.wea(wr),.addra(addr_wr),.dina(map_in),.clkb(clk_in),.enb(ind_ready_tmp3),.addrb(addr_rd),.doutb(map_out));

endmodule
