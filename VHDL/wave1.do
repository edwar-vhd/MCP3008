onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider Input_Chanels
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(0)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(1)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(2)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(3)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(4)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(5)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(6)
add wave -noupdate -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_tb/ch(7)

add wave -noupdate -divider Input_Control
add wave -noupdate -label Chip_Select -color "Orange" -radix binary	/MCP3008_tb/cs
add wave -noupdate -label Clock -color "Orange" -radix binary /MCP3008_tb/clk
add wave -noupdate -label Serial_Data_In -radix binary	/MCP3008_tb/d_i


add wave -noupdate -divider Output_Data
add wave -noupdate -label Serial_Data_Out -radix binary	/MCP3008_tb/d_o