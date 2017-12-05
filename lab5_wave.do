onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab5_testbench/USERID
add wave -noupdate /lab5_testbench/ADDRESS_WIDTH
add wave -noupdate /lab5_testbench/DATA_WIDTH
add wave -noupdate /lab5_testbench/CLOCK_PERIOD
add wave -noupdate /lab5_testbench/address
add wave -noupdate /lab5_testbench/data_in
add wave -noupdate /lab5_testbench/bytemask
add wave -noupdate /lab5_testbench/write
add wave -noupdate /lab5_testbench/start_access
add wave -noupdate /lab5_testbench/access_done
add wave -noupdate /lab5_testbench/data_out
add wave -noupdate /lab5_testbench/clk
add wave -noupdate /lab5_testbench/reset
add wave -noupdate /lab5_testbench/cycles
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/MODEL_NUMBER
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/DMEM_ADDRESS_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/RANDOM_BITS
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/SCRAMBLE1
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/SCRAMBLE2
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_ADDRESS_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_ADDRESS_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_ADDRESS_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/MM_ADDRESS_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1out_WRITE_BUFFER
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_PRESENT
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2out_WRITE_BUFFER
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3out_WRITE_BUFFER
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_DATA_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_BLOCKSIZE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_DATA_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_BLOCKSIZE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_DATA_WIDTH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_BLOCKSIZE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/MM_BLOCKSIZE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_HIT_TIME
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_HIT_TIME
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_HIT_TIME
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/MM_DELAY
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_NUM_BLOCKS
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_NUM_BLOCKS
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_NUM_BLOCKS
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_ASSOC_TEMP
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_ASSOCIATIVITY
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_ASSOC_TEMP
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_ASSOCIATIVITY
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_ASSOC_TEMP
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_ASSOCIATIVITY
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_LRU
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_WRITE_THROUGH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L1_WRITE_ALLOCATE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_LRU
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_WRITE_THROUGH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L2_WRITE_ALLOCATE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_LRU
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_WRITE_THROUGH
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/L3_WRITE_ALLOCATE
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/clk
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/reset
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1_int_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l1out_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2_int_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l2out_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3in_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3_int_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/l3out_data_out
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_address
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_data_in
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_bytemask
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_write
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_start_access
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_access_done
add wave -noupdate -expand -group Internals /lab5_testbench/dut/dmem/mm_data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {120000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 5000
configure wave -gridperiod 10000
configure wave -griddelta 4
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {53919089 ps} {54824305 ps}
