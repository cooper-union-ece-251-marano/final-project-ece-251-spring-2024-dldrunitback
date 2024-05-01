//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski & Siann Han
// 
//     Create Date: 2024-05-28
//     Module Name: aludec
//     Description: 16-bit RISC ALU decoder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`ifndef ALUDEC
`define ALUDEC

module aludec
    //#(parameter n = 32) should this be parameterized?
    (
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
     input [3:0] op, 
     input [5:0] funct,
    output reg [3:0] alu_control
);

    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //
//based on ALU ordering from design attached to ALU module
    always @(*) begin
        case (funct)
            6'b100100: alu_control = 4'b0000; // AND 
            6'b100101: alu_control = 4'b0001; // OR 
            6'b100000: alu_control = 4'b0010; // ADD 
            6'b100010: alu_control = 4'b0110; // SUB 
            6'b101010: alu_control = 4'b0111; // SLT 
            6'b100111: alu_control = 4'b0011; // NOR
          	//6'b00000: alu_control = 4'b1000; // none
            6'b011000: alu_control = 4'b1001; // MUL 
            6'b000000: alu_control = 4'b1010; // SLL 
            // 4'b1011: alu_control = 4'b1011; // SGT - not in mips, make up funct if necessary later 
            //4'b1100: alu_control = 4'b1100; // CLO/CLZ - not in mips, make up funct if necessary later 
            6'b000010: alu_control = 4'b1101; // ROTR/SRL 
            6'b100110: alu_control = 4'b0100; // XOR 
            6'b101011: alu_control = 4'b1110; // SLTU 
          	//4'b0101: alu_control = 4'b0101; // sign ext - not in mips, make up funct if necessary later 
            6'b000011: alu_control = 4'b1111; // SRA 
            default: alu_control = 4'b0010; // Default to ADD operation
        endcase
    end

endmodule

`endif // ALUDEC
