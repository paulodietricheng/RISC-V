`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 01:59:51 PM
// Design Name: 
// Module Name: alu
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

module alu (
    input  logic    [31:0]  alu_a, alu_b,
    input  alu_op_t         alu_op,    
    output logic    [31:0]  alu_res
);

    // Internal signed versions
    logic signed [31:0] signed_a, signed_b;
    
    assign signed_a = alu_a;
    assign signed_b = alu_b;
    
    // ALU Operation logic
    always_comb begin
        alu_res = '0; // Default
        
        case (alu_op)
            ADD :    alu_res = alu_a + alu_b;
            SUB :    alu_res = alu_a - alu_b;
            
            SLL :    alu_res = alu_a    <<  alu_b [4:0];
            SRL :    alu_res = alu_a    >>  alu_b [4:0];
            SRA :    alu_res = signed_a >>> alu_b [4:0];
            
            OR  :    alu_res = alu_a | alu_b;
            AND :    alu_res = alu_a & alu_b;
            XOR :    alu_res = alu_a ^ alu_b;
            
            SLT :    alu_res = (signed_a < signed_b) ? 32'd1 : '0;
            SLTU:    alu_res = (alu_a < alu_b)       ? 32'd1 : '0;
        endcase
    end
    
endmodule
