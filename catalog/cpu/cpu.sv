//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Prof Rob Marano
// 
//     Create Date: 2023-02-07
//     Module Name: cpu
//     Description: 32-bit RISC-based CPU (MIPS)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef CPU
`define CPU
 
`timescale 1ns/100ps
 
// Simplified controller and datapath files need to be defined appropriately

`include "../controller/controller.sv"
`include "../datapath/datapath.sv"
 
module cpu(
    input  logic          clk,
    input  logic          reset,
    output logic [15:0]   pc,
    input  logic [15:0]   instr,
    output logic          memwrite,
    output logic [15:0]   aluout,
    output logic [15:0]   writedata,
    input  logic [15:0]   readdata
);
 
    // Controller signals

    logic       regwrite, jump, branch, memtoreg, alusrc, regdst, pcsrc, zero;
    logic [3:0] alucontrol;
 
    // Instantiate the controller

    controller c(

        .op(instr[15:10]),
        .funct(instr[5:0]),
        .zero(result == 0),  // Simple zero flag based on ALU output
        .regwrite(regwrite),
        .jump(jump),
        //.branch(branch),
        .memwrite(memwrite),
        .memtoreg(memtoreg),
        .alusrc(alusrc),
        .pcsrc(pcsrc),
        .regdst(regdst),
        .alucontrol(alucontrol)

    );
 
    // Instantiate the datapath

    datapath dp(

        .clk(clk),
        .reset(reset),
        .regwrite(regwrite),
        .jump(jump),
        //.branch(branch),
        .memtoreg(memtoreg),
        .alusrc(alusrc),
        //.aluop(aluop),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );
 
endmodule
 
`endif // CPU
 