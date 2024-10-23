`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:43:05 PM
// Design Name: 
// Module Name: branch_cond
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

module branch_cond (
    input  logic [31:0] data_rs1,
    input  logic [31:0] data_rs2,
    input  wire type_branch_cond_e br_type,
    output logic br_taken
);


 //branch conditional check //jtype always true
  always_comb begin
    case (br_type)
      BEQ  : br_taken = (data_rs1 == data_rs2);
      BNE  : br_taken = (data_rs1 != data_rs2);
      BLT  : br_taken = ($signed(data_rs1) < $signed(data_rs2));
      BGE  : br_taken = ($signed(data_rs1) >= $signed(data_rs2));
      BLTU : br_taken = (data_rs1 < data_rs2);
      BGEU : br_taken = (data_rs1 >= data_rs2);
      JUMP : br_taken = 1'b1;
      NO_BR: br_taken = 1'b0;
      default: br_taken = 1'b0;
    endcase
  end

endmodule