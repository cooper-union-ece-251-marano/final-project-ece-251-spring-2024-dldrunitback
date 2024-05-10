//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: YOUR NAMES
// 
//     Create Date: 2023-02-07
//     Module Name: tb_cpu
//     Description: Test bench for cpu
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_CPU
`define TB_CPU

`timescale 1ns / 1ps

module cpu_testbench;

    // Inputs to the CPU
    reg clk;
    reg reset;
    reg [15:0] instr;
    reg [15:0] readdata;

    // Outputs from the CPU
    wire [15:0] pc;
    wire memwrite;
    wire [15:0] aluout;
    wire [15:0] writedata;

    // Instantiate the CPU module
    cpu uut (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readdata(readdata),
        .pc(pc),
        .memwrite(memwrite),
        .aluout(aluout),
        .writedata(writedata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        reset = 1;
        instr = 0;
        readdata = 0;

        // Wait for global reset to propagate
        #10;
        reset = 0;

        // Sample test case: Add two numbers

        instr = 16'h3002; // Opcode for ADD instruction (example)
        readdata = 0; // Not used in this instruction

        // Wait for the instruction to execute
        #10;

        // Change instruction to a memory write
        instr = 16'hA003; // Opcode for STORE instruction (example)
        readdata = 16'h0010; // Data to write into memory
        
        // Check the output
        #10;

        reset = 1;
        #10;
        reset = 0;

        #100;

        // Finish simulation
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time = %d : pc = %h, aluout = %h, memwrite = %b, writedata = %h", $time, pc, aluout, memwrite, writedata);
    end

endmodule

`endif
