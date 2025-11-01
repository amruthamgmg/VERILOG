vlib work
vlog asyn_fifo_tb.v
vsim tb +test_name=CONCURRENT
add wave -position -insertpoint sim:/tb/dut/*
run -all
