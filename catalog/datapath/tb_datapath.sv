//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
//
//     Module Name: tb_datapath
//     Description: Test bench for datapath
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

// Include the module being tested
`include "datapath.sv"

module datapath_tb;

    // Parameters
    parameter WIDTH = 16;

    // Declare inputs as reg and outputs as wire
    reg clk;
    reg reset;
    reg memtoreg;
    reg pcsrc;
    reg alusrc;
    reg regdst;
    reg regwrite;
    reg jump;
    reg [3:0] alucontrol;
    reg [WIDTH-1:0] instr;
    reg [WIDTH-1:0] readdata;

    wire zero;
    wire [WIDTH-1:0] pc;
    wire [WIDTH-1:0] aluout;
    wire [WIDTH-1:0] writedata;

    // Instantiate the module under test
    datapath #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .instr(instr),
        .readdata(readdata),
        .zero(zero),
        .pc(pc),
        .aluout(aluout),
        .writedata(writedata)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 ns (50 MHz)
    end
  
    // Extended test cases
    initial begin
        // Initialize inputs
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 4'b0000; // ALU control for ADD operation
        instr = 16'b0000000000000000; // NOP instruction
        readdata = 16'b0000000000000000; // Example data read from memory

        // Release reset
        #20 reset = 0;

        // Test case 1: Simple addition
        instr = 16'b0001_0010_0011_0100; // Example instruction
        regwrite = 1; // Enable write to register file
        alusrc = 1; // ALU source B from immediate data
        alucontrol = 4'b0010; // ALU control for ADD operation
        memtoreg = 0; // ALU result is the data to write
        
        // Monitor the results
        #50;
        $display("Test case 1: Simple addition");
        $display("PC: %h, ALUOut: %h, Writedata: %h, Zero: %b", pc, aluout, writedata, zero);
        
        // Other test cases...

        // Test case 2: Jump instruction
        instr = 16'b0001_0000_0000_0000; // Jump instruction
        jump = 1; // Enable jump
        #20;
        $display("Test case 2: Jump instruction");
        $display("PC: %h, ALUOut: %h, Writedata: %h, Zero: %b", pc, aluout, writedata, zero);

        // More test cases...

        // Finish the simulation
        $finish;
    end

    // Monitor outputs continuously
    initial begin
        $monitor("Time: %t | PC: %h | ALUOut: %h | Writedata: %h | Zero: %b | Instr: %h | Ctrl Signals - MemtoReg: %b, PCSrc: %b, ALUSrc: %b, RegDst: %b, RegWrite: %b, Jump: %b, ALUControl: %b",
                 $time, pc, aluout, writedata, zero, instr,
                 memtoreg, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
    end

endmodule
