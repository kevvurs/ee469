# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./main_memory.svp"
vlog "./write_buffer.svp"
vlog "./cache.svp"
vlog "./DataMemory.svp"
vlog "./lab5.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work lab5_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do lab5_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
