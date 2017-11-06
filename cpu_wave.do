onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_testbench/clk
add wave -noupdate /cpu_testbench/reset
add wave -noupdate -childformat {{{/cpu_testbench/dut/registerFile/mainMem/q[6]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[5]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[4]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[3]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[2]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[1]} -radix decimal} {{/cpu_testbench/dut/registerFile/mainMem/q[0]} -radix decimal}} -expand -subitemconfig {{/cpu_testbench/dut/registerFile/mainMem/q[6]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[5]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[4]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[3]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[2]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[1]} {-height 15 -radix decimal} {/cpu_testbench/dut/registerFile/mainMem/q[0]} {-height 15 -radix decimal}} /cpu_testbench/dut/registerFile/mainMem/q
add wave -noupdate /cpu_testbench/dut/mainALU/result
add wave -noupdate /cpu_testbench/dut/controls/instruction
add wave -noupdate /cpu_testbench/dut/mainALU/A
add wave -noupdate /cpu_testbench/dut/mainALU/B
add wave -noupdate /cpu_testbench/dut/FlagRegister/q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28260026 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 341
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {13918750 ps} {74293750 ps}
