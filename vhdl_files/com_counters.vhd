-- File: com_counters
-- Desc: Common Counters used by other entities

-- BEGIN ENTITY DECLARATIONS --


-- ENTITY counter2bi

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter2bit is
	port(
		clk, rst		:	in		std_logic;
		inc			:	in		std_logic;
		q				:	out	std_logic_vector(1 downto 0)
	);
end entity counter2bit;


-- ENTITY counter2bi
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter3bit is
	port(
		clk, rst		:	in		std_logic;
		inc			:	in		std_logic;
		q				:	out	std_logic_vector(2 downto 0)
	);
end entity counter3bit;


-- END ENTITY DECLARATIONS --



-- BEGIN ARCHITECTURE IMPLEMENTATIONS --

-- ARCHITECTURE for counter2bit
architecture arch_counter2bit of counter2bit is
		signal count	:	unsigned(1 downto 0) := (others => '0');
begin
	
	op	:
		process(clk, rst)
			variable v_count : unsigned(1 downto 0);
		begin
			if(rising_edge(clk)) then
				v_count	:=		count;
				
				if(rst = '1') then
					v_count := (others => '0');
				end if;
				
				if(inc = '1') then
					v_count := v_count + 1;
				end if; 
				
				count		<=		v_count;
			end if;
--			if(rst = '1') then
--				count <= (others => '0');
--			
--			elsif(rising_edge(clk) AND inc = '1') then
--				count <= count + 1;				
--			end if;				
		end process op;
		
		q <= std_logic_vector( count );	

end architecture arch_counter2bit;



-- ARCHITECTURE for counter3bit
architecture arch_counter3bit of counter3bit is
		signal count	:	unsigned(2 downto 0) := (others => '0');
begin
	
	op	:
		process(clk, rst)
			variable v_count : unsigned(2 downto 0);
		begin
			if(rising_edge(clk)) then
				v_count	:=		count;
				
				if(rst = '1') then
					v_count := (others => '0');
				end if;
				
				if(inc = '1') then
					v_count := v_count + 1;
				end if; 
				
				count		<=		v_count;
			end if;
--			if(rst = '1') then
--				count <= (others => '0');
--			
--			elsif(rising_edge(clk) AND inc = '1') then
--				count <= count + 1;				
--			end if;				
		end process op;
		
		q <= std_logic_vector( count );	

end architecture arch_counter3bit;