`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 04:47:08 PM
// Design Name: 
// Module Name: fetch_stage
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

module fetch_stage(
    input  logic clk,
    input  logic rst_n,
    input  logic br_taken,
    input logic stall,
    input  logic [31:0] branch_address,
    output logic [31:0] pc,
    output logic [31:0] instr
);

    logic [31:0] pc_next;
    //intruction memory
    reg [7:0] instr_mem [511:0];

    /*initial begin
        $readmemh("intr.txt", instr_mem);
    end*/
    
    initial begin 
    $readmemh("instructions.mem",instr_mem); 
    end

    //asychronous read
    assign instr = {instr_mem [pc],instr_mem [pc+1],instr_mem [pc+2],instr_mem [pc+3]};

    //program counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pc <= 32'h00000000;
        else if(!stall)begin
            pc <= pc_next;
        end
        else 
            pc <= pc;
        
    end

    always_comb begin
        if (br_taken)
            pc_next = branch_address;
        else
            pc_next = pc+ 32'h00000004;
    end
    
endmodule