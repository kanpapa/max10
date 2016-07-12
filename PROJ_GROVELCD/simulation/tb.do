# Echoing of Commands Executed in a Macro File
transcript on

# if Design Unit Exists, Delete the Design Unit from a Specified Library.
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}

# Creat a Design Library
vlib rtl_work

# Define a Mapping between a Logical Library Name and a Directory
vmap work rtl_work

# Compile HDL Source
vlog +define+SIMULATION      \
    -vlog01compat -work work \
    +incdir+../../../FPGA    \
    ../../../FPGA/FPGA.v     \
    ../../../FPGA/PLL.v      \
    ../../../FPGA/simulation/modelsim/tb.v

# Invoke VSIM Simulator
vsim -L altera_mf_ver -c work.tb

# Prepare Wave Display
add wave -divider TESTBENCH
add wave -hex sim:/tb/clk48
add wave -hex sim:/tb/clk
add wave -hex sim:/tb/tb_cycle_counter

add wave -divider COUNTER
add wave -dec sim:/tb/uFPGA/pcnt
add wave -dec sim:/tb/uFPGA/hcnt

add wave -divider LCD_CONTROL
add wave -hex sim:/tb/uFPGA/clk
add wave -hex sim:/tb/uFPGA/hsync
add wave -hex sim:/tb/uFPGA/vsync
add wave -hex sim:/tb/uFPGA/de
add wave -hex sim:/tb/uFPGA/rev
add wave -hex sim:/tb/uFPGA/stby

add wave -divider LCD_DATA
add wave -hex sim:/tb/uFPGA/r
add wave -hex sim:/tb/uFPGA/g
add wave -hex sim:/tb/uFPGA/b


# Logging all Signals in WLF file
log -r *

# Run Simulation until $stop or $finish
run -all
