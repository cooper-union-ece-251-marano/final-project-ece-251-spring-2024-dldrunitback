//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski & Siann Han
// 
//     Create Date: 2024-05-29
//     Module Name: tb_controller
//     Description: Test bench for controller
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

`include "controller.sv"

module tb_controller;

    logic [5:0] op, funct;
    logic       zero;

    logic       memtoreg, memwrite, pcsrc, alusrc;
    logic       regdst, regwrite, jump;
    logic [3:0] alucontrol;

    controller uut (
        .op(op),
        .funct(funct),
        .zero(zero),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol)
    );

    task display_outputs;
        begin
            $display("Inputs: op = %b, funct = %b, zero = %b", op, funct, zero);
            $display("Outputs: memtoreg = %b, memwrite = %b, pcsrc = %b, alusrc = %b, regdst = %b, regwrite = %b, jump = %b, alucontrol = %b", 
                memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, alucontrol);
        end
    endtask

    // Test 
    initial begin
        // Initialize inputs
        op = 6'b000000;
        funct = 6'b000000;
        zero = 1'b0;

        // Test  1: Check R-type instruction
        #10;
        op = 6'b000000; // R-type
        funct = 6'b100000; // ADD
        zero = 1'b0;
        #10;
        display_outputs;

        // Test  2: Check beq instruction
        #10;
        op = 6'b000100; // BEQ
        funct = 6'b000000;
        zero = 1'b1; // Zero flag set to 1
        #10;
        display_outputs;

        // Add more test cases for different instructions and opcodes as needed

        // End simulation
        $finish;
    end

endmodule
