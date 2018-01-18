`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:38:01 03/01/2017 
// Design Name: 
// Module Name:    m_layer_input_4 
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
module m_layer_input_4(
   clk_in,
	rst_n,
	map_in,
	wr,
	map_out,
	k_loop,
	k_ready,
	ready
   );
	 
//##需要按实际情况修改参数	 
parameter num_in = 6'd35;	//map_in数目-1

parameter num_loop = 7'd119;	//需要循环的次数-1

input clk_in;
input rst_n;	//低复位
input signed [15:0] map_in;	//第1层：卷积后输入，以一定的顺序，需要缓存 
input wr;	//由于输入输出速度不同，需要缓存到ram中，此为写入信号
output signed [15:0] map_out;	//缓存后的输出 
output k_ready;	//输出卷积核参数的启动信号，相当于以前的ind_ready_tmp3
output reg ready = 1;	//作为下一级的低复位

output reg k_loop = 0;	//由于一次不能输出很多参数（资源受限），故分成几次循环。此为一次循环标志
reg [6:0] loop_cnt = 0;	//循环的次数计数
	
reg end_flag = 1;	// trick
reg end_flag_tmp = 1;	// trick


//##需要按实际情况修改位宽
reg [5:0] addr_wr = 0;	//ram地址

reg [2:0] ind_cnt = 0;	//索引做加法的计数器
reg [5:0] addr_rd = 0;	////ram的地址

always @ (posedge clk_in)
begin
	if (~rst_n)
	begin
		addr_wr <= 0;
	end
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
	if (rst_n) 
	begin
		addr_rd <= 0;
		loop_cnt <= 0;
		k_loop <= 0;
		end_flag <= 1;
	end
	else 
	begin
		if (addr_rd == 30)	//补偿等待卷积核，通过调试得到
		begin
			addr_rd <= addr_rd + 1;
			if (loop_cnt >= num_loop)
			begin
				loop_cnt <= num_loop + 1;
				k_loop <= 0;
			end 
			else
			begin
				loop_cnt <= loop_cnt + 1;
				k_loop <= 1;
			end
			end_flag <= 1;
		end
		else if (addr_rd == num_in)
		begin
//			addr_rd <= 0;
			loop_cnt <= loop_cnt;
			k_loop <= 0;
			if (loop_cnt > num_loop)
			begin
				addr_rd <= addr_rd;
				end_flag <= 0;
			end
			else
			begin
				addr_rd <= 0;
				end_flag <= 1;
			end
		end
		else
		begin
			addr_rd <= addr_rd + 1;
			loop_cnt <= loop_cnt;
			k_loop <= 0;
			end_flag <= 1;
		end
	end
end

assign k_ready = (~rst_n) && (end_flag_tmp);	//trick

always @ (posedge clk_in)
begin
	if (rst_n) 
	begin
		ready <= 1;
		end_flag_tmp <= 1;
	end
	else
	begin
		ready <= ~k_ready;
		end_flag_tmp <= end_flag;
	end
end

m_max_4_ram u1(.clka(clk_in),.ena(rst_n),.wea(wr),.addra(addr_wr),.dina(map_in),.clkb(clk_in),.enb(k_ready),.addrb(addr_rd),.doutb(map_out));

endmodule
