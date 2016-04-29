`define CYCLE_1SEC 48000000

//--------------------
// TOP of the FPGA
//--------------------
module FPGA
(
	input wire clk,	// 48MHz Clock
	input wire res_n,	// Reset Switch
	output wire [6:0] seg7	// 7SEG LED output
);

//-----------------------------
// Counter to make 1sec Period
//-----------------------------
reg	[31:0] counter_1sec;
wire			 period_1sec;
//
always @(posedge clk, negedge res_n)
begin
	if (~res_n)
		counter_1sec <= 32'h00000000;
	else if (period_1sec)
		counter_1sec <= 32'h00000000;
	else
		counter_1sec <= counter_1sec + 32'h00000001;
end
//
assign period_1sec = (counter_1sec == (`CYCLE_1SEC - 1));

//-------------------------------
// Counter to make LED signal
//-------------------------------
reg	[3:0] counter_bcd;
//
always @(posedge clk, negedge res_n)
begin
	if (~res_n)
		counter_bcd <= 4'b0000;
	else if (period_1sec)
		counter_bcd <= counter_bcd + 4'b0001;
end
//
//assign led = ~counter_led; // LED on by low level
assign seg7 = ~bcdto7seg(counter_bcd);

  function [6:0] bcdto7seg;
    input [3:0] counter_bcd;
    begin
      case (counter_bcd)
			4'b0000: bcdto7seg = 7'b1111110;  // 0
			4'b0001: bcdto7seg = 7'b0110000;  // 1
			4'b0010: bcdto7seg = 7'b1101101;  // 2
			4'b0011: bcdto7seg = 7'b1111001;  // 3
			4'b0100: bcdto7seg = 7'b0110011;  // 4
			4'b0101: bcdto7seg = 7'b1011011;  // 5
			4'b0110: bcdto7seg = 7'b1011111;  // 6
			4'b0111: bcdto7seg = 7'b1110000;  // 7
			4'b1000: bcdto7seg = 7'b1111111;  // 8
			4'b1001: bcdto7seg = 7'b1111011;  // 9
			4'b1010: bcdto7seg = 7'b1110111;  // A
			4'b1011: bcdto7seg = 7'b0011111;  // B
			4'b1100: bcdto7seg = 7'b1001110;  // C
			4'b1101: bcdto7seg = 7'b0111101;  // D
			4'b1110: bcdto7seg = 7'b1001111;  // E
			4'b1111: bcdto7seg = 7'b1000111;  // F
			default: bcdto7seg = 7'b0000000;  // X
      endcase
    end
  endfunction

endmodule
