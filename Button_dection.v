`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:30 03/20/2022 
// Design Name: 
// Module Name:    Button_dection 
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
module Button_dection(
    input clk,
	 input reset,
    input button,
	 output reg pressed);
	 
	 reg state;
	 reg [3:0] buff;
	 
	 always @ (posedge clk or negedge reset)
	 begin
	     if (~reset)
		  begin
				state <= 1'b0;
				pressed <= 1'b0;
		  end
		  else
		  begin
	         case (state)
		          1'b0:
					 begin
					     if (~button)
						      buff <= buff + 1'b1;
						  else
						      buff <= 4'b0;
						  
						  if (buff == 4'b1111)
						  begin
						      buff <= 4'b0;
								state <= 1'b1;
						  end
						  else
						      state <= 1'b0;
								
						  pressed <= 1'b0;
					 end
				    1'b1:
				    begin
				        if (button)
						      buff <= buff + 1'b1;
						  else
						      buff <= 4'b0;
						  
						  if (buff == 4'b1111)
						  begin
						      buff <= 4'b0;
								state <= 1'b0;
								pressed <= 1'b1;
						  end
						  else
						      state <= 1'b1;
				    end
	         endcase
	     end
	 end
endmodule
