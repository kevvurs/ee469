# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./full_adder.sv"
vlog "./Big64full_adder.sv"
vlog "./full-subtractor.sv"
vlog "./Big64full_subtractor.sv"
vlog "./bw_or.sv"
vlog "./bw_and.sv"
vlog "./bw_xor.sv"
vlog "./mux2_1.sv"
vlog "./Big64mux2_1.sv"
vlog "./Big64mux8_1.sv"
vlog "./alu.sv"
vlog "./alustim.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work alustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do alustim_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
