`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:29 03/20/2022 
// Design Name: 
// Module Name:    clk_div256 
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
module clk_div256(
    input clk,
	 input reset,
	 output clk_div256);
	 
	 wire clk_div2, clk_div4, clk_div8, clk_div16, clk_div32, clk_div64, clk_div128;
	 
	 clk_div_2 div2 (clk, reset, clk_div2);
	 clk_div_2 div4 (clk_div2, reset, clk_div4);
	 clk_div_2 div8 (clk_div4, reset, clk_div8);
	 clk_div_2 div16 (clk_div8, reset, clk_div16);
	 clk_div_2 div32 (clk_div16, reset, clk_div32);
	 clk_div_2 div64 (clk_div32, reset, clk_div64);
	 clk_div_2 div128 (clk_div64, reset, clk_div128);
	 clk_div_2 div256 (clk_div128, reset, clk_div256);
	 
endmodule
