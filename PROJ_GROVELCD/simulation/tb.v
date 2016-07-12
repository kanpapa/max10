//===========================================================
// AKIZUKI Grove LCD Project
//-----------------------------------------------------------
// File Name   : tb.v
// Description : Test Bench
//-----------------------------------------------------------
// History :
// Rev.01 2016.07.12 @kanpapa beta release
//-----------------------------------------------------------
// Copyright (C) 2016 @kanpapa
//===========================================================

`timescale 1ns/1ns     // time per unit / accuracy
`define TB_CYCLE 20.83  //20.83ns (48MHz)
`define TB_FINISH_COUNT 200000 //cyc

module tb();

//-------------------------------
// Generate Clock
//-------------------------------
reg clk48;
//
initial clk48 = 1'b0;
always #(`TB_CYCLE / 2) clk48 = ~clk48;

//----------------------
// Cycle Counter
//----------------------
wire clk; // FPGA internal clock
reg  [31:0] tb_cycle_counter; // cycle counter for test bench
//
assign clk = uFPGA.clk;
initial tb_cycle_counter = 32'h0; // initialize cycle counter
//
always @(posedge clk)
begin
    tb_cycle_counter <= tb_cycle_counter + 32'h1;
end
//
always @*
begin
    if (tb_cycle_counter == `TB_FINISH_COUNT)
    begin
        $display("***** SIMULATION TIMEOUT ***** at %d", tb_cycle_counter);
        $stop; // abort simulation
    end
end

//------------------------------
// Initialize Nodes at Power Up
//------------------------------
initial
begin
    uFPGA.por_n = 1'b0;
    uFPGA.por_count = 16'h0000;
end

//--------------------------
// FPGA under Verification
//--------------------------
//wire [2:0] led;
//
//wire hsync;      // HSYNC
//wire vsync;      // YSYNC
//wire de;	 // DE
//
FPGA uFPGA
(
    .clk48 (clk48), // 48MHz Clock
    .hsync (hsync),
    .vsync (vsync),
    .de (de),
    .r (r),
    .g (g),
    .b (b),
    .rev (rev),
    .stby (stby)
);

//===========================================================
endmodule
//===========================================================
