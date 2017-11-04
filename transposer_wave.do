onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Orange -label Db -radix hexadecimal /transposer_testbench/data
add wave -noupdate -color Orange -label Imm16 -radix hexadecimal /transposer_testbench/fixed
add wave -noupdate -color {Lime Green} -label SHAMT /transposer_testbench/shamt
add wave -noupdate -color {Lime Green} -label Z /transposer_testbench/clear
add wave -noupdate -color {Slate Blue} -label Result -radix hexadecimal /transposer_testbench/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30412 ps} 0}
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
WaveRestoreZoom {0 ps} {210 ns}
