onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Blue -radix decimal /Big64full_adder_testbench/a
add wave -noupdate -color Blue -radix decimal /Big64full_adder_testbench/b
add wave -noupdate -color {Dark Orchid} -radix decimal /Big64full_adder_testbench/sum
add wave -noupdate -color Gold /Big64full_adder_testbench/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {107958899 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 169
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
WaveRestoreZoom {107958899 ps} {108439155 ps}
