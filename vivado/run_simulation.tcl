# Run after create_project.tcl.
set_property top tb_riscv_gpu_soc [get_filesets sim_1]
update_compile_order -fileset sim_1
launch_simulation
# GPU rectangle requires >52 us at one pixel/100 MHz; 100 us is enough.
run 100 us
