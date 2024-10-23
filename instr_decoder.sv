`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:49:53 PM
// Design Name: 
// Module Name: instr_decoder
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

module instr_decoder(
    input  logic [31:0] instr,
    output type_opcode_e opcode,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,
    output logic [4:0]  rd,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [31:0] immediate
);

    assign opcode = type_opcode_e'(instr[6:0]);
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign rd     = instr[11:7];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];

    //immediate generator
    always_comb begin
        case (opcode)
            I_TYPE : begin
                        if ((funct3 == 3'b001) || (funct3 == 3'b101))  
                            immediate = {27'h0000000, instr[24:20]};
                        else
                            immediate = {{20{instr[31]}}, instr[31:20]};
                     end
            LOAD_I : immediate = {{20{instr[31]}}, instr[31:20]};
            S_TYPE : immediate = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            B_TYPE : immediate = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            JALR_I : immediate = {{20{instr[31]}}, instr[31:20]};
            J_TYPE : immediate = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            LUI_I  : immediate = {instr[31:12], 12'h000};
            AUIPC  : immediate = {instr[31:12], 12'h000};
            default: immediate = 32'h00000000;
        endcase
    end
    
endmodule