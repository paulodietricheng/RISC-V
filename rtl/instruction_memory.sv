module instruction_memory #(
    parameter ADDR_W = 7
)(
    input  logic        imem_req,
    input  logic [31:0] imem_addr,
    output logic [31:0] imem_data
);
    // 32-bit wide ROM - one word per address
    logic [31:0] mem [0:(2**ADDR_W)-1];

    initial begin
        $readmemh("fibonacci_sequence_machine_code.mem", mem);
    end

    always_comb begin
        if (imem_req)
            imem_data = mem[imem_addr >> 2]; // byte addr → word addr
        else
            imem_data = '0;
    end
endmodule