//////////////////////////////////////////////////////////////////////////////////
// The Cooper Union
// ECE 251 Spring 2024
// Engineer: Isabel Zulawski and Siann Han
// 
//     Create Date: 2024-05-01
//     Module Name: tb_datapath
//     Description: Test bench for datapath
//
// Revision: 1.0
//
//////////////////////////////////////////////////////////////////////////////////
/*
`ifndef TB_DATAPATH
`define TB_DATAPATH

`timescale 1ns/100ps


module datapath_tb;

    parameter WIDTH = 16;
    reg clk;         
    reg reset;       
    reg memtoreg;    
    reg pcsrc;       
    reg alusrc;      
    reg regdst;     
    reg regwrite;   
    reg jump;      
    reg [3:0] alucontrol;  
    wire zero;       
    wire [WIDTH-1:0] pc;  
    reg [WIDTH-1:0] instr; 
    wire [WIDTH-1:0] aluout;  
    wire [WIDTH-1:0] writedata;  
    reg [WIDTH-1:0] readdata; 
    output logic [15:0] read_data1;
    output logic [15:0] read_data2;

    datapath #(WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .zero(zero),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata));
        
    regfile #(WIDTH, 4) reg_file (
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; //  10ns period
    end


    initial begin
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 4'b0000; // initial ALU control (AND operation)
        instr = 16'h0000; // initial instruction
        readdata = 16'h0000; // initial read data

          #10;
        reset = 0; 
        //Test case: ALU operation (AND)
        alucontrol = 4'd0; // AND op
        instr = 16'h1234; // Sample instruction
        readdata = 16'hFFFF; // Sample read data
        memtoreg = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 1;
        #10;
        $display("Test 1: AND operation");
        $display("Read data: %h, PC: %h, ALU out: %h, Write data: %h, Zero: %b", readdata, pc, aluout, writedata, zero); 

       //SUB
        alucontrol = 4'b0110; 
        instr = 16'h1234;  
        // Assuming '12' is the source register and '34' is the destination register

    regwrite = 1; // Enable writing back to the register file
    regdst = 0; // Use 'instr[7:4]' as the write destination
    alusrc = 0; // Use `writedata` (another register file output) as `src_b`
    memtoreg = 0; // Assume you want the ALU output
    // Perform the test and observe the results
    #10;
    $display("PC: %h, ALU out: %h, Write data: %h, Zero: %b", pc, aluout, writedata, zero);

        // - OR operation
        // - ADD operation
        // - SUB operation
        // - MUL operation
        // - Memory operations 
        // - Branching operations


        $finish;  
    end

endmodule

`endif  
*/

`timescale 1ns/100ps

`include "datapath.sv"

module datapath_tb;

    // Parameter for data width
    parameter WIDTH = 16;

    // Testbench signals
    logic clk;
    logic reset;
    logic memtoreg;
    logic pcsrc;
    logic alusrc;
    logic regdst;
    logic regwrite;
    logic jump;
    logic [3:0] alucontrol;
    logic zero;
    logic [WIDTH-1:0] pc;
    logic [WIDTH-1:0] instr;
    logic [WIDTH-1:0] aluout;
    logic [WIDTH-1:0] writedata;
    logic [WIDTH-1:0] readdata;

    // Instantiate the datapath module
    datapath #(WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .zero(zero),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    // Test scenario
    initial begin
        // Initialize signals
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 4'b0000; // Adjust as per your ALU control scheme
        instr = 16'b0000_0000_0000_0000; // Initial instruction (modify as necessary)
        readdata = 16'd0; // Initial data memory read data

        // Release reset after 20 ns
        #20 reset = 0;

        // Test Case 1: Simple ALU operation (e.g., add)
        // Modify the test cases according to your instruction set and ALU operations
        instr = 16'b0001_0001_0010_0000; // Example instruction (modify as per your instruction set)
        alucontrol = 4'b0000; // ALU control for and operation
        alusrc = 0; // Use register data as ALU source
        regwrite = 1; // Enable register write
        memtoreg = 0; // Use ALU output as write data
        readdata = 16'd0; // No data memory read data
        #10;

        // Verify output
        // Add assertions and checks for expected behavior

        // Additional test cases for different operations and scenarios
        // ...

        // End the simulation
        #100 $finish;
    end

    // Display changes on every clock cycle
    always @(posedge clk) begin
        $display("Time: %0dns, PC: %h, ALUOut: %h, WriteData: %h, ReadData: %h, Zero: %b",
                 $time, pc, aluout, writedata, readdata, zero);
    end

endmodule
