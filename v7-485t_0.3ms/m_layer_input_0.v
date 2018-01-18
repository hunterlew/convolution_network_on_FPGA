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
module m_layer_input_0(
	clk_in,
	rst_n,
	map_out,
	start
    );

parameter nun_in = 14'd9215;
parameter len_shift = 10'd864;
parameter kernel_size = 4'd9;

input clk_in;
input rst_n;
output signed [15:0] map_out;
output reg start = 0;

reg [13:0] addr = 0;

always @ (posedge clk_in)
begin
	if(rst_n)
		addr <= 0;
	else
	begin
		if(addr == nun_in)
			addr <= addr;
		else
			addr <= addr + 1;
	end
end

always @ (posedge clk_in)
begin
	if(rst_n)
		start <= 0;
	else
	begin
		if(addr >= len_shift+kernel_size)	//≥ı ºªØ—”≥Ÿ
			start <= 1;
		else
			start <= 0;
	end
end

im_in u1 (.clka(clk_in),.ena(~rst_n),.addra(addr),.douta(map_out));

endmodule