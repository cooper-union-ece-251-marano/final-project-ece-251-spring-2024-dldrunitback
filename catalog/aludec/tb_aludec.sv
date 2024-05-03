//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski & Siann Han
// 
//     Create Date: 2024-05-28
//     Module Name: tb_aludec
//     Description: Test bench for simple behavorial ALU decoder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

`ifndef TB_ALUDEC
`define TB_ALUDEC

`include "aludec.sv"

module tb_aludec;
    // DUT port definitions
    reg [3:0] op;
    reg [5:0] funct;
    wire [3:0] alu_control;
    reg [3:0] expected_controls [15:0];
    reg [3:0] expected_alu_control;

    aludec dut (
        .op(op),
        .funct(funct),
        .alu_control(alu_control)
    );

    task display_results;
        input [3:0] test_op;
        input [5:0] test_funct;
        input [3:0] expected_control;
        input [3:0] actual_control;
        begin
            $display("Op: %b, Funct: %b, Expected ALU Control: %b, Actual ALU Control: %b", test_op, test_funct, expected_control, actual_control);
        end
    endtask
    
    initial begin
    
        expected_controls[0] = 4'b0000; // AND
        expected_controls[1] = 4'b0001; // OR
        expected_controls[2] = 4'b0010; // ADD
        expected_controls[3] = 4'b0110; // SUB
        expected_controls[4] = 4'b0111; // SLT
        expected_controls[5] = 4'b0011; // NOR
        expected_controls[6] = 4'b1001; // MUL
        expected_controls[7] = 4'b1010; // SLL
        expected_controls[8] = 4'b1101; // ROTR/SRL
        expected_controls[9] = 4'b0100; // XOR
        expected_controls[10] = 4'b1110; // SLTU
        expected_controls[11] = 4'b1111; // SRA
        
       
        funct = 6'b100100; op = 4'b0000; expected_alu_control = 4'b0000;
        #10; display_results(op, funct, expected_alu_control, alu_control);

        funct = 6'b100101; op = 4'b0000; expected_alu_control = 4'b0001;
        #10; display_results(op, funct, expected_alu_control, alu_control);

        funct = 6'b100000; op = 4'b0000; expected_alu_control = 4'b0010;
        #10; display_results(op, funct, expected_alu_control, alu_control);
        
        funct = 6'b100010; op = 4'b0000; expected_alu_control = 4'b0110;
        #10; display_results(op, funct, expected_alu_control, alu_control);

        funct = 6'b101010; op = 4'b0000; expected_alu_control = 4'b0111;
        #10; display_results(op, funct, expected_alu_control, alu_control);

        funct = 6'b100111; op = 4'b0000; expected_alu_control = 4'b0011;
        #10; display_results(op, funct, expected_alu_control, alu_control);
        
        // Add more combinations of funct and op as necessary

        // Finish the simulation
        $finish;
    end
endmodule

`endif // TB_ALUDEC
