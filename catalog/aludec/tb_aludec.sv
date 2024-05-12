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

`timescale 1ns/100ps

`include "aludec.sv"

module tb_aludec;
    reg [1:0] op;
    reg [5:0] funct;
    wire [3:0] alu_control;

    aludec dut(
        .op(op),
        .funct(funct),
        .alu_control(alu_control)
    );

    task display_results;
        input [1:0] test_op;
        input [5:0] test_funct;
        input [3:0] expected_control;
        input [3:0] actual_control;
        begin
            $display("Op: %b, Funct: %b, Expected ALU Control: %b, Actual ALU Control: %b", test_op, test_funct, expected_control, actual_control);
        end
    endtask

    initial begin
        // Test cases here
        op = 2'b00; funct = 6'b100000; // ADD
        #10; display_results(op, funct, 4'b0010, alu_control);

        op = 2'b01; funct = 6'b100010; // SUB
        #10; display_results(op, funct, 4'b0110, alu_control);

        op = 2'b10; funct = 6'b101010; // SLT
        #10; display_results(op, funct, 4'b0111, alu_control);

        // Add more test cases as needed

        $finish;
    end
endmodule

`endif // TB_ALUDEC
