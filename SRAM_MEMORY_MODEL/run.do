vlib work
vlog memory_tb.v
vsim tb +test_name=BDwr_BDrd
add wave -position insertpoint sim:/tb/*
add wave -r sim:/tb/*
run -all
