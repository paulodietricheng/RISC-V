`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 08:02:01 AM
// Design Name: 
// Module Name: decode
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

module decode (
    input logic [31:0] instruction,
    
    // Decoded fields (ref RISC V ISA)
    output logic [4:0]  rs1_addr, rs2_addr, rd_addr,
    output logic [6:0]  opcode,
    output logic [2:0]  funct3,
    output logic [6:0]  funct7,
    output logic        r_type,
    output logic        i_type,
    output logic        s_type,
    output logic        b_type,
    output logic        u_type,
    output logic        j_type,
    output logic [31:0] imm
);

    // Internal signals
    logic [31:0] imm_i_type;
    logic [31:0] imm_s_type;
    logic [31:0] imm_b_type;
    logic [31:0] imm_u_type;
    logic [31:0] imm_j_type;
    
    // Extract fields (ref RISC V ISA)
    assign opcode   = instruction [6:0];
    assign rd_addr  = instruction [11:7];
    assign funct3   = instruction [14:12];
    assign rs1_addr = instruction [19:15];
    assign rs2_addr = instruction [24:20];
    assign funct7   = instruction [31:25];
    
    // Immediate extractions for different instruction types (ref RISC V ISA)
    assign imm_i_type = {{20{instruction[31]}}, instruction [31:20]};
    assign imm_s_type = {{21{instruction[31]}}, instruction [30:25], instruction [11:7]};
    assign imm_b_type = {{20{instruction[31]}}, instruction [7], instruction [30:25], instruction [11:8], 1'b0};
    assign imm_u_type = {instruction [31:12], 12'b0};
    assign imm_j_type = {{12{instruction[31]}}, instruction[19:12], instruction [20], instruction[30:21],1'b0};
    
    // Instruction detection by opcode
    always_comb begin
        r_type = 1'b0;
        i_type = 1'b0;
        s_type = 1'b0;
        b_type = 1'b0;
        u_type = 1'b0;
        j_type = 1'b0;
        
        case (opcode)
            R_TYPE :    r_type = 1'b1;
            I_LOAD ,    
            I_ALU  ,
            I_JALR :    i_type = 1'b1;
            S_TYPE :    s_type = 1'b1;
            B_TYPE :    b_type = 1'b1;
            U_LUI  ,     
            U_AUIPC:    u_type = 1'b1;
            J_TYPE :    j_type = 1'b1;
        endcase
    end
        
    // Final immediate selection
    assign imm = r_type ? '0 :
                 i_type ? imm_i_type :
                 s_type ? imm_s_type :
                 b_type ? imm_b_type :
                 u_type ? imm_u_type :
                          imm_j_type;
    
endmodule
