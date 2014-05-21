library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.commonPkg.all;



entity mmb_sum2inp is
	port (
		a, b	:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		result:	out	std_logic_vector(REG_MAX_INDEX downto 0)
	);
end entity mmb_sum2inp;



architecture sum_arch of mmb_sum2inp is
begin
	
	result <= std_logic_vector( unsigned(a) + unsigned(b) );

end architecture sum_arch;