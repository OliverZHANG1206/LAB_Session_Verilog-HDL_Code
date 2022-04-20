`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:07:57 03/20/2022 
// Design Name: 
// Module Name:    Seven_segment 
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
module Seven_segment(
    input [3:0] data,
	 output [7:0] out);

    assign out[0] = ~data[3] & ~data[2] & ~data[1] & data[0] | data[2] & ~data[1] & ~data[0] | data[3] & data[1] | data[3] & data[2];
	 assign out[1] = data[2] & ~data[1] & data[0] | data[2] & data[1] & ~data[0];
	 assign out[2] = ~data[2] & data[1] & ~data[0];
	 assign out[3] = ~data[3] & ~data[2] & ~data[1] & data[0] | data[2] & ~data[1] & ~data[0] | data[2] & data[1] & data[0];
	 assign out[4] = data[0] | data[2] & ~data[1];
	 assign out[5] = ~data[3] & ~data[2] & data[0] | ~data[2] & data[1] | data[1] & data[0];
	 assign out[6] = ~data[3] & ~data[2] & ~data[1] | data[2] & data[1] & data[0];
	 assign out[7] = 1'b1;

endmodule
