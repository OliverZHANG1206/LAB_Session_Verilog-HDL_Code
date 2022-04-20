`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:02:41 03/22/2022 
// Design Name: 
// Module Name:    Seven_Seg 
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
module Seven_seg(
    input [3:0] data,
	 input ctrl,
	 output [6:0] out);
	 
	 assign out[0] = ctrl | (~data[3] & ~data[2] & ~data[1] & data[0] | data[2] & ~data[1] & ~data[0] | data[3] & data[1] | data[3] & data[2]);
	 assign out[1] = ctrl | (data[2] & ~data[1] & data[0] | data[2] & data[1] & ~data[0]);
	 assign out[2] = ctrl | (~data[2] & data[1] & ~data[0]);
	 assign out[3] = ctrl | (~data[3] & ~data[2] & ~data[1] & data[0] | data[2] & ~data[1] & ~data[0] | data[2] & data[1] & data[0]);
	 assign out[4] = ctrl | (data[0] | data[2] & ~data[1]);
	 assign out[5] = ctrl | (~data[3] & ~data[2] & data[0] | ~data[2] & data[1] | data[1] & data[0]);
	 assign out[6] = ctrl | (~data[3] & ~data[2] & ~data[1] | data[2] & data[1] & data[0]);
	 // assign out[7] = 1'b1;

endmodule
