alias clc ".main clear"

clc
exec vlib work
vmap work work

set TB					"<tb_module_name>"
set hdl_path			"../src/hdl"
set inc_path			"../src/inc"

set run_time			"-all"

#============================ Add verilog files  ===============================

vlog 	+acc -incr -source  +define+SIM 	$hdl_path/<file_name>.v

vlog 	+acc -incr -source  +incdir+$inc_path +define+SIM ./tb/<tb_file_name>.sv
onerror {break}

#================================ simulation ====================================

vsim	-voptargs=+acc -debugDB $TB

#======================= adding signals to wave window ==========================

add wave -hex -group 	 	{TB}				sim:/$TB/*
add wave -hex -group 	 	{top}				sim:/$TB/perm/*
add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================

configure wave -signalnamewidth 2

#====================================== run =====================================

run $run_time
