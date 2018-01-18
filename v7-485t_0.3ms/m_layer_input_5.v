`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:56 04/17/2017 
// Design Name: 
// Module Name:    m_layer_input_5 
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
module m_layer_input_5(
   clk_in,
	rst_n,
	map_in,
	wr,
	map_out,
	k_ready,
	ready
   );
	 
//##需要按实际情况修改参数	 
parameter num_in = 7'd119;	//map_in数目-1

input clk_in;
input rst_n;	//低复位
input signed [15:0] map_in;	
input wr;	//由于输入输出速度不同，需要缓存到ram中，此为写入信号
output signed [15:0] map_out;	//缓存后的输出 
output reg k_ready = 0;	//输出卷积核参数的启动信号
output reg ready = 1;	//作为下一级的低复位

//##需要按实际情况修改位宽
reg [6:0] addr_wr = 0;	//ram地址
reg [6:0] addr_rd = 0;	////ram的地址

reg k_ready_tmp = 0;
reg k_ready_tmp2 = 0;
reg k_ready_tmp3 = 0;

always @ (posedge clk_in)
begin
	if (~rst_n)
		addr_wr <= 0;
	else
	begin
		if (wr)
		begin
			if (addr_wr == num_in)
				addr_wr <= 0;
			else
				addr_wr <= addr_wr + 1;	
		end
		else
			addr_wr <= addr_wr;
	end
end

always @ (posedge clk_in)
begin
	if (~k_ready) 
		addr_rd <= 0;
	else 
	begin
		if (addr_rd == num_in)
			addr_rd <= num_in;
		else
			addr_rd <= addr_rd + 1;
	end
end

always @ (posedge clk_in)
begin
	k_ready_tmp <= ~rst_n;
	k_ready_tmp2 <= k_ready_tmp;
	k_ready_tmp3 <= k_ready_tmp2;
	k_ready <= k_ready_tmp3;
end

always @ (posedge clk_in)
begin
	if (rst_n) 
		ready <= 1;
	else
		ready <= ~k_ready;
end

m_conv_5_ram u1(.clka(clk_in),.ena(rst_n),.wea(wr),.addra(addr_wr),.dina(map_in),.clkb(clk_in),.enb(k_ready),.addrb(addr_rd),.doutb(map_out));

endmodule
