onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Pink /Big64mux2_1_testbench/sel
add wave -noupdate -color Blue -radix hexadecimal /Big64mux2_1_testbench/in0
add wave -noupdate -color Coral -radix hexadecimal /Big64mux2_1_testbench/in1
add wave -noupdate -color Green -radix hexadecimal /Big64mux2_1_testbench/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {81136 ps} 0}
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
WaveRestoreZoom {0 ps} {105 ns}
