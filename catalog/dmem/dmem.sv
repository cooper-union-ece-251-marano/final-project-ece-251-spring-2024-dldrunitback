//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//     Module Name: dmem
//     Description: 16-bit RISC memory ("data" segment)
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 100ps

`ifndef DMEM
`define DMEM

module dmem
    #(parameter ADDR_WIDTH = 6, DATA_WIDTH = 16)(
    input  logic clk,
    input  logic write_enable,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] writedata,
    output logic [DATA_WIDTH-1:0] readdata
);

    // Define memory space
    logic [DATA_WIDTH-1:0] RAM[(2**ADDR_WIDTH)-1:0];

    // Handle memory read
    assign readdata = RAM[addr];

    // Handle memory write on positive clock edge
    always @(posedge clk) begin
        if (write_enable) begin
            RAM[addr] <= writedata;
        end
    end

endmodule

`endif // DMEM
