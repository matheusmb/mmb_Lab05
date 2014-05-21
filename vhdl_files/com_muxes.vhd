-- File: com_muxes
-- Desc: Common Muxes used by other entities

-- BEGIN ENTITY DECLARATIONS --


-- ENTITY mux4to1

library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
	port(
		a, b, c, d  : in std_logic_vector(13 downto 0); -- 4 channels of 14 bits each
		muxSel : in std_logic_vector(1 downto 0);
		muxOut : out std_logic_vector(13 downto 0)		
	);
end entity mux4to1;


-- ENTITY mux16to1

library ieee;
use ieee.std_logic_1164.all;

entity mux16to1 is
	Port(
		  x0,  x1,  x2,  x3,
		  x4,  x5,  x6,  x7,
	     x8,  x9, x10, x11,
		 x12, x13, x14, x15 : in std_logic_vector(13 downto 0); -- 16 channels of 14 bits each
		 
		 muxSel : in std_logic_vector(3 downto 0);
		 muxOut : out std_logic_vector(13 downto 0)		
	);
end entity mux16to1;


-- ENTITY mux2to1

library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
	port(
		a, b	 : in std_logic_vector(13 downto 0);
		muxSel : in std_logic;
		muxOut : out std_logic_vector(13 downto 0)		
	);
end entity mux2to1;


-- END ENTITY DECLARATIONS --



-- BEGIN ARCHITECTURE IMPLEMENTATIONS --

-- ARCHITECTURE for mux4to1
architecture mux_arch4 of mux4to1 is
begin
	with muxSel select
		muxOut <= d when "00",
					 a when "01",
					 b when "10",
					 c when "11",  
					 d when others;
end architecture mux_arch4;
	


-- ARCHITECTURE for mux2to1
architecture mux_arch2 of mux2to1 is
begin
	with muxSel select
		muxOut <= a when '0',
					 b when '1',					  
					 a when others;
end architecture mux_arch2;


-- ARCHITECTURE for mux16to1
architecture mux_arch16 of mux16to1 is
begin
	with muxSel select
		muxOut <=  x0 when "0000",
					  x1 when "0001",
					  x2 when "0010",
					  x3 when "0011",
					  x4 when "0100",
					  x5 when "0101",
					  x6 when "0110",
					  x7 when "0111",
					  x8 when "1000",
					  x9 when "1001",
					 x10 when "1010",
					 x11 when "1011",
					 x12 when "1100",
					 x13 when "1101",
					 x14 when "1110",
					 x15 when "1111",
					  x0 when others;	-- default x0				  
end architecture mux_arch16;
			