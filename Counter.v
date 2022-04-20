`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:26 03/17/2022 
// Design Name: 
// Module Name:    Counter 
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
module Counter(
    input clk,
	 input reset,
	 output [6:0] LSB,
	 output [6:0] MSB);
	 
	 wire ctrl2;
	 wire ctrl1;
	 wire clk_div;
	 reg [7:0] data;
	 reg [13:0] counter;
	 
	 clk_div64 divider (clk, reset, clk_div);
	 
	 Seven_seg LSB_disp (data[3:0], ctrl2, LSB[6:0]);
	 Seven_seg MSB_disp (data[7:4], ctrl1, MSB[6:0]);

	 always @ (posedge clk_div or negedge reset)
	 begin
	     if (~reset)
		  begin
		      data <= 8'b0;
				counter <= 21'b0;
		  end
		  else
		  begin
	         if (counter == 14'b11111111111111)  //21'b111000001111111111111
		      begin
					 if (data[7:0] == 8'b10011001)
					 begin
				        data[7:0] <= 8'b0;
					 end
				    else 
					 begin
		              if (data[3:0] == 4'b1001)
					     begin
			               data[3:0] <= 4'b0;
					         data[7:4] <= data[7:4] + 1'b1;
					     end
				        else
				            data[3:0] <= data[3:0] + 1'b1;
				    end
				    counter <= 21'b0;
		      end
		      else
		          counter <= counter + 1'b1;
	     end
	 end
	 
	 assign ctrl1 = ~(data[7] | data[6] | data[5] | data[4]);
	 assign ctrl2 = ~(~ctrl1 | data[3] | data[2] | data[1] | data[0]);
	 
endmodule

module clk_div64(
    input clk,
	 input reset,
	 output clk_div64);
	 
	 wire clk_div2;
	 wire clk_div4;
	 wire clk_div8;
	 wire clk_div16;
	 wire clk_div32;
	 
	 clk_div_2 div2  (clk, reset, clk_div2);
	 clk_div_2 div4  (clk_div2, reset, clk_div4);
	 clk_div_2 div8  (clk_div4, reset, clk_div8);
	 clk_div_2 div16 (clk_div8, reset, clk_div16);
	 clk_div_2 div32 (clk_div16, reset, clk_div32);
	 clk_div_2 div64 (clk_div32, reset, clk_div64);
	 
endmodule
