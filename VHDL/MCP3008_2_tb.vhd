----------------------------------------------------------------------------------------
-- University: Universidad Pedagógica y Tecnológica de Colombia
-- Author: Edwar Javier Patiño Núñez
--
-- Create Date: 30/08/2020
-- Project Name: MCP3008_tb
----------------------------------------------------------------------------------------
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.pkg.all;

entity MCP3008_2_tb is
end entity;

architecture behav of MCP3008_2_tb is
	constant bits_int		:natural := 3;
	constant bits_res		:natural := 8;
	
	signal ch				:vec(7 downto 0):=(others=>0);
	signal clk				:std_logic:='1';
   signal cs				:std_logic:='1';
   signal d_i				:std_logic:='X';
   signal vref				:natural:=1280;	-- 5V
			
   signal d_o				:std_logic;
	signal d_o_reg_aux	:std_logic_vector(10 downto 0):=(others=>'0');
	signal d_o_reg			:std_logic_vector(9 downto 0):=(others=>'0');
	
	signal data_input		:std_logic_vector(4 downto 0):="00111";	-- chanel 4;
	
	-- Testbench internal signals for read file
	file vector_data_00	:text;
begin
	---------------------------------------------------------
	-- Instantiate and map the design under test 
	---------------------------------------------------------	
	DUT: entity work.MCP3008
		generic map(
			bits_res	=> bits_res
		)
		port map(
			ch		=> ch,
		   clk	=> clk,
		   cs		=> cs,
		   d_i	=> d_i,
		   vref	=> vref,

		   d_o	=> d_o
		);
		
	---------------------------------------------------------------------------
	-- These process reads the file "sine.txt" found in the simulation project area.
	-- It will read the data and send it as input data to the ADC.
	---------------------------------------------------------------------------
	ch_4: process
		variable vect_line_data :line;
		variable data				:integer;
	begin
		file_open(vector_data_00, "sine.txt", read_mode);									-- Open the file
		while not endfile(vector_data_00) loop													-- Read while file is not finished
			readline(vector_data_00, vect_line_data);											-- Read a line
			read(vect_line_data, data);															-- Read the value
			ch(4) <= to_integer(to_unsigned(data, 1 + bits_int + bits_res));			-- Value type conversion
			wait for 500 ns;																			-- Signal at 20KHz
		end loop;
		file_close(vector_data_00);																-- Close the file
	end process;
		
	clock: process
	begin
		wait for 270 ns;
		cs <= '0';
		
		for i in 0 to 34-1 loop
			clk <= not clk;
			wait for 140 ns;
		end loop;
		
		cs <= '1';
	end process;
		
	config: process
	begin
		wait for 270 ns;
		
		for i in 0 to 4 loop
			d_i <= data_input(i);
			wait for 280 ns;
		end loop;
		
		d_i <= 'X';
		
		wait for 3360 ns;
	end process;
	
	reg_out: process
	begin
		wait until d_o = '0';
		
		for i in 10 downto 0 loop
			wait until rising_edge(clk);
			d_o_reg_aux(i) <= d_o;
		end loop;		
		
		wait until d_o = 'Z';
		d_o_reg <= d_o_reg_aux(9 downto 0);
		d_o_reg_aux <= (others=>'0');
	end process;
end architecture;