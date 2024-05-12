////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//
// Module Name: tb_dmem
// Description: Test bench for data memory
//
// Revision: 1.0
//
////////////////////////////////////////////////////////////////////////////////
`ifndef TB_DMEM
`define TB_DMEM
`timescale 1ns / 100ps

module tb_dmem;

    parameter ADDR_WIDTH = 6;
    parameter DATA_WIDTH = 16;

    // Inputs
    reg clk = 0;
    reg write_enable;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] writedata;

    // Outputs
    wire [DATA_WIDTH-1:0] readdata;

    // Instantiate the Unit Under Test (UUT)
    dmem #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) uut (
        .clk(clk),
        .write_enable(write_enable),
        .addr(addr),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generation
    always #5 clk = !clk; // Generate a clock with a period of 10 ns

    // Test scenarios
    initial begin
        // Initialize inputs
        write_enable = 0;
        addr = 0;
        writedata = 0;

        // Wait for global reset
        #100;

        // Write Test
        write_enable = 1;
        addr = 5;
        writedata = 16'h1234;
        #10; // Wait a clock cycle for write

        write_enable = 0;
        #10; // Wait a clock cycle to stabilize

        // Read Test
        addr = 5;
        #10; // Wait a clock cycle for read

        // Check result
        if (readdata !== 16'h1234) begin
            $display("Test failed at addr %d: expected 0x1234, got %h", addr, readdata);
        end else begin
            $display("Test passed at addr %d: expected 0x1234, got %h", addr, readdata);
        end

        // End simulation
        $finish;
    end

endmodule

`endif // TB_DMEM
