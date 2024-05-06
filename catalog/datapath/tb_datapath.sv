//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//     Create Date: 2024-05-01
//     Module Name: tb_datapath
//     Description: Test bench for datapath
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

// Include the datapath module
`include "datapath.sv"

module tb_datapath;

    // Parameters
    parameter WIDTH = 16;

    // Signals
    logic clk;
    logic reset;
    logic memtoreg;
    logic pcsrc;
    logic alusrc;
    logic regdst;
    logic regwrite;
    logic jump;
    logic [3:0] alucontrol;
    logic zero;
    logic [WIDTH-1:0] pc;
    logic [WIDTH-1:0] instr;
    logic [WIDTH-1:0] aluout;
    logic [WIDTH-1:0] writedata;
    logic [WIDTH-1:0] readdata;
    
    // Infer writereg based on instruction and control signals
    logic [3:0] inferred_writereg;

    // Instantiate the datapath module
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
        forever #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Infer `writereg` from instruction and `regdst`
    always @(*) begin
        if (regdst == 0) begin
            inferred_writereg = instr[7:4]; // Use `instr[7:4]` if `regdst` is 0
        end else begin
            inferred_writereg = instr[3:0]; // Use `instr[3:0]` if `regdst` is 1
        end
    end

    // Test scenarios
    initial begin
        // Initialization
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 4'd0;
        instr = 16'd0;
        readdata = 16'd0;

        // Release reset after 10 ns
        #10 reset = 0;

        // Test scenario 1: Sample instruction
        $display("Test scenario 1: Sample instruction");
        instr = 16'h1234;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 1;
        regwrite = 1;
        jump = 0;
        alucontrol = 4'b0010; // ALU ADD operation
        readdata = 16'd100;

        #10; // Allow some time for propagation

        // Display results
        $display("PC: %h, ALU Out: %h, Write Data: %h, Zero: %b", pc, aluout, writedata, zero);
        $display("Inferred Write Register: %d", inferred_writereg);
        
        // Additional test scenarios as needed here
        // For example:
        // - Test ALU operations (e.g., ADD, SUB, AND, OR)
        // - Test memory access
        // - Test branch and jump instructions

        // Stop simulation
        $finish;
    end
endmodule

