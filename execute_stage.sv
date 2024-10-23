`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:46:11 PM
// Design Name: 
// Module Name: execute_stage
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

module execute_stage(
    input  logic [31:0] data_rs1,
    input  logic [31:0] data_rs2,
    input  logic [31:0] immediate,
    input  logic [31:0] pc,
    output logic [31:0] alu_out,
    //control signals
    input  wire type_alu_op_e alu_op,
    input  logic mux_a_sel,
    input  logic mux_b_sel
);

  logic [31:0] operand_a, operand_b;

  //operand selection muxs
  assign operand_a = mux_a_sel ? pc : data_rs1;
  assign operand_b = mux_b_sel ? immediate : data_rs2;

  //ALU
  always_comb begin
    case (alu_op)
        ADD : alu_out = operand_a + operand_b; 
        SUB : alu_out = operand_a - operand_b; 
        SLL : alu_out = operand_a << operand_b; 
        SLT : alu_out = $signed(operand_a) < $signed(operand_b); 
        SLTU: alu_out = operand_a < operand_b; 
        XOR : alu_out = operand_a ^ operand_b; 
        SRL : alu_out = operand_a >> operand_b; 
        SRA : alu_out = $signed(operand_a) >>> $signed(operand_b);  
        OR  : alu_out = operand_a + operand_b; 
        AND : alu_out = operand_a + operand_b; 
        LUI : alu_out = operand_b;
        default: alu_out = 32'h00000000;
    endcase
  end
endmodule