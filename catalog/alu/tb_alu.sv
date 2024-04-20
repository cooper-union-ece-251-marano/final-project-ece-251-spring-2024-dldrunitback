//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//     Create Date: 2023-02-07
//     Module Name: tb_alu
//     Description: Test bench for simple behavorial ALU
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`ifndef TB_ALU
`define TB_ALU

`include "alu.sv"

module ALU16Bit_tb;

    parameter n = 16; 
    reg [3:0] ALUControl;
    reg [n-1:0] A, B;
    wire [n-1:0] ALUResult;
    wire Zero;

    // Instantiate
    ALU16Bit #(n) uut (
        .ALUControl(ALUControl),
        .A(A),
        .B(B),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // display results
    task display_result;
        input [3:0] ALUControl;
        input [n-1:0] A, B, ALUResult;
        input Zero;
        begin
            $display("ALUControl: %b, A: %h, B: %h, ALUResult: %h, Zero: %b", ALUControl, A, B, ALUResult, Zero);
        end
    endtask

    // Tb
    initial begin
        // Test case: AND operation
        ALUControl = 4'd0; // ALUControl = 0 for AND
        A = 16'hAAAA; // Example input A
        B = 16'h5555; // Example input B
        #10; // Wait for 10 ns for the operation to take effect
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: OR operation
        ALUControl = 4'd1; // ALUControl = 1 for OR
        A = 16'h1234;
        B = 16'h5678;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: ADD operation
        ALUControl = 4'd2; // ALUControl = 2 for ADD
        A = 16'h1000;
        B = 16'h2000;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SUB operation
        ALUControl = 4'd6; // ALUControl = 6 for SUB
        A = 16'h2000;
        B = 16'h1000;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SLT operation
        ALUControl = 4'd7; // ALUControl = 7 for SLT
        A = 16'h1234;
        B = 16'h5678;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: NOR operation
        ALUControl = 4'd3; // ALUControl = 3 for NOR
        A = 16'hFFFF; // All bits set
        B = 16'h0000; // All bits cleared
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: MUL operation
        ALUControl = 4'd9; // ALUControl = 9 for MUL
        A = 16'h000F; // Example input A
        B = 16'h000A; // Example input B
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SLL operation
        ALUControl = 4'd10; // ALUControl = 10 for SLL
        A = 16'h0001; // Shift A left by B
        B = 16'h0004; // Shift amount
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SGT operation
        ALUControl = 4'd11; // ALUControl = 11 for SGT
        A = 16'h4321;
        B = 16'h1234;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: CLO/CLZ operation
        ALUControl = 4'd12; // ALUControl = 12 for CLO/CLZ
        A = 16'h00FF; // Example input A
        B = 16'h0; // CLO
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);
        // Test for CLZ
        B = 16'h1; // CLZ
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: ROTR & SRL operation
        ALUControl = 4'd13; // ALUControl = 13 for ROTR & SRL
        A = 16'h1234;
        B = 16'h0003; // Rotate or shift by 3
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: XOR operation
        ALUControl = 4'd4; // ALUControl = 4 for XOR
        A = 16'hF0F0;
        B = 16'h0F0F;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SLTU operation
        ALUControl = 4'd14; // ALUControl = 14 for SLTU
        A = 16'hFFFF;
        B = 16'h0000;
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: Sign Extension operation
        ALUControl = 4'd5; // ALUControl = 5 for Sign Extension
        A = 16'h00FF; // Example input A (byte to extend)
        B = 16'h0; // Extend byte
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);
        // Test for half-word
        B = 16'h1; // Extend half-word
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        // Test case: SRA operation
        ALUControl = 4'd15; // ALUControl = 15 for SRA
        A = 16'hF234; // Example input A
        B = 16'h0003; // Shift amount
        #10;
        display_result(ALUControl, A, B, ALUResult, Zero);

        $finish;
    end

endmodule
`endif // TB_ALU