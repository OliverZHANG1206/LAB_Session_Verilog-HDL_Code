`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:17 04/09/2022 
// Design Name: 
// Module Name:    UART 
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
module UART(
    input clk_org,            // Clock Input
	 input reset,              // Reset
	 input uart_rx,            // Receive
	 output [1:0] LED_ctrl,    // LED control
	 output [13:0] LED,        // LED display
	 output reg uart_tx,       // Transmit
	 output reg error_flag,    // Error flag when parity is wrong
	 output reg [1:0] enable); // Enable RS485
	 
	 // Testbench & Simulation
	 initial 
	 begin
	     uart_tx    <= 1'b1;
	     enable     <= 2'b0;
		  error_flag <= 1'b0;
	 end
	 
	 // Parameters settings
	 parameter clk_feq        = 1843200;                  // Osc freq
	 parameter baud_rate      = 57600;                    // Baud rate 
	 parameter bps_cnt        = clk_feq / baud_rate / 2;  // Number of count per bit
	 parameter data_num       = 9;                        // number of bits transmit per frame  
	 parameter parity_method  = 1;                        // 0: ODD, 1: EVEN 
	 parameter transmit_comm  = 1;                        // 0: Do not have transmission 1: Have transmission
	 parameter time_interval  = 5;                        // Time interval between receive and transmit  
	 
	 // Parameter State Machine
	 parameter state_idle  = 2'b00,  // IDLE:  idle states: no any receive
				  state_data  = 2'b01,  // DATA:  receiving data
				  state_stop  = 2'b10,  // STOP:  finish receiving and check parity
				  state_trans = 2'b11;  // TRANS: transmit back
				  
	 // Local Variable
	 wire clk;          // Clock div 2
	 wire check;        // parity check
	 reg [1:0] state;   // State
	 reg [3:0] counter; // Counter 
	 reg [4:0] bit_cnt; // Bit counter
	 reg [7:0] data;    // Successful received data
	 reg [8:0] rx_data; // Temp received data
	 
	 // Clock Config
	 clk_div_2 Devider (clk_org, reset, clk);
	 
	 // Parity Check Config
	 assign check = ^~{rx_data[7:0], parity_method};
	 
	 // LED Display
	 assign LED_ctrl[0] = ~(|data[7:4]);
	 assign LED_ctrl[1] = ~(|data[7:0]);
	 Seven_seg LSB (data[3:0], LED_ctrl[1], LED[6:0]);
	 Seven_seg MSB (data[7:4], LED_ctrl[0], LED[13:7]);
	 
	 // Update State Machine
	 always @(posedge clk or negedge reset)
	 begin
	     // RESET
	     if (~reset)
				state <= state_idle;
		  else
		  begin
		      case (state)
				
				    state_idle: 
					 begin
 						  if (counter == bps_cnt / 2 - 1)
						      state <= state_data;
						  else
						      state <= state;
					 end
					 
					 state_data:
					 begin
					     if (bit_cnt == data_num && counter == bps_cnt - 1)
						      state <= state_stop;
						  else 
						      state <= state;
					 end

					 state_stop:
					 begin
					     if (counter >= bps_cnt / 2 - 1 && uart_rx)
				            state <= (transmit_comm) ? state_trans : state_idle;
						  else
								state <= state;
					 end
					 
					 state_trans:
					 begin
					     if (bit_cnt == data_num + time_interval + 1 || error_flag)
						      state <= state_idle;
						  else
						      state <= state;
					 end
					 
					 default: state <= state_idle;
		      endcase
		  end
	 end
	 
	 // Actuator
	 always @ (posedge clk or negedge reset)
	 begin
	     // RESET
	     if (~reset)
		  begin
		      counter    <= 4'b0;
				data       <= 8'b0;
				bit_cnt    <= 5'b0;
				enable     <= 2'b0;
				uart_tx    <= 1'b1;
				error_flag <= 1'b0;
		  end
		  else
		  begin
		      case (state)
				
				    state_idle:
					 begin
						  bit_cnt <= 5'b0;
					     rx_data <= 9'b0;
						  enable  <= 2'b0;
						  uart_tx <= 1'b1;
						  if (~uart_rx)
						  begin
						      if (counter == bps_cnt / 2 - 1)
								    counter <= 5'b0;
						      else
								    counter <= counter + 1'b1;
                    end
						  else
						      counter <= 4'b0;
					 end
					 
				    state_data:
					 begin
					     if (counter == bps_cnt - 1 && bit_cnt < data_num)
						  begin
						      counter <= 4'b0;
								rx_data <= {uart_rx, rx_data[data_num - 1 : 1]};
								bit_cnt <= bit_cnt + 1'b1;
						  end
						  else
						      counter <= counter + 1'b1;
					 end
					 
					 state_stop:
					 begin
					     if (counter >= bps_cnt / 2 - 1 && uart_rx)
						  begin
						      if (rx_data[8] == check)
									 data <= rx_data[7:0];
								else
							   begin
									 data       <= data;
									 error_flag <= 1'b1;
								end
						      bit_cnt <= 5'b0;
						      counter <= 4'b0;
						  end
						  else
								counter <= counter + 1'b1;
					 end
					 
					 state_trans:
					 begin
					     if (bit_cnt == data_num + time_interval + 1 || error_flag)
					     begin
					         enable     <= 2'b0;
						      uart_tx    <= 1'b1;
						      bit_cnt    <= 5'b0;
								error_flag <= 1'b0;
					     end
				        else 
					     begin
						      enable <= 2'b11;
					         if (counter == bps_cnt - 1)
						      begin
								    bit_cnt <= bit_cnt + 1'b1;
								    counter <= 4'b0;
						      end
						      else
								    counter <= counter + 1'b1;
								
								if (bit_cnt < time_interval || bit_cnt == data_num + time_interval + 1)
								    uart_tx <= 1'b1;
								else
								begin
								    if (bit_cnt == time_interval)
									     uart_tx <= 1'b0;
									 else if (bit_cnt == data_num + time_interval)
									     uart_tx <= check;
									 else
									     uart_tx <= data[bit_cnt - time_interval - 1]; 
							   end
								
					     end
					 end
				endcase
		  end
	 end
	 
endmodule
