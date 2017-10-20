onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /Big64full_subtractor_testbench/a
add wave -noupdate -radix decimal /Big64full_subtractor_testbench/b
add wave -noupdate /Big64full_subtractor_testbench/difference
add wave -noupdate /Big64full_subtractor_testbench/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7230682 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 267
configure wave -valuecolwidth 210
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
WaveRestoreZoom {0 ps} {8575 ns}
