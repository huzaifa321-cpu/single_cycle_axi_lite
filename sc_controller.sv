`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:58:22 PM
// Design Name: 
// Module Name: sc_controller
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

module sc_controller(
    input  wire type_opcode_e opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic reg_wr_en,
    output logic mux_a_sel,
    output logic mux_b_sel,
    output logic mem_wr_en,
    output logic mem_rd_en,
    output logic stall,
    output logic [1:0] wrb_mux_sel,
    output type_alu_op_e alu_op,
    //output logic [1:0] mem_rd_type,
    //output logic [1:0] mem_wr_type,
    output type_branch_cond_e br_type
);

  //mux selections and write enables
  always_comb begin
    case (opcode)
        R_TYPE: begin 
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b0;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00;
        end
        I_TYPE: begin 
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00;
        end
        LOAD_I: begin 
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b1;
            stall       = 1'b1;
            wrb_mux_sel = 2'b01;
        end
        S_TYPE: begin 
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b0;
            mem_wr_en   = 1'b1;
            mem_rd_en   = 1'b0;
            stall       = 1'b1;
            wrb_mux_sel = 2'b00; //don't care
        end
        B_TYPE: begin 
            mux_a_sel   = 1'b1;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00; //don't care
        end
        JALR_I: begin 
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b10;
        end
        J_TYPE: begin 
            mux_a_sel   = 1'b1;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b10;
        end
        LUI_I : begin 
            mux_a_sel   = 1'b0; //don't care
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00;
        end
        AUIPC : begin 
            mux_a_sel   = 1'b1;
            mux_b_sel   = 1'b1;
            reg_wr_en   = 1'b1;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00;
        end
        default: begin
            mux_a_sel   = 1'b0;
            mux_b_sel   = 1'b0;
            reg_wr_en   = 1'b0;
            mem_wr_en   = 1'b0;
            mem_rd_en   = 1'b0;
            stall       = 1'b0;
            wrb_mux_sel = 2'b00;
        end
    endcase
  end

  //alu operation select
  always_comb begin
    if (opcode == (R_TYPE || I_TYPE)) begin
        case (funct3)
            3'b000: begin if ((opcode == R_TYPE) && (funct7 == 8'h20)) alu_op = SUB;
                          else alu_op = ADD;
                    end
            3'b001: alu_op = SLL;
            3'b010: alu_op = SLT;
            3'b011: alu_op = SLTU;
            3'b100: alu_op = XOR;
            3'b101: begin if (funct7 == 8'h20) alu_op = SRA;
                          else alu_op = SRL;
                    end
            3'b110: alu_op = OR;
            3'b111: alu_op = AND;
            default: alu_op = ADD;
        endcase
    end 
    else if (opcode == LUI_I)
            alu_op = LUI;
    else
        alu_op = ADD;
  end

  // branch type selection  
  always_comb begin
    if (opcode == (B_TYPE)) begin
        case (funct3)
            3'b000: br_type = BEQ;
            3'b001: br_type = BNE;
            3'b100: br_type = BLT;
            3'b101: br_type = BGE;
            3'b110: br_type = BLTU;
            3'b111: br_type = BGEU;
            default: br_type = NO_BR;
        endcase
    end 
    else if ((opcode == J_TYPE) || (opcode == JALR_I))
        br_type = JUMP;
    else
        br_type = NO_BR;
  end

  // memory read write type
endmodule