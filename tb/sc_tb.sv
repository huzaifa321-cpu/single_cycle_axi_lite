`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 05:05:32 PM
// Design Name: 
// Module Name: sc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "single_cycle_defs.vh"

module sc_tb;
logic clk;
logic rst_n;

single_cycle sc (
    clk,
    rst_n
);

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
rst_n <= 1;

@ (posedge clk)
 rst_n <= 0;

@ (posedge clk)
 rst_n <= 1;
end


endmodule