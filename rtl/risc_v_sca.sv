`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2026 08:33:58 AM
// Design Name: 
// Module Name: RiSC_V_SCA
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

module risc_v_sca #(parameter RESET_PC = '0)(
    input logic clk, rst_n,
    output [31:0] debug_pc
);
    assign debug_pc = pc;
    // Instruction memory interface
    logic        imem_req;
    logic [31:0] imem_addr, imem_data;
    
    // Data memory interface
    logic        dmem_req;
    logic        dmem_wr_en;
    mem_size_t   dmem_size;
    logic        dmem_zero_extend;
    logic [31:0] dmem_addr, dmem_wr_data, dmem_rd_data;
    
    // Program Counter signals
    logic [31:0] pc, next_pc, next_seq_pc;
    logic        pc_sel, rst_seen;
    
    // Instruction signals
    logic [31:0] instruction;
    logic [6:0]  opcode;
    logic [6:0]  funct7;
    logic [2:0]  funct3;
    logic        r_type, i_type, s_type, b_type, u_type, j_type;
    
    // Register file signals
    logic [4:0]  rs1_addr, rs2_addr, rd_addr;
    logic [31:0] rs1_data, rs2_data, wr_data;  
    logic [31:0] imm;
    wb_src_t     rf_wr_data_sel;
    logic        rf_wr_en;
    
    // ALU signals
    logic [31:0] alu_a, alu_b, alu_res;
    alu_op_t alu_op;
    
    // Control and branch signals
    logic op1_sel, op2_sel;
    logic branch_taken;
    
    // Reset and PC logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_seen <= 1'b0;
            pc <= RESET_PC;
        end else begin
            rst_seen <= 1'b1;
            if (rst_seen)
                pc <= next_pc;
        end  
    end
    
    assign next_seq_pc = pc + 32'd4;
    assign next_pc     = (branch_taken | pc_sel) ? {alu_res[31:1], 1'b0} : next_seq_pc; 
    
    // Instruction memory
    instruction_memory U_IM (
        .imem_req (imem_req),
        .imem_addr(imem_addr),
        .imem_data(imem_data)
    );
    
    // Fetch
    fetch U_FET (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc         (pc),
        .imem_req   (imem_req),
        .imem_addr  (imem_addr),
        .imem_data  (imem_data),
        .instruction(instruction)        
    );
    
    // Decode
    decode U_DEC (
        .instruction(instruction),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr (rd_addr),
        .opcode  (opcode),
        .funct3  (funct3),
        .funct7  (funct7),
        .r_type  (r_type),
        .i_type  (i_type),
        .s_type  (s_type),
        .b_type  (b_type),
        .u_type  (u_type),
        .j_type  (j_type),
        .imm     (imm)
    );
    
    // Register file
    always_comb begin
        case (rf_wr_data_sel)
            WB_SRC_ALU:   wr_data = alu_res;
            WB_SRC_MEM:   wr_data = dmem_rd_data;
            WB_SRC_IMM:   wr_data = imm;
            WB_SRC_PC :   wr_data = next_seq_pc;
        endcase
    end
    
    register_file U_RF (
        .clk     (clk),
        .rst_n   (rst_n),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr (rd_addr),
        .rf_wr_en(rf_wr_en),
        .wr_data (wr_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    
    // Control
    control U_CTRL (
        .r_type (r_type),
        .i_type (i_type),
        .s_type(s_type),
        .b_type(b_type),
        .u_type(u_type),
        .j_type(j_type),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .pc_sel(pc_sel),
        .op1_sel(op1_sel),
        .op2_sel(op2_sel),
        .alu_op(alu_op),
        .rf_wr_data_sel(rf_wr_data_sel),
        .rf_wr_en(rf_wr_en),
        .dmem_req(dmem_req),
        .dmem_size(dmem_size),
        .dmem_wr_en(dmem_wr_en),
        .dmem_zero_extend(dmem_zero_extend)
    );
    
    // Branch Control
    branch_control U_BRA (
        .opr_a       (rs1_data),
        .opr_b       (rs2_data),
        .is_b_type   (b_type),
        .funct3      (funct3),
        .branch_taken(branch_taken)
    );
    
    // ALU
    assign alu_a = op1_sel ? pc  : rs1_data;
    assign alu_b = op2_sel ? imm : rs2_data;
    
    alu U_ALU (
        .alu_a(alu_a),
        .alu_b(alu_b),
        .alu_op (alu_op),
        .alu_res(alu_res)
    );
    
    // Data memory
    assign dmem_addr    = alu_res;
    assign dmem_wr_data = rs2_data;
    
    data_memory_v0 U_DM (
        .clk(clk),
        .dmem_req        (dmem_req),
        .dmem_wr_en      (dmem_wr_en),
        .dmem_data_size  (dmem_size),
        .dmem_addr       (dmem_addr),
        .dmem_wr_data    (dmem_wr_data),
        .dmem_zero_extend(dmem_zero_extend),
        .dmem_rd_data    (dmem_rd_data)
    );
endmodule
