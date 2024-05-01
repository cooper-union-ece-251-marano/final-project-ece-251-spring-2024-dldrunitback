//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: YOUR NAMES
// 
//     Create Date: 2023-02-07
//     Module Name: tb_datapath
//     Description: Test bench for datapath
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_DATAPATH
`define TB_DATAPATH

`timescale 1ns/100ps


module datapath_tb;

    parameter WIDTH = 16;
    reg clk;        // Clock signal
    reg reset;      // Reset signal
    reg memtoreg;   // Memory to register control
    reg pcsrc;      // PC source control
    reg alusrc;     // ALU source control
    reg regdst;     // Register destination control
    reg regwrite;   // Register write enable control
    reg jump;       // Jump control
    reg [3:0] alucontrol; // ALU control signal
    wire zero;      // Zero flag from ALU
    wire [WIDTH-1:0] pc; // Program counter output
    reg [WIDTH-1:0] instr; // Instruction input
    wire [WIDTH-1:0] aluout; // ALU output
    wire [WIDTH-1:0] writedata; // Write data to memory or register file
    reg [WIDTH-1:0] readdata; // Read data from memory

    // Instantiate the UUT (Unit Under Test)
    datapath #(WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .zero(zero),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Generate clock with 10ns period (5ns high, 5ns low)
    end

    // Test bench
    initial begin
        // Initialize control signals and instruction input
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 4'b0000; // Initial ALU control (AND operation)
        instr = 16'h0000; // Initial instruction
        readdata = 16'h0000; // Initial read data

        #10;
        reset = 0; // Release reset signal

        // Test case: ALU operation (AND)
        alucontrol = 4'd0; // AND operation
        instr = 16'h1234; // Sample instruction
        readdata = 16'hFFFF; // Sample read data
        memtoreg = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 1;
        #10; // Wait for operation to take effect
        $display("Test 1: AND operation");
        $display("PC: %h, ALU out: %h, Write data: %h, Zero: %b", pc, aluout, writedata, zero);
        
        // Add additional test cases for other operations, e.g.:
        // - OR operation
        // - ADD operation
        // - SUB operation
        // - MUL operation
        // - Memory operations (memtoreg, readdata, etc.)
        // - Branching operations (pcsrc, jump)
        // - Reset behavior and initialization

        // Repeat the structure of the first test case for each operation, adjusting the control signals and inputs as necessary.

        // Continue adding other test cases...

        $finish; // End the simulation
    end

endmodule

`endif // TB_DATAPATH