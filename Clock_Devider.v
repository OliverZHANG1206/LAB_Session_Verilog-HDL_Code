`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:13:01 03/17/2022 
// Design Name: 
// Module Name:    Clock_Devider 
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
module Clock_Devider(
	 input clk,
	 input reset,
	 output clk_div2_o,
	 output clk_div4_o,
	 output clk_div8_o);
	 
	 reg clk_div2;
	 reg clk_div4;
	 reg clk_div8;
	 
	 always @ (posedge clk or negedge reset)
	 begin
		  if (~reset)
		      clk_div2 <= 1'b0;
		  else 
		      clk_div2 <= ~clk_div2;
	 end
	 
	 always @ (posedge clk_div2 or negedge reset)
	 begin
	     if (~reset)
		      clk_div4 <= 1'b0;
		  else 
		      clk_div4 <= ~clk_div4;
	 end
	 
	 always @ (posedge clk_div4 or negedge reset)
	 begin
		  if (~reset)
		      clk_div8 <= 1'b0;
		  else 
		      clk_div8 <= ~clk_div8;
	 end
	 
	 assign clk_div2_o = clk_div2;
	 assign clk_div4_o = clk_div4;
	 assign clk_div8_o = clk_div8;
	 
endmodule
