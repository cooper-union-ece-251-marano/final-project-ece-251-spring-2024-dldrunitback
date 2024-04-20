//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski & Siann Han
// 
//     Create Date: 2023-02-07
//     Module Name: alu
//     Description: 32-bit RISC-based CPU alu (MIPS)
//
// Revision: 1.0
// Based on https://github.com/Caskman/MIPS-Processor-in-Verilog/blob/master/ALU32Bit.v
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALU
`define ALU

`timescale 1ns/100ps

module ALU16Bit #(parameter n = 16) (
    //
    // ---------------- PORT DEFINITIONS ----------------
    //
    input [3:0] ALUControl, 
    input [n-1:0] A, B, 
    output reg [n-1:0] ALUResult, 
    output reg Zero // Zero=1 if ALUResult == 0
);
    //
    // ---------------- MODULE DESIGN IMPLEMENTATION ----------------
    //

    integer i;
    reg [n-1:0] y; // temp reg

    always @(ALUControl, A, B) begin
        case (ALUControl)
            0: ALUResult <= A & B; // AND
            1: ALUResult <= A | B; // OR
            2: ALUResult <= A + B; // ADD
            6: ALUResult <= A + (~B + 1); // SUB 
            7: ALUResult <= (A < B) ? 1 : 0; // SLT 
            3: ALUResult <= ~(A | B); // NOR
            9: ALUResult <= A * B; // MUL
            10: ALUResult <= A << B; // SLL 
            11: ALUResult <= (A > B) ? 1 : 0; // SGT 
            12: begin // CLO (Count Leading Ones) / CLZ (Count Leading Zeroes)
                integer count;
                ALUResult = 0;
                if (B == 0) begin // CLO
                    count = 0;
                    for (i = n - 1; i >= 0; i = i - 1) begin
                        if (A[i] == 1) begin
                            count = n - 1 - i;
                            ALUResult = count;
                            i = -1; // terminate loop
                        end
                    end
                end else begin // CLZ
                    count = 0;
                    for (i = n - 1; i >= 0; i = i - 1) begin
                        if (A[i] == 0) begin
                            count = n - 1 - i;
                            ALUResult = count;
                            i = -1; // terminate 
                        end
                    end
                end
            end
            13: begin // ROTR & SRL (rotate right / logical right shift)
                y = A;
                for (i = 0; i < B; i = i + 1) begin
                    if (B[n-1]) begin
                        // ROTR
                        y = {y[0], y[n-1:1]};
                    end else begin
                        // SRL
                        y = {1'b0, y[n-1:1]};
                    end
                end
                ALUResult = y;
            end
            4: ALUResult <= A ^ B; // XOR
            14: ALUResult <= A < B; // SLTU 
            5: begin // Sign Extension
                if (B == 0) begin // Byte (8-bit sign extension)
                    ALUResult <= {{8{A[7]}}, A[7:0]};
                end else if (B == 1) begin // Half-word (16-bit sign extension)
                    ALUResult <= {{8{A[15]}}, A[15:0]};
                end
            end
            15: ALUResult <= (A >> B) | ({n{A[n-1]}} << (n - B)); // SRA (Arithmetic right shift)
        endcase
    end

    // Check if ALUResult is zero 
    always @(ALUResult) begin
        Zero <= (ALUResult == 0) ? 1 : 0;
    end

endmodule

`endif // ALU
