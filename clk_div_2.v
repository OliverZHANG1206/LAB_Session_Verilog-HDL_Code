`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:57 03/17/2022 
// Design Name: 
// Module Name:    clk_div_2 
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
module clk_div_2(
    input clk,
	 input reset,
	 output reg clk_div2);
	 
	 initial
	 begin
	     clk_div2 <= 0;
	 end
	 
    always @ (posedge clk or negedge reset)
	 begin
		  if (~reset)
		      clk_div2 <= 1'b0;
		  else 
		      clk_div2 <= ~clk_div2;
	 end

endmodule
