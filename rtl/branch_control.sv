`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 07:16:41 AM
// Design Name: 
// Module Name: branch_control
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

module branch_control(
    // Operands to compare
    input  logic [31:0] opr_a, opr_b,
    
    // Branch instruction info
    input  logic        is_b_type,
    input  logic [2:0]  funct3,
    
    output logic        branch_taken // 1 = yes, 0 = no
);

    // Signed versions
    logic signed [31:0] signed_a, signed_b;
    assign signed_a = opr_a;
    assign signed_b = opr_b;
    
    logic taken;
    
    always_comb begin
        taken = 1'b0;
        
        case (funct3)
            B_BEQ :    taken = (opr_a == opr_b);
            B_BNE :    taken = (opr_a != opr_b);
            B_BLT :    taken = (signed_a < signed_b);
            B_BGE :    taken = (signed_a >= signed_b);
            B_BLTU:    taken = (opr_a < opr_b);
            B_BGEU:    taken = (opr_a >= opr_b);            
        endcase
    end
    
    assign branch_taken = is_b_type & taken;
    
endmodule
