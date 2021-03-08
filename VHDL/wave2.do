onerror {resume}
quietly WaveActivateNextPane {} 0

add wave -noupdate -divider Input_Chanels
add wave -noupdate -format analog-step -height 50 -min 0 -max 1024 -label CH4 -color "Aquamarine" -radix decimal	/MCP3008_2_tb/ch(4)

add wave -noupdate -divider Input_Control
add wave -noupdate -label Chip_Select -color "Orange" -radix binary	/MCP3008_2_tb/cs
add wave -noupdate -label Clock -color "Orange" -radix binary /MCP3008_2_tb/clk
add wave -noupdate -label Serial_Data_In -radix binary	/MCP3008_2_tb/d_i


add wave -noupdate -divider Output_Data
add wave -noupdate -label Serial_Data_Out -radix binary	/MCP3008_2_tb/d_o
add wave -noupdate -format analog-step -height 50 -min 0 -max 1024 -label Reg_Data_Out -color #FF00FF -radix binary	/MCP3008_2_tb/d_o_reg