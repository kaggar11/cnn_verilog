onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_layer/x_dut/clk
add wave -noupdate /tb_conv_layer/x_dut/rst
add wave -noupdate /tb_conv_layer/x_dut/layer_done_out
add wave -noupdate /tb_conv_layer/x_dut/col
add wave -noupdate /tb_conv_layer/x_dut/row
add wave -noupdate /tb_conv_layer/x_dut/out_col
add wave -noupdate /tb_conv_layer/x_dut/out_row
add wave -noupdate /tb_conv_layer/x_dut/en_convolve
add wave -noupdate /tb_conv_layer/x_dut/layer_conv_done
add wave -noupdate /tb_conv_layer/x_dut/activated_feature
add wave -noupdate /tb_conv_layer/x_dut/feature_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1216783 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 166
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {8247750 ps}
