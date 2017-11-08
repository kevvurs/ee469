# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./zeroFlagCheck.sv"
vlog "./full_adder.sv"
vlog "./Big64full_adder.sv"
vlog "./bw_or.sv"
vlog "./bw_and.sv"
vlog "./bw_xor.sv"
vlog "./mux2_1.sv"
vlog "./Big64mux2_1.sv"
vlog "./Big64mux8_1.sv"
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./cpu.sv"
vlog "./math.sv"
vlog "./n_mux2_1.sv"
vlog "./instr_decoder.sv"
vlog "./sign_extend.sv"
vlog "./program_counter.sv"
vlog "./register.sv"
vlog "./datamem.sv"
vlog "./Big64mux8_1.sv"
vlog "./Big64mux2_1.sv"
vlog "./Big64mux8_1.sv"
vlog "./transposer.sv"
vlog "./prepend.sv"
vlog "./Reg_Create.sv"
vlog "./regfile.sv"
vlog "./instructmem.sv"
vlog "./Decoder.sv"
vlog "./Mem_create.sv"
vlog "./mux_64by_32.sv"
vlog "./D_FF.sv"
vlog "./mux32_1.sv"
vlog "./mux4_1.sv"
vlog "./mux2_1.sv"
vlog "./sign_extend_unsigned.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_testbench

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
