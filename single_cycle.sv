`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 05:03:54 PM
// Design Name: 
// Module Name: single_cycle
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

module single_cycle(
    input logic clk,
    input logic rst_n,
    output logic [31:0] alu_out
);

    // AXI4-Lite signals
   
    logic ARREADY, RVALID, ARVALID, RREADY, AWREADY, BVALID, AWVALID, BREADY, stall;
    logic [31:0] ARADDR, AWADDR, WDATA, RDATA, MS_WDATA;
    logic [3:0] WSTRB;
    logic [1:0] RRESP, BRESP;
   
    
    //connecting signals
    logic br_taken;
    logic [31:0] pc;
    logic [31:0] instruction;
    logic [31:0] data_rd;
    logic [31:0] data_rs1;
    logic [31:0] data_rs2;
    logic [31:0] imm;
    
    logic [31:0] mem_data;
    //controller signals
    logic mem_wr_en;
    logic mem_rd_en;
    logic reg_wr_en;
    
   // logic [1:0] mem_rd_type;
   // logic [1:0] mem_wr_type;
    logic [2:0]  funct3;
    logic [6:0]  funct7;
    logic mux_a_sel;
    logic mux_b_sel;
    logic [1:0] wrb_mux_sel;

    type_alu_op_e alu_op;
    type_branch_cond_e br_type;
    wire type_opcode_e opcode;

    //fetch stage
    fetch_stage ft_sg(
    .clk (clk),
    .rst_n (rst_n),
    .stall(stall),
    .br_taken (br_taken),
    .branch_address (alu_out),
    .pc (pc),
    .instr (instruction)
    );

    //decode stage
    decode_stage dc_sg(
    .clk (clk),
    .rst_n (rst_n),
    .reg_wr_en (reg_wr_en),
    .instruction (instruction),
    .opcode (opcode),
    .funct3 (funct3),
    .funct7 (funct7),
    .data_rd (data_rd),
    .data_rs1 (data_rs1),
    .data_rs2 (data_rs2),
    .imm (imm)
    );

    //execute stage
    execute_stage ex_sg(
    .data_rs1 (data_rs1),
    .data_rs2 (data_rs2),
    .immediate (imm),
    .pc (pc),
    .alu_out (alu_out),
    .alu_op (alu_op),
    .mux_a_sel (mux_a_sel),
    .mux_b_sel (mux_b_sel)
    );

    //branch condition checking
    branch_cond br_ck(
    .data_rs1 (data_rs1),
    .data_rs2 (data_rs2),
    .br_type (br_type),
    .br_taken (br_taken)
    );
    
    
        //memory stage
        
    
    // AXI4-Lite Master
    axi4_lite_master axi_mas(
        .ACLK(clk),
        .stall(stall),
        .ARESETN(rst_n),
        .START_READ(mem_rd_en),
        .START_WRITE(mem_wr_en),
        .address(alu_out),        // Ensure alu_result is a valid address
        .W_data(data_rs2),       // Data to be written
        .M_ARREADY(ARREADY),
        .M_RDATA(mem_data),
        .M_RRESP(RRESP),
        .M_RVALID(RVALID),
        .M_AWREADY(AWREADY),
        .M_WREADY(WREADY),
        .M_BRESP(BRESP),
        .M_BVALID(BVALID),
        .M_ARADDR(ARADDR),
        .M_ARVALID(ARVALID),
        .M_RREADY(RREADY),
        .M_AWADDR(AWADDR),
        .M_AWVALID(AWVALID),
        .M_WDATA(MS_WDATA),
        .M_WSTRB(WSTRB),
        .M_WVALID(WVALID),
        .M_BREADY(BREADY)
    );
    
    // AXI4-Lite Slave
    axi4_lite_slave axi_sla(
        .ACLK(clk),
        .ARESETN(rst_n),
        .S_ARADDR(ARADDR),
        .S_ARVALID(ARVALID),
        .S_RREADY(RREADY),
        .S_AWADDR(AWADDR),
        .S_AWVALID(AWVALID),
        .S_WDATA(MS_WDATA),
        .S_WSTRB(WSTRB),
        .S_WVALID(WVALID),
        .S_BREADY(BREADY),
        .S_ARREADY(ARREADY),
        .S_RDATA(mem_data),
        .S_RRESP(RRESP),
        .S_RVALID(RVALID),
        .S_AWREADY(AWREADY),
        .S_WREADY(WREADY),
        .S_BRESP(BRESP),
        .S_BVALID(BVALID)
    );


    






    //writeback mux
    always_comb begin
        case (wrb_mux_sel)
            0: data_rd = alu_out;
            1: data_rd = mem_data;
            2: data_rd = pc + 32'h00000004;
            default: data_rd = 32'h00000000;
        endcase
    end

    //controller
    sc_controller sc_ctrl (
    .opcode (opcode),
    .funct3 (funct3),
    .funct7 (funct7),
    .reg_wr_en (reg_wr_en),
    .mux_a_sel (mux_a_sel),
    .mux_b_sel (mux_b_sel),
    .stall(stall),
    .alu_op (alu_op),
    .mem_wr_en (mem_wr_en),
    .mem_rd_en(mem_rd_en),
    .wrb_mux_sel (wrb_mux_sel),
    .br_type (br_type)
    );

endmodule