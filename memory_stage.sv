`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:55:23 PM
// Design Name: 
// Module Name: memory_stage
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

module memory_stage(
    input  logic clk,
    input  logic rst_n,
    input  logic [31:0] mem_address,
    input  logic [31:0] data_wr,
    output logic [31:0] mem_data,
    //controller signals
    input  logic wr_en
);

  //local signals

  //data memory
  logic [31:0] data_memory [128:0];

  //asynchrounous read
  assign mem_data = !wr_en ? data_memory[mem_address] : 32'h00000000;

  //synchronous write
  always_ff @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
    for (int i=0; i<129; i++)
        data_memory [i] <= 5;
    end else begin
        if (wr_en)
            data_memory[mem_address] <= data_wr; 
    end
    
  end

endmodule