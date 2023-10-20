/usr/local/mentor/modelsim-2019.1/modeltech/bin/vlib modelsim_lib/work
/usr/local/mentor/modelsim-2019.1/modeltech/bin/vlib modelsim_lib/msim

/usr/local/mentor/modelsim-2019.1/modeltech/bin/vlib modelsim_lib/msim/xil_defaultlib

/usr/local/mentor/modelsim-2019.1/modeltech/bin/vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

/usr/local/mentor/modelsim-2019.1/modeltech/bin/vlog -work xil_defaultlib  -incr -mfcu  -sv \
"../rtl/*.sv" \
"../rtl/fft/*.sv" \
"../tests/*.sv"


/usr/local/mentor/modelsim-2019.1/modeltech/bin/vlog -work xil_defaultlib \
"glbl.v"

