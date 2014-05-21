library ieee;
use ieee.std_logic_1164.all;
use work.commonPkg.all;

entity register14b is
	Port(
		  din  : in std_logic_vector(REG_MAX_INDEX downto 0);
		  clk  : in std_logic;
		  rst  : in std_logic;
		  dout : out std_logic_vector(REG_MAX_INDEX downto 0)
	);
end entity register14b;


architecture register_arch of register14b is
	signal data : std_logic_vector(13 downto 0);
	begin
		ff : process(clk, rst)
		begin
			if(rst = '1') then
				data <= (others => '0');
			elsif(rising_edge(clk)) then
					data <= din;
			end if;
		end process;
		
		dout <= data;
			
	
end architecture register_arch;

library IEEE;
use IEEE.std_logic_1164.all;


entity triState is
	port(
		din  : in std_logic_vector(13 downto 0);
		s	  : std_logic;
		dout : out std_logic_vector(13 downto 0)
	);
end entity triState;

architecture triState_arch of triState is
begin
	with s select
	   dout  <=  din when '1',
	             (others => 'Z') when '0',
	             (others => 'Z') when others;  

end architecture triState_arch;	