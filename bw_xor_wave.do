onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Blue -label a /bw_xor_testbench/a
add wave -noupdate -color Blue -label b /bw_xor_testbench/b
add wave -noupdate -color Violet -label c /bw_xor_testbench/c
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 128
configure wave -valuecolwidth 40
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
WaveRestoreZoom {65606 ps} {101811 ps}
