//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski & Siann Han
// 
//     Create Date: 2024-05-28
//     Module Name: alu
//     Description: 16-bit RISC-based CPU alu (MIPS)
//
// Revision: 1.0
// Based on https://github.com/Caskman/MIPS-Processor-in-Verilog/blob/master/ALU32Bit.v
//////////////////////////////////////////////////////////////////////////////////
`ifndef ALU
`define ALU

`timescale 1ns/100ps

module alu #(parameter n = 16)(
    input wire clk, // Clock input
    input wire [3:0] alu_control,
    input wire [n - 1:0] A,
    input wire [n - 1:0] B,
    output reg [n - 1:0] alu_result,
    output reg Zero
);

    reg [n - 1:0] alu_result_next;
    reg Zero_next;

    always @* begin: loop
        case (alu_control)
            4'b0000: alu_result_next = A & B; // AND
            4'b0001: alu_result_next = A | B; // OR
            4'b0010: alu_result_next = A + B; // ADD
            4'b0110: alu_result_next = A + (~B + 1); // SUB
            4'b0111: alu_result_next = (A < B) ? 1 : 0; // SLT
            4'b0011: alu_result_next = ~(A | B); // NOR
            4'b1001: alu_result_next = A * B; // MUL
            4'b1010: alu_result_next = A << B; // SLL
            4'b1100: begin // CLO/CLZ
                integer count;
                if (B == 0) begin // CLO
                    count = 0;
                    for (integer i = n - 1; i >= 0; i--) begin
                        if (A[i] == 1) begin
                            count = n - 1 - i;
                            alu_result_next = count;
                            disable loop;
                        end
                    end
                end else begin // CLZ
                    count = 0;
                    for (integer i = n - 1; i >= 0; i--) begin
                        if (A[i] == 0) begin
                            count = n - 1 - i;
                            alu_result_next = count;
                            disable loop;
                        end
                    end
                end
            end
            4'b1101: begin // ROTR/SRL
                reg [n - 1:0] y;
                y = A;
                for (integer i = 0; i < B; i++) begin
                    if (B[n - 1]) begin
                        // ROTR
                        y = {y[0], y[n - 1:1]};
                    end else begin
                        // SRL
                        y = {1'b0, y[n - 1:1]};
                    end
                end
                alu_result_next = y;
            end
            4'b0100: alu_result_next = A ^ B; // XOR
            4'b1110: alu_result_next = A < B; // SLTU
            4'b1011: alu_result_next = (A > B) ? 1 : 0; // SGT
            4'b0101: begin // Sign Extension
                if (B == 0) begin // Byte (8-bit sign extension)
                    alu_result_next = {{8{A[7]}}, A[7:0]};
                end else if (B == 1) begin // Half-word (16-bit sign extension)
                    alu_result_next = {{8{A[15]}}, A[15:0]};
                end
            end
            4'b1111: alu_result_next = (A >> B) | ({n{A[n - 1]}} << (n - B)); // SRA (Arithmetic right shift)
            default: alu_result_next = 0; // Default case
        endcase

        Zero_next = (alu_result_next == 0);
    end
    
    always @(posedge clk) begin
        alu_result <= alu_result_next;
        Zero <= Zero_next;
    end

endmodule

`endif // ALU
