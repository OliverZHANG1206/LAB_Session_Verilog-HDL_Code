`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:20 03/17/2022 
// Design Name: 
// Module Name:    Shifting_register 
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
module Shifting_register(
    input clk,
	 input reset,
	 output [7:0] LED);
	 
	 reg [7:0] shft_reg;
	 reg [16:0] counter;
	 wire clk_div;
	 
	 clk_div4 divider (clk, reset, clk_div);
	 
	 parameter time_interval = 17'd231423;
	 
	 always @ (posedge clk_div or negedge reset)
	 begin
	     if (~reset)
		  begin
		      counter <= 21'b0;
				shft_reg <= 8'b11111110;
		  end
		  else 
		  begin
	         if (counter == time_interval)
		      begin
		          if (shft_reg[7:0] == 8'b01111111)
				        shft_reg <= {shft_reg[6:0], 1'b0};
                else					 
		              shft_reg <= {shft_reg[6:0], 1'b1};
						  
					 counter <= 21'b0;
		      end
		      else
		          counter <= counter + 1'b1;
		  end
	 end

	 assign LED = shft_reg;

endmodule

module clk_div4 (
    input clk,
	 input reset,
	 output clk_div4);
	 
	 wire clk_div2;
	 
	 clk_div_2 div2 (clk, reset, clk_div2);
	 clk_div_2 div4 (clk_div2, reset, clk_div4);
	 
endmodule
