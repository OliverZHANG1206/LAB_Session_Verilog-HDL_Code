`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:35:50 03/17/2022 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
    input clk,
	 input reset,
    input [1:0] button,
	 output reg [7:0] LED);
	 
	 parameter time_interval = 13'd7199;
	 parameter NONE  = 8'b11111111;
	 parameter ZERO  = 8'b00000011;
	 parameter ONE   = 8'b10011111;
	 parameter TWO   = 8'b00100101;
	 parameter THREE = 8'b00001101;
	 parameter FOUR  = 8'b10011001;
	 parameter CORRECT = 8'b00000000;
	 parameter INCORRECT = 8'b10010001;
	 
	 parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4, ST = 3'd5, SF = 3'd6;
	 
	 wire clk_div;
	 wire [1:0] pressed;
	 
	 reg fin;
	 reg [2:0] state;
	 reg [16:0] counter;

    clk_div256 divider (clk, reset, clk_div);
	 Button_dection buttonA (clk_div, reset, button[0], pressed[0]);
	 Button_dection buttonB (clk_div, reset, button[1], pressed[1]);
	 
	 always @ (posedge clk_div or negedge reset)
	 begin
	     if (~reset)
		      state <= 3'b000;
		  else
		  begin
		      case (state)
				    S0:
					     case (pressed)
						      2'b01: state <= SF;
								2'b10: state <= S1;
								default: state <= S0;
						  endcase
				    S1:
					     case (pressed)
						      2'b01: state <= S2;
								2'b10: state <= SF;
								default: state <= S1;
						  endcase  
					 S2:
					     case (pressed)
						      2'b01: state <= S3;
								2'b10: state <= SF;
								default: state <= S2;
						  endcase  
					 S3:
					     case (pressed)
						      2'b01: state <= SF;
								2'b10: state <= S4;
								default: state <= S3;
						  endcase  
					 S4:
					     case (pressed)
						      2'b01: state <= ST;
								2'b10: state <= SF;
								default: state <= S4;
						  endcase  
					 ST:
					     state <= (fin) ? S0 : ST;
                SF:						  
					     state <= (fin) ? S0 : SF;
					 default:
					     state <= S0;
				endcase
		  end
	 end
	 
	 always @ (posedge clk_div or negedge reset)
	 begin
	     if (~reset)
		  begin
		      LED <= ZERO;
		  end
		  else
		  begin
		      case (state)
				    S0: 
					 begin
					     LED <= ZERO;
						  fin <= 1'b0;
					 end
					 S1: LED <= ONE;
					 S2: LED <= TWO;
					 S3: LED <= THREE;
					 S4: LED <= FOUR;
					 ST: 
					 begin
					     if (counter == time_interval)
						  begin
							   fin <= 1'b1;
								counter <= 17'b0;
						  end
						  else
						  begin
						      LED <= CORRECT;
						      counter <= counter + 1'b1;
						  end
					 end
					 SF:
					 begin
					     if (counter == time_interval)
						  begin
							   fin <= 1'b1;
								counter <= 17'b0;
						  end
						  else
						  begin
						      LED <= INCORRECT;
						      counter <= counter + 1'b1;
						  end
					 end
					 default: LED <= NONE;
				endcase
		  end
	 end
	 
endmodule
/*
module button_dect(
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

module clk_div128(
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
*/