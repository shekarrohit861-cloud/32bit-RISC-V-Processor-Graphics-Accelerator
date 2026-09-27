create_project riscv_gpu_artix7 ./riscv_gpu_artix7 -part xc7a100tcsg324-1 -force
add_files [glob ./rtl/riscv/*.v]
add_files [glob ./rtl/gpu/*.v]
add_files [glob ./rtl/memory/*.v]
add_files [glob ./rtl/peripherals/*.v]
add_files [glob ./rtl/soc/*.v]
add_files [glob ./rtl/top/*.v]
add_files -fileset sim_1 [glob ./sim/*.v]
add_files -fileset constrs_1 ./constraints/nexys_a7_100t.xdc
set_property top nexys_a7_top [current_fileset]
set_property top tb_nexys_a7_top [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
