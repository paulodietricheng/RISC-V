# Single-Cycle RISC-V Processor (Artix-7 FPGA)

This project implements a **single-cycle RISC-V (RV32I) processor** on an Artix-7 xc7a35tcpg236 FPGA. It is a minimal yet fully functional design intended for learning, experimentation, and architectural exploration.

The processor executes each instruction in a single clock cycle and supports the base **RV32I ISA**.

---

## Architecture Overview

The processor is composed of the following 8 modules:

- **Instruction Memory (128kB)**  
  Stores program instructions in hexadecimal format.

- **Fetch**  
  Handles program counter (PC) updates and instruction fetching.

- **Decode**  
  Decodes instruction fields and prepares operands.

- **Control**  
  Generates control signals based on instruction type.

- **Register File**  
  Provides register read/write functionality.

- **Branch Control**  
  Evaluates branch conditions and determines control flow.

- **Data Memory (255kB)**  
  Handles load and store operations.

- **ALU (Arithmetic Logic Unit)**  
  Executes arithmetic and logical operations.

---

## Features

- Single-cycle execution model
- Modular and extensible design
- Synthesizable on Xilinx Artix-7 FPGA
- Capable of executing simple programs such as:
  - Maximum value search
  - Bubble sort
  - Fibonacci sequence generation

---

## Resource Utilization

| Resource | Usage |
|----------|------:|
| LUTs     | 18878 |
| FFs      | 4384  |

---

## Performance

- **Maximum Frequency (Fmax):** 99.79 MHz

---

## Implementation Notes

- Designed and synthesized using Xilinx Vivado
- Instruction memory initialized using hex files
- Focused on clarity and correctness over optimization
- Suitable as a foundation for:
  - Pipelined architectures
  - Hazard detection/forwarding
  - Cache integration

---

## Future Improvements
 - Pipeline implementation (5-stage or deeper)
 - Hazard detection and forwarding
 - Expand data memory
 - Instruction/data cache integration
 - Branch prediction
 - Performance optimization (timing and area)

