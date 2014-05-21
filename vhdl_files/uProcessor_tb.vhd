
library ieee;
use ieee.std_logic_1164.all;


entity uProcessor_tb is
end entity uProcessor_tb;


architecture tb_uProcessor of uProcessor_tb is
component uProcessor
	port(clk, clk2 : in std_logic;
		 rst : in std_logic);
end component uProcessor;
	
	signal clk_tb, clk2_tb, rst_tb : std_logic;	
begin
	uut : uProcessor
		port map(clk => clk_tb,
					clk2 => clk2_tb,
			     rst => rst_tb);
			     
	tb :
	process
		constant period : time := 10 ns;
	begin
		
		
		
		
		clk_tb <= '0';
		clk2_tb <= '0';
		rst_tb <= '1';
		
		wait for period;
	
		clk_tb <= '1';
		clk2_tb <= '1';
				
		wait for period;
		
		clk_tb <= '0';
		clk2_tb <= '0';

		wait for period;
		
		rst_tb <= '0';
		
		wait for 2*period;
		
	while TRUE loop
		clk2_tb <= '1';
		
		wait for period;
		
		clk_tb <= '1';
		
		wait for period;
		clk2_tb <= '0';
		
		wait for period;
		
		clk_tb <= '0';
		
		wait for period;
		
	end loop;
	
	
	end process tb;	
	
			     
	 
	
end architecture tb_uProcessor;