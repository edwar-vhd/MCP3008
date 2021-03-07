----------------------------------------------------------------------------------------
-- University: Universidad Pedagógica y Tecnológica de Colombia
-- Author: Edwar Javier Patiño Núñez
--
-- Create Date: 30/08/2020
-- Project Name: MCP3008_1_tb
----------------------------------------------------------------------------------------
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg.all;

entity MCP3008_1_tb is
end entity;

architecture behav of MCP3008_1_tb is
	constant bits_int		:natural := 3;
	constant bits_res		:natural := 8;
	
	signal ch				:vec(7 downto 0):=(others=>0);
	signal clk				:std_logic:='1';
   signal cs				:std_logic:='1';
   signal d_i				:std_logic:='X';
   signal vref				:natural:=1280;	-- 5V
			
   signal d_o				:std_logic;
	
	signal data_input		:std_logic_vector(4 downto 0):="00111";
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
	
	ch(4) <= 853;	-- 10/3 V
	ch(2) <= 512;	-- 2V
	
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
	
	data_input <= "01011" after 5030 ns;
	
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
end architecture;