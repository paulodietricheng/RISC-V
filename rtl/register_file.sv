`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:49:28 PM
// Design Name: 
// Module Name: register_file
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


module register_file (
    input  logic clk, rst_n,
    
    // Register addresses
    input  logic [4:0]  rs1_addr, rs2_addr, rd_addr,
    input  logic        rf_wr_en,
    
    // Data to be written
    input  logic [31:0] wr_data,
    
    // Read data outputs
    output logic [31:0] rs1_data, rs2_data
);

    // Register file (32x32 bit register)
    logic [31:0] regs [0:31];
    
    // Reset and write logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            foreach (regs[i])
                regs[i] <= '0;
        end else if (rf_wr_en && (rd_addr != '0)) begin // Reg 0 is hardwired to 0
            regs[rd_addr] <= wr_data;
        end 
    end
    
    // Read
    assign rs1_data = regs[rs1_addr];
    assign rs2_data = regs[rs2_addr];
endmodule
