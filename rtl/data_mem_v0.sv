`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 06:47:57 AM
// Design Name: 
// Module Name: data_memory
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

import risc_pkg::*;

module data_memory_v0 #(
    parameter ADDR_W = 10,
    parameter DATA_W = 8   // One byte per slot
)(
    input  logic        clk,
    input  logic        dmem_req,         // Enable
    input  logic        dmem_wr_en,       // 1 = write, 0 = read
    input  mem_size_t   dmem_data_size,
    input  logic [31:0] dmem_addr,
    input  logic [31:0] dmem_wr_data,
    input  logic        dmem_zero_extend, // 1 = zero, 0 = sign
    
    output logic [31:0] dmem_rd_data
);

    // RAM Declaration 
    logic [DATA_W-1:0] mem [0:(2**ADDR_W)-1];
    
    // Write logic
    always_ff @(posedge clk) begin
        if(dmem_req && dmem_wr_en) begin
            case (dmem_data_size)
                BYTE     :   mem[dmem_addr] <= dmem_wr_data[7:0];                       // SB
                HALF_WORD:  {mem[dmem_addr + 1], mem[dmem_addr]} <= dmem_wr_data[15:0]; // SH
                WORD     :  {mem[dmem_addr + 3], mem[dmem_addr + 2],
                             mem[dmem_addr + 1], mem[dmem_addr]} <= dmem_wr_data;       // SW
            endcase
        end
    end
    
    // Read logic
    always_comb begin
        if(dmem_req && !dmem_wr_en) begin
            case (dmem_data_size)
                BYTE     :  dmem_rd_data = dmem_zero_extend ? 
                               {{24{1'b0}}, mem[dmem_addr]} :             // LBU
                               {{24{mem[dmem_addr][7]}}, mem[dmem_addr]}; // LB
                HALF_WORD:  dmem_rd_data = dmem_zero_extend ? 
                               {{16{1'b0}}, mem[dmem_addr + 1], mem[dmem_addr]} :               // LHU
                               {{16{mem[dmem_addr+1][7]}}, mem[dmem_addr + 1], mem[dmem_addr]}; // LH
                WORD     :  dmem_rd_data = {mem[dmem_addr + 3], mem[dmem_addr + 2], mem[dmem_addr + 1], mem[dmem_addr]}; // LW
            endcase
        end else
            dmem_rd_data = '0;
    end
endmodule