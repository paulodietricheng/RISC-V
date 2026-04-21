`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2026 07:56:08 AM
// Design Name: 
// Module Name: RISC_PKG
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


package risc_pkg;

    // RISC V Opcodes
    typedef enum logic [6:0] {
        R_TYPE  = 7'h33,
        I_LOAD  = 7'h03,
        I_ALU   = 7'h13,
        I_JALR  = 7'h67,
        S_TYPE  = 7'h23,
        B_TYPE  = 7'h63,
        U_LUI   = 7'h37,
        U_AUIPC = 7'h17,
        J_TYPE  = 7'h6F
    } opcode_t ;
    
    // ALU Operation selector
    typedef enum logic [3:0] {
        ADD,
        SUB,
        SLL,    // Shift Left Logical
        SLT,    // Set Less Than
        SLTU,   // Set Less Than Unsigned
        XOR,
        SRL,    // Shift Right Logic
        SRA,    // Shift Right Arithmetic
        OR,
        AND
     } alu_op_t ;
     
     // Memory Access Size
     typedef enum logic [1:0] {
        BYTE      = 2'b00, // 8 bits
        HALF_WORD = 2'b01, // 16 bits
        WORD      = 2'b11  // 32 bits
     } mem_size_t ;
     
     // B-type instructions
     typedef enum logic [2:0] {
        B_BEQ  = 3'h0,
        B_BNE  = 3'h1,
        B_BLT  = 3'h4,
        B_BGE  = 3'h5,
        B_BLTU = 3'h6,
        B_BGEU = 3'h7
     } b_type_instr_t ;
    
    // R-type instructions
    typedef enum logic [3:0] {
        R_ADD  = 4'h0,
        R_SUB  = 4'h8,
        R_SLL  = 4'h1,
        R_SLT  = 4'h2,
        R_SLTU = 4'h3,
        R_XOR  = 4'h4,
        R_SRL  = 4'h5,
        R_SRA  = 4'hD,
        R_OR   = 4'h6,
        R_AND  = 4'h7
     } r_type_instr_t ;
     
     // I-type instructions
     typedef enum logic [3:0] {
        I_LB    = 4'h0,
        I_LH    = 4'h1,
        I_LW    = 4'h2,
        I_LBU   = 4'h4,
        I_LHU   = 4'h5,
        I_ADDI  = 4'h8,
        I_SLTI  = 4'hA,
        I_SLTIU = 4'hB,
        I_XORI  = 4'hC,
        I_ORI   = 4'hE,
        I_ANDI  = 4'hF,
        I_SLLI  = 4'h9,
        I_SRLI_SRAI = 4'hD
     } i_type_instr_t ;
     
     // S-type instructions
     typedef enum logic [2:0] {
        S_SB = 3'h0,
        S_SH = 3'h1,
        S_SW = 3'h2
     } s_type_instr_t ;
     
     // Register file writeback sources
     typedef enum logic [1:0] {
        WB_SRC_ALU,
        WB_SRC_MEM,
        WB_SRC_IMM,
        WB_SRC_PC
     } wb_src_t ;
     
     // Control Signal Struct
     typedef struct packed {
        logic      mem_valid;        // Asserted for memory access
        logic      mem_write;        // 1 = write, 0 = read
        mem_size_t mem_size;         // BYTE, HALF, WORD
        logic      ld_zero_extend;   // 1 = zero, 0 = sign
        logic      rf_wr_en;
        logic      pc_src_sel;       // 1 = bra/jump, 0 = sequential
        logic      alu_src_a_sel;    // 1 = PC, 0 = rs1
        logic      alu_src_b_sel;    // 1 = imm, 0 = rs2
        wb_src_t   wb_src;
        alu_op_t   alu_op; 
     } control_t ;
     
endpackage
