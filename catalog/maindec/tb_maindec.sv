//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
//
//     Module Name: tb_maindec
//     Description: Test bench for simple behavorial main decoder
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/100ps

module testbench;
    // Inputs
    reg [5:0] op;

    // Outputs
    wire memtoreg, memwrite;
    wire branch, alusrc;
    wire regdst, regwrite;
    wire jump;
    wire [1:0] aluop;

    // Instantiate the Unit Under Test (UUT)
    maindec uut (
        .op(op),
        .memtoreg(memtoreg), .memwrite(memwrite),
        .branch(branch), .alusrc(alusrc),
        .regdst(regdst), .regwrite(regwrite),
        .jump(jump),
        .aluop(aluop)
    );

    initial begin
        // Initialize Inputs
        op = 0;

        // Stimulus here
        $monitor("Time=%t op=%b -> regwrite=%b regdst=%b alusrc=%b branch=%b memwrite=%b memtoreg=%b jump=%b aluop=%b",
                 $time, op, regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop);

        // Test cases
        #5 op = 6'b000000; // RTYPE
        #5 op = 6'b100011; // LW
        #5 op = 6'b101011; // SW
        #5 op = 6'b000100; // BEQ
        #5 op = 6'b001000; // ADDI
        #5 op = 6'b000010; // J
        #5 op = 6'b111111; // Illegal operation
        #5 $finish;
    end
endmodule
