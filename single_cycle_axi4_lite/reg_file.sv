`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:57:01 PM
// Design Name: 
// Module Name: reg_file
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

module reg_file (
    input  logic clk,
    input  logic rst_n,
    input  logic wr_en,
    input  logic [4:0] addr_rs1,
    input  logic [4:0] addr_rs2,
    input  logic [4:0] addr_rd,
    input  logic [31:0] data_rd,
    output logic [31:0] data_rs1,
    output logic [31:0] data_rs2
);

    logic [31:0] regs [31:0];

    //asychronous read
    always_comb begin
        if (!wr_en) begin
            data_rs1 = (addr_rs1 == 5'h00) ? 32'h00000000 : regs [addr_rs1];
            data_rs2 = (addr_rs2 == 5'h00) ? 32'h00000000 : regs [addr_rs2];
        end
        else begin
            data_rs1 = 32'h00000000;
            data_rs2 = 32'h00000000;
        end
    end

    //writeback
    always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i=0; i<32; ++i) begin
                regs [i] <= 32'h00000000;
            end
        end
        else begin
           if (wr_en && (addr_rd != 5'h00))
               regs [addr_rd] <= data_rd; 
        end
        
    end

endmodule