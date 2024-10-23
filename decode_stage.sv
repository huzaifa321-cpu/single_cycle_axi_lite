`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:44:59 PM
// Design Name: 
// Module Name: decode_stage
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

module decode_stage(
    input  logic clk,
    input  logic rst_n,
    input  logic reg_wr_en,
    input  logic [31:0] instruction,
    output type_opcode_e opcode,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,
    input  logic [31:0] data_rd,
    output logic [31:0] data_rs1,
    output logic [31:0] data_rs2,
    output logic [31:0] imm
);
    
    logic [4:0] addr_rs1;
    logic [4:0] addr_rs2;
    logic [4:0] addr_rd;
    
    instr_decoder isr_dc(
    .instr (instruction) ,
    .opcode (opcode),
    .funct3 (funct3),
    .funct7 (funct7),
    .rd (addr_rd),
    .rs1 (addr_rs1),
    .rs2 (addr_rs2),
    .immediate (imm)
);
    
    reg_file rgf(
    .clk (clk),
    .rst_n (rst_n),
    .wr_en (reg_wr_en),
    .addr_rs1 (addr_rs1),
    .addr_rs2 (addr_rs2),
    .addr_rd (addr_rd),
    .data_rd (data_rd),
    .data_rs1 (data_rs1),
    .data_rs2 (data_rs2)
    );
endmodule