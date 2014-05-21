library IEEE;
use IEEE.std_logic_1164.all;
use work.commonPkg.all;


entity decoder1to3 is
	port(
		  a, b, c : out std_logic_vector(BUS_WIDTH-1 downto 0);
		  din 	 : in  std_logic_vector(BUS_WIDTH-1 downto 0);
		  chSel	 : in  std_logic_vector(2 downto 0)
	);
end entity decoder1to3;


architecture decoder1to3_arch of decoder1to3 is
begin

	with chSel(0) select
		a <= 	din 				 when '1',
				(others => 'Z') when others;
				
	with chSel(1) select
		b <= 	din 				 when '1',
				(others => 'Z') when others;
				
	with chSel(2) select
		c <= 	din 				 when '1',
				(others => 'Z') when others;				
		


end architecture decoder1to3_arch;