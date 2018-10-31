# Basic-SIMD-Processor-Verilog-Tutorial 
Implementation of a simple SIMD processor in Verilog, core of which is a 16-bit SIMD ALU. 2's compliment calculations are implemented in this ALU. The ALU operation will take two clocks. The first clock cycle will be used to load values into the registers. The second will be for performing the operations. 6-bit opcodes are used to select the functions. The instruction code, including the opcode, will be 18-bit.

<img src="https://github.com/zslwyuan/Basic-SIMD-Processor-Verilog-Tutorial/blob/master/Processor.PNG" width="500"> 

The ALU will be embedded into a simple processor based on 5-stage, delay of each stage will
be 1 cycle, meeting the delay of ALU, as shown in the figure below. The 5 typical stages are IF, ID,
EX, MEM and WB, without pipeline. In the stage IF, a 10-bit address will be sent to an instruction
Block-RAM (BRAM) to fetch 18-bit instruction. In the stage ID, the instruction will be decoded
and some of control registers will be set to control the following stage. In the stage EX, ALU will
process data in registers or implement some control commands, e.g. jump. In the stage MEM, if the
instruction is “store” or “load”, data would be read from/ written to data BRAM, based on instruction
and address. Finally, in the stage WB, data will be written back to register. The pins of clock, reset,
address, data and BRAM enable will be exposed on the interface of processor. The architecture of
processor is shown in the figure above.

The experiment based on Cadence are shown below and more details can be found in the **[report](https://github.com/zslwyuan/Basic-SIMD-Processor-Verilog-Tutorial/blob/master/report.pdf)**. The source code is well-commented and user can easily understanding how it work. This work was implemented as the final project of Digital VLSI System Design and Design Automation, HKUST. Thanks Prof. Tsui and TA Zhu a lot for their patience and time!

<img src="https://github.com/zslwyuan/Basic-SIMD-Processor-Verilog-Tutorial/blob/master/post_layout_Sim.PNG" width="500"> 

<img src="https://github.com/zslwyuan/Basic-SIMD-Processor-Verilog-Tutorial/blob/master/Layout.PNG" width="500"> 
