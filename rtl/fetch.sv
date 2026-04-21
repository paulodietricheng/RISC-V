`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 07:44:40 AM
// Design Name: 
// Module Name: fetch
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


module fetch (
    input  logic        clk, rst_n,
    input  logic [31:0] pc,         // Current PC
    input  logic [31:0] imem_data,  // Data read from memory
    
    output logic        imem_req,   // Enable requet
    output logic [31:0] imem_addr,  // Addres to read from 
    output logic [31:0] instruction
);

    // Internal request register
    logic req_reg;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            req_reg <= 1'b0;
        else
            req_reg <= 1'b1; // Always fetch instructions after reset
    end
    
    // Outputs
    assign imem_req    = req_reg;
    assign imem_addr   = pc;
    assign instruction = imem_data;

endmodule
