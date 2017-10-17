onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Gold -label sel -radix unsigned /Big64mux8_1_testbench/sel
add wave -noupdate -color Blue -label in0 -radix hexadecimal /Big64mux8_1_testbench/in0
add wave -noupdate -color Blue -label in1 -radix hexadecimal /Big64mux8_1_testbench/in1
add wave -noupdate -color Blue -label in2 -radix hexadecimal /Big64mux8_1_testbench/in2
add wave -noupdate -color Blue -label in3 -radix hexadecimal /Big64mux8_1_testbench/in3
add wave -noupdate -color Blue -label in4 -radix hexadecimal /Big64mux8_1_testbench/in4
add wave -noupdate -color Blue -label in5 -radix hexadecimal /Big64mux8_1_testbench/in5
add wave -noupdate -color Blue -label in6 -radix hexadecimal /Big64mux8_1_testbench/in6
add wave -noupdate -color Blue -label in7 -radix hexadecimal /Big64mux8_1_testbench/in7
add wave -noupdate -color {Medium Orchid} -label out -radix hexadecimal /Big64mux8_1_testbench/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {190670 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1008 ns}
