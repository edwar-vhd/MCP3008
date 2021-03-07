----------------------------------------------------------------------------------------
-- University: Universidad Pedagógica y Tecnológica de Colombia
-- Author: Edwar Javier Patiño Núñez
--
-- Create Date: 30/08/2020
-- Project Name: MCP3008
-- Description: 
-- 	This description emulates the behavior of the MCP3008 ADC converter
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package pkg is
  type vec is array (natural range <>) of natural;
end package;

package body pkg is
end package body;
----------------------------------------------------------------------------------------
library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg.all;

entity MCP3008 is
	generic(
		-- Values for input voltages
		bits_res		:natural := 8		-- Resolution bits
	);
	port(
		ch			:vec(7 downto 0):=(others=>0);
		clk		:in std_logic;		-- Max 3.6 MHz
		cs			:in std_logic;
		d_i		:in std_logic;
		vref		:in natural;
			
		d_o		:out std_logic
	);
end entity;

architecture behav of MCP3008 is
	signal d				:std_logic_vector(2 downto 0);
	
	-- Signals for FSM
	type state_type is (strt, cfg, spl, output);
	signal curr_state, nxt_state	:state_type;
	
	signal strt_s		:std_logic:='0';
	signal sgl			:std_logic:='0';
	
	signal ctr			:natural:=0;		-- Counter
	signal cfg_e		:std_logic:='0';	-- Configuration enable
	signal strt_e		:std_logic:='0';	-- Start enable
	signal spl_e		:std_logic:='0';	-- Sample enable
	signal output_e	:std_logic:='0';	-- Output enable
	
	-- Signals for conversion
	signal cnv			:std_logic_vector(9 downto 0):=(others=>'0');	-- Conversion
	signal dac			:natural;													-- DAC
	signal ch_aux		:natural;													-- Auxiliary for input data
begin
	---------------------------------------------------------
	-- FSM
	---------------------------------------------------------
	-- State transition logic
	process (clk, cs)
	begin
		if cs = '1' then
			curr_state <= strt;
		elsif falling_edge(clk) then
			curr_state <= nxt_state;
		end if;
	end process;
	
	-- Next state logic
	process(curr_state, ctr, strt_s)
	begin
		case curr_state is
			when strt =>
				if strt_s = '1' then
					nxt_state <= cfg;
				else
					nxt_state <= strt;
				end if;
				
			when cfg =>
				if ctr >= 3 then
					nxt_state <= spl;
				end if;
				
			when spl =>
				nxt_state <= output;
				
			when output =>
		end case;
	end process;
	
	-- Timer
	process(clk, cs)
	begin
		if cs = '1' then
			ctr <= 0;
		elsif (falling_edge(clk)) then
			if curr_state /= nxt_state then
				ctr <= 0;
			else
				ctr <= ctr + 1;
			end if;
		end if;
	end process;
	
	-- Output depends solely on the current state
	process (curr_state)
	begin
		case curr_state is
			when strt =>
				cfg_e <= '0';
				strt_e <= '1';
				spl_e <= '0';
				output_e <= '0';
				
			when cfg =>
				cfg_e <= '1';
				strt_e <= '0';
				spl_e <= '0';
				output_e <= '0';
				
			when spl =>
				cfg_e <= '0';
				strt_e <= '0';
				spl_e <= '1';
				output_e <= '0';
				
			when output =>
				cfg_e <= '0';
				strt_e <= '0';
				spl_e <= '0';
				output_e <= '1';
		end case;
	end process;
	
	start: process
	begin
		wait until rising_edge(strt_e);
		wait until falling_edge(cs);
		wait until rising_edge(clk);
		
		strt_s <= d_i;
		wait for 1 ns;
		
		if strt_s /= '1' then
			report "Wrong initialization bit" severity failure;
		end if;
		
		wait until rising_edge(clk);
		strt_s <= '0';
	end process;
	
	CSH: process
	begin
		wait until curr_state = strt;
		wait for 270 ns;
			
		if cs = '0' then
			report "Wrong time in CSH" severity failure;				
		end if;
	end process;
	
	config: process
	begin
		wait until rising_edge(cfg_e);
		wait until rising_edge(clk);
		
		sgl <= d_i;
		wait for 1 ns;
		
		if sgl /= '1' then
			report "Function not implemented: Differential input" severity error;
		end if;
		
		for i in 2 downto 0 loop
			wait until rising_edge(clk);
			d(i) <= d_i;
		end loop;		
	end process;
	
	sample: process
	begin
		wait until rising_edge(spl_e);
		cnv <= (others=>'0');
		wait for 10 ps;

		ch_aux <= ch(to_integer(unsigned(d)));
		wait for 10 ps;
		
		for i in 9 downto 0 loop
			cnv(i) <= '1';
			wait for 10 ps;
			
			-- Internal DAC
			dac <= (to_integer(unsigned(cnv))*vref)/1023;
			wait for 10 ps;
			
			if dac > ch_aux  then
				cnv(i) <= '0';
				wait for 10 ps;
			end if;
		end loop;
	end process;
	
	outcome: process
	begin
		d_o <= 'Z';
		wait until rising_edge(output_e);
		d_o <= '0';
		wait until falling_edge(clk);
		d_o <= cnv(9);
		for i in 8 downto 0 loop
			wait until falling_edge(clk);
			d_o <= cnv(i);
		end loop;
		wait until falling_edge(output_e);
	end process;
end architecture;