`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/04/2024 05:52:55 PM
// Design Name: 
// Module Name: axi4_lite_slave
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

module axi4_lite_slave #(
    parameter ADDRESS = 32,
    parameter DATA_WIDTH = 32
    )
    (
        //Global Signals
        input                           ACLK,
        input                           ARESETN,

        ////Read Address Channel INPUTS
        input           [ADDRESS-1:0]   S_ARADDR,
        input                           S_ARVALID,
        //Read Data Channel INPUTS
        input                           S_RREADY,
        //Write Address Channel INPUTS
        /* verilator lint_off UNUSED */
        input           [ADDRESS-1:0]   S_AWADDR,
        input                           S_AWVALID,
        //Write Data  Channel INPUTS
        input          [DATA_WIDTH-1:0] S_WDATA,
        input          [3:0]            S_WSTRB,
        input                           S_WVALID,
        //Write Response Channel INPUTS
        input                           S_BREADY,	

        //Read Address Channel OUTPUTS
        output logic                    S_ARREADY,
        //Read Data Channel OUTPUTS
        output logic    [DATA_WIDTH-1:0]S_RDATA,
        output logic         [1:0]      S_RRESP,
        output logic                    S_RVALID,
        //Write Address Channel OUTPUTS
        output logic                    S_AWREADY,
        output logic                    S_WREADY,
        //Write Response Channel OUTPUTS
        output logic         [1:0]      S_BRESP,
        output logic                    S_BVALID
    );

    localparam no_of_registers = 32;

    //logic [DATA_WIDTH-1 : 0] register [no_of_registers-1 : 0];
    

    
    logic [DATA_WIDTH-1:0]   s_read_data;
   // logic [ADDRESS-1 : 0]    addr;
    logic  write_addr;
    logic  write_data;
    logic s_wr_en;
   // logic s_rd_en;

    typedef enum logic [2 : 0] {IDLE,WRITE_CHANNEL,WRESP__CHANNEL, RADDR_CHANNEL, RDATA__CHANNEL} state_type;
    state_type state , next_state;
    
    
        
    //connecting slave with data_mem of processor
    
    memory_stage mem_slave(
    .clk(ACLK),
    .rst_n(ARESETN),
    .wr_en(s_wr_en),
    .mem_address(write_addr ? S_AWADDR : S_ARADDR),  // Use S_AWADDR for write and S_ARADDR for read
    .data_wr(S_WDATA),  // Data to write
    .mem_data(s_read_data) // Output read data
);

    
    assign s_wr_en = (state == WRITE_CHANNEL) ? 1: 0;
    //assign s_rd_en = (state == RADDR_CHANNEL) ? 1: 0;
    // AR
    assign S_ARREADY = (state == RADDR_CHANNEL) ? 1 : 0;
    // 
    assign S_RVALID = (state == RDATA__CHANNEL) ? 1 : 0;
    assign S_RDATA = s_read_data;
    //assign S_RDATA  = (state == RDATA__CHANNEL) ? register[addr] : 0;
    assign S_RRESP  = (state == RDATA__CHANNEL) ?2'b11:0;
    // AW
    assign S_AWREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    // W
    assign S_WREADY = (state == WRITE_CHANNEL) ? 1 : 0;
    assign write_addr = S_AWVALID && S_AWREADY;
    assign write_data = S_WREADY &&S_WVALID;
    // B
    assign S_BVALID = (state == WRESP__CHANNEL) ? 1 : 0;
    assign S_BRESP  = (state == WRESP__CHANNEL )? 1:0;


    always_ff @(posedge ACLK) begin
        if (!ARESETN) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    always_comb begin
		case (state)
            IDLE : begin
                if (S_AWVALID) begin
                    next_state = WRITE_CHANNEL;
                end 
                else if (S_ARVALID) begin
                    next_state = RADDR_CHANNEL;
                end 
                else begin
                    next_state = IDLE;
                end
            end
            RADDR_CHANNEL   : if (S_ARVALID && S_ARREADY ) next_state = RDATA__CHANNEL;
            RDATA__CHANNEL  : if (S_RVALID  && S_RREADY  ) next_state = IDLE;
            WRITE_CHANNEL   : if (write_addr &&write_data) next_state = WRESP__CHANNEL;
            WRESP__CHANNEL  : if (S_BVALID  && S_BREADY  ) next_state = IDLE;
            default : next_state = IDLE;
        endcase
    end
endmodule
