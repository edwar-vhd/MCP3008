# Close current simulation
quit -sim

# File names
set file MCP3008
set file_tb MCP3008_1_tb
set file_w wave1

exec vlib work
set vhdls [list \
	"./$file.vhd" \
	"./$file_tb.vhd" \
	]

# Compile files	
foreach src $vhdls {
	if [expr {[string first # $src] eq 0}] {puts $src} else {
		vcom -93 -work work $src
	}
}

# Load Design
vsim -voptargs=+acc work.$file_tb

# Load waveforms
do $file_w.do

# Run simulation
run 10060 ns
