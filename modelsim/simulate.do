onbreak {quit -f}
onerror {quit -f}

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

add wave  -r /*
add wave /glbl/GSR

run -all

quit -force
