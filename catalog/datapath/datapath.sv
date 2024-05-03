//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//     Create Date: 2024-05-01
//     Module Name: datapath
//     Description: 32-bit RISC-based CPU datapath (MIPS)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef DATAPATH
`define DATAPATH

`timescale 1ns/100ps

`include "../regfile/regfile.sv"
`include "../alu/alu.sv"
`include "../dff/dff.sv"
`include "../adder/adder.sv"
`include "../sl2/sl2.sv"
`include "../mux2/mux2.sv"
//`include "../signext/signext.sv"

module datapath
    #(parameter WIDTH = 16)(
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
    input  logic        clk,
    input  logic        reset,
    input  logic        memtoreg,
    input  logic        pcsrc,
    input  logic        alusrc,
    input  logic        regdst,
    input  logic        regwrite,
    input  logic        jump,
    input  logic [3:0]  alucontrol,
    output logic        zero,
    output logic [WIDTH-1:0] pc,
    input  logic [WIDTH-1:0] instr,
    output logic [WIDTH-1:0] aluout,
    output logic [WIDTH-1:0] writedata,
    input  logic [WIDTH-1:0] readdata
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
    logic [3:0]  writereg;
    logic [WIDTH-1:0] pc_next, pc_br_next, pc_plus2, pc_branch;
    logic [WIDTH-1:0] sign_imm, sign_imm_shifted;
    logic [WIDTH-1:0] src_a, src_b;
    logic [WIDTH-1:0] alu_result;
    logic [15:0] jump_target_address;
    logic [15:0] shifted_instr;


    // "Next PC" logic
    dff #(WIDTH) pc_register(
    .d(pc_next),
    .clk(clk),
    .rst(reset),
    .en(1'b1),
    .q(pc)
    );

    adder #(WIDTH) pc_adder1(
    .a(pc),             
    .b(16'd2),          
    .enable(1'b1),      
    .reset(1'b0),       
    .cin(1'b0),         
    .S(pc_plus2),      
    .Cout()           
);

    sl2 #(WIDTH) imm_shift(
    .in(sign_imm),
    .out(sign_imm_shifted)
);

    adder #(WIDTH) pc_adder2(
    .a(pc_plus2),             
    .b(sign_imm_shifted),          
    .enable(1'b1),      
    .reset(1'b0),       
    .cin(1'b0),         
    .S(pc_branch),      
    .Cout()           
    );
    
    mux2 #(WIDTH) pc_branch_mux(
    .a(pc_plus2),
    .b(pc_branch),
    .sel(pcsrc),
    .enable(1'b1),
    .y(pc_br_next)
    );

    assign shifted_instr = instr << 2;
    assign jump_target_address = {pc_plus2[15:12], shifted_instr[15:0]};

    mux2 #(WIDTH) pc_jump_mux(
    .a(pc_br_next),
    .b(jump_target_address),
    .sel(jump),
    .enable(1'b1),
    .y(pc_next)
    );
   
   //mux2 #(WIDTH) pc_jump_mux(pc_br_next, {pc_plus2[15:12], instr[11:0], 2'b00}, jump, pc_next);

    // Register file logic

    regfile #(WIDTH) register_file(
    .clock(clk),
    .write_enable(regwrite),
    .read_address1(instr[11:8]), 
    .read_address2(instr[7:4]),
    .write_address(writereg),
    .write_data(alu_result),
    .read_data1(src_a),
    .read_data2(writedata)
    );

    mux2 #(4) write_reg_mux(
    .a(instr[7:4]),  
    .b(instr[3:0]),   
    .sel(regdst),
    .enable(1'b1),  
    .y(writereg)    
);

    mux2 #(WIDTH) result_mux(
    .a(aluout),      
    .b(readdata),    
    .sel(memtoreg), 
    .enable(1'b1),   
    .y(alu_result)  
);

//signext sign_extender(
  //  .in(instr[15:0]),
   // .enable(1'b1),
   // .out(sign_imm)
//);
//dont need sign extend bc we are staying in 16b right?

mux2 #(WIDTH) src_b_mux(
    .a(writedata),   
    .b(sign_imm),    
    .sel(alusrc),  
    .enable(1'b1),   
    .y(src_b)    
);

alu alu_unit(
    .alu_control(alucontrol),
    .A(src_a),
    .B(src_b),
    .alu_result(aluout),
// need a clock in ALU??
    .Zero(zero)
);

endmodule

`endif // DATAPATH
