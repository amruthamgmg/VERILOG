vlib work
#compilation (testbench)
vlog fulladder_tb.v  
#elaboration
vsim -novopt -suppress 12110 tb
#adding wave
add wave -position insertpoint sim:/tb/*
#run
run -all
