-- File: iop_unit
-- Desc: Implements the I/O-P block

-- BEGIN ENTITY DECLARATIONS --


-- ENTITY iop_unit

library IEEE;

use IEEE.std_logic_1164.all;
use work.commonPkg.all;


entity iop_unit is
	port (
		A_bus, B_bus, C_bus 	: 	inout	std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst					:	in		std_logic;
		addr						:	in		std_logic_vector(IOP_ADDR_BITS-1 downto 0);
		outOPR, ldIPR			:	in		std_logic;
		outBusSel				:	in		std_logic_vector(1 downto 0);
		inBusSel					:	in		std_logic_vector(2 downto 0); -- CBA
		p0, p1, p2, p3,
		p4, p5, p6, p7,
		p8, p9, p10, p11,
		p12, p13, p14, p15	:	inout	std_logic_vector(REG_MAX_INDEX downto 0) -- Peripherals
		
	);
end entity iop_unit;


-- ENTITY iop_pad_out

library IEEE;
use IEEE.std_logic_1164.all;


use work.commonPkg.all;

entity iop_pad_out is
	port (
		ch			:		in			std_logic_vector(REG_MAX_INDEX downto 0);
		chSel		:		in			std_logic_vector(3 downto 0);
		en			:		in			std_logic;
		x0, x1, x2, x3,
		x4, x5, x6, x7,
		x8, x9, x10, x11,
		x12, x13, x14, x15 :	out 	std_logic_vector(REG_MAX_INDEX downto 0)
	);
end entity iop_pad_out;


-- ENTITY iop_pad_in

library IEEE;
use IEEE.std_logic_1164.all;
use work.commonPkg.all;

entity iop_pad_in is
	port (
		ch			:		out		std_logic_vector(REG_MAX_INDEX downto 0);
		chSel		:		in			std_logic_vector(3 downto 0);
		en			:		in			std_logic;
		x0, x1, x2, x3,
		x4, x5, x6, x7,
		x8, x9, x10, x11,
		x12, x13, x14, x15 :	in 	std_logic_vector(REG_MAX_INDEX downto 0)
	);
end entity iop_pad_in;


-- ENTITY iop_ch_selector
library IEEE;
use IEEE.std_logic_1164.all;
use work.commonPkg.all;

entity iop_ch_selector is
	port (
		chIn			:		in			std_logic_vector(REG_MAX_INDEX downto 0);
		chOut			:		out		std_logic_vector(REG_MAX_INDEX downto 0);
		perifData	:		inout		std_logic_vector(REG_MAX_INDEX downto 0);
		chSel			:		in			std_logic_vector(1 downto 0)
	);
end entity iop_ch_selector;

-- END ENTITY DECLARATIONS --


-- BEGIN ARCHITECTURE IMPLEMENTATIONS --


-- ARCHITECTURE for iop_unit
architecture IOP_Unit of iop_unit is
	signal s_OPR_din, s_OPR_dout		:		std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_PAR_din, s_PAR_out		:		std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_IPR_din, s_IPR_dout		:		std_logic_vector(REG_MAX_INDEX downto 0);
	
	signal s_clk_IPR						:		std_logic;

	
	-- Effective Addr
	alias IOP_Addr		:		std_logic_vector(IOP_ADDR_BITS-1 downto 0) is s_PAR_OUT(IOP_ADDR_BITS-1 downto 0);
	
begin
	
	s_PAR_din	<=		"0000000000" & addr;

	PAR : -- Peripheral Address Register
		register14b port map ( 
			clk		=>		clk,
			rst		=>		rst,
			din		=>		s_PAR_din,
			dout		=>		s_PAR_out
		);

-- OUTPUT (CPU -> I/P-P)
	OPR_MuxBus :
		mux4to1 port map (
			a			=>		A_bus,
			b			=>		B_bus,
			c			=>		C_bus,
			d			=>		s_OPR_dout,
			muxSel	=>		outBusSel,
			muxOut	=>		s_OPR_din
		);
		
	OPR : -- Output Peripheral Register
		register14b port map (
			clk		=>		clk,
			rst		=>		rst,
			din		=>		s_OPR_din,
			dout		=>		s_OPR_dout
		);
	
	PAD_out : -- Peripheral Address Decoder Out
		iop_pad_out port map (
			ch			=>		s_OPR_dout,
			chSel		=>		IOP_Addr,
			en			=>		outOPR,
			
			x0			=>		p0,
			x1			=>		p1,
			x2			=>		p2,
			x3			=>		p3,
			x4			=>		p4,
			x5			=>		p5,
			x6			=>		p6,
			x7			=>		p7,
			x8			=>		p8,
			x9			=>		p9,
			x10		=>		p10,
			x11		=>		p11,
			x12		=>		p12,
			x13		=>		p13,
			x14		=>		p14,
			x15		=>		p15
		);	
	
-- Input (I/O-P -> CPU)

		PAD_in :
			iop_pad_in port map (
				ch			=>		s_IPR_din,	
				chSel		=>		IOP_Addr,
				en			=>		ldIPR,
				
				x0			=>		p0,
				x1			=>		p1,
				x2			=>		p2,
				x3			=>		p3,
				x4			=>		p4,
				x5			=>		p5,
				x6			=>		p6,
				x7			=>		p7,
				x8			=>		p8,
				x9			=>		p9,
				x10		=>		p10,
				x11		=>		p11,
				x12		=>		p12,
				x13		=>		p13,
				x14		=>		p14,
				x15		=>		p15
			);	
			
	--s_clk_IPR	<=		clk AND ldIPR; -- Just write when ren is active	
	s_clk_IPR	<=		clk; -- Just write when ren is active	
	IPR : -- Input Peripheral Register
		register14b port map (
			clk 		=>		s_clk_IPR,
			rst		=>		rst,
			din		=>		s_IPR_din,
			dout		=>		s_IPR_dout
		);
		
		
	IPR_toBus : -- TriStated Decoder
		decoder1to3 port map (
		  a		=>		A_bus,
		  b		=>		B_bus,
		  c 		=>		C_bus,
		  din 	=>		s_IPR_dout,
		  chSel	=>		inBusSel
		);
	
		
	

end architecture IOP_Unit;


-- ARCHITECTURE for iop_pad_out
architecture pad_out of iop_pad_out is 
begin	
		x0 	<=		ch when (en & chSel) = "10000" else
						(others => 'Z');
						
		x1 	<=		ch when (en & chSel) = "10001" else
						(others => 'Z');

		x2 	<=		ch when (en & chSel) = "10010" else
						(others => 'Z');

		x3 	<=		ch when (en & chSel) = "10011" else
						(others => 'Z');

		x4 	<=		ch when (en & chSel) = "10100" else
						(others => 'Z');

		x5 	<=		ch when (en & chSel) = "10101" else
						(others => 'Z');

		x6 	<=		ch when (en & chSel) = "10110" else
						(others => 'Z');

		x7 	<=		ch when (en & chSel) = "10111" else
						(others => 'Z');

		x8 	<=		ch when (en & chSel) = "11000" else
						(others => 'Z');

		x9 	<=		ch when (en & chSel) = "11001" else
						(others => 'Z');

		x10 	<=		ch when (en & chSel) = "11010" else
						(others => 'Z');

		x11 	<=		ch when (en & chSel) = "11011" else
						(others => 'Z');

		x12 	<=		ch when (en & chSel) = "11100" else
						(others => 'Z');

		x13 	<=		ch when (en & chSel) = "11101" else
						(others => 'Z');

		x14 	<=		ch when (en & chSel) = "11110" else
						(others => 'Z');

		x15 	<=		ch when (en & chSel) = "11111" else
						(others => 'Z');						
						
		

--		with (en & chSel) select
--		x1 <= 	ch 				 when "10001",
--				(others => 'Z') when others;
--
--		with chSel select
--		x2 <= 	ch 				 when "0010",
--				(others => 'Z') when others;
--
--		with chSel select
--		x3 <= 	ch 				 when "0011",
--				(others => 'Z') when others;
--
--		with chSel select
--		x4 <= 	ch 				 when "0100",
--				(others => 'Z') when others;
--
--		with chSel select
--		x5 <= 	ch 				 when "0101",
--				(others => 'Z') when others;
--
--		with chSel select
--		x6 <= 	ch 				 when "0110",
--				(others => 'Z') when others;
--
--		with chSel select
--		x7 <= 	ch 				 when "0111",
--				(others => 'Z') when others;
--
--		with chSel select
--		x8 <= 	ch 				 when "1000",
--				(others => 'Z') when others;
--
--		with chSel select
--		x9 <= 	ch 				 when "1001",
--				(others => 'Z') when others;
--
--		with chSel select
--		x10 <= 	ch 				 when "1010",
--				(others => 'Z') when others;
--
--		with chSel select
--		x11 <= 	ch 				 when "1011",
--				(others => 'Z') when others;
--
--		with chSel select
--		x12 <= 	ch 				 when "1100",
--				(others => 'Z') when others;
--
--		with chSel select
--		x13 <= 	ch 				 when "1101",
--				(others => 'Z') when others;
--
--		with chSel select
--		x14 <= 	ch 				 when "1110",
--				(others => 'Z') when others;
--
--		with chSel select
--		x15 <= 	ch 				 when "1111",
--				(others => 'Z') when others;
			
				
				

end architecture pad_out;



-- ARCHITECTURE for iop_pad_in
architecture pad_in of iop_pad_in is 
begin	
		ch 	<=		x0 when (en & chSel) = "10000" else
						(others => 'Z');
						
		ch 	<=		x1 when (en & chSel) = "10001" else
						(others => 'Z');

		ch 	<=		x2 when (en & chSel) = "10010" else
						(others => 'Z');

		ch 	<=		x3 when (en & chSel) = "10011" else
						(others => 'Z');

		ch 	<=		x4 when (en & chSel) = "10100" else
						(others => 'Z');

		ch 	<=		x5 when (en & chSel) = "10101" else
						(others => 'Z');

		ch 	<=		x6 when (en & chSel) = "10110" else
						(others => 'Z');

		ch 	<=		x7 when (en & chSel) = "10111" else
						(others => 'Z');

		ch 	<=		x8 when (en & chSel) = "11000" else
						(others => 'Z');

		ch 	<=		x9 when (en & chSel) = "11001" else
						(others => 'Z');

		ch 	<=		x10 when (en & chSel) = "11010" else
						(others => 'Z');

		ch 	<=		x11 when (en & chSel) = "11011" else
						(others => 'Z');

		ch 	<=		x12 when (en & chSel) = "11100" else
						(others => 'Z');

		ch 	<=		x13 when (en & chSel) = "11101" else
						(others => 'Z');

		ch 	<=		x14 when (en & chSel) = "11110" else
						(others => 'Z');

		ch 	<=		x15 when (en & chSel) = "11111" else
						(others => 'Z');						
									

end architecture pad_in;



-- ARCHITECTURE for iop_ch_selector
architecture iop_ch_selector of iop_ch_selector is 
begin	
		with chSel(0) select
		perifData	<=		chIn 	when '1',
						(others => 'Z') when others;
						
		with chSel(1) select
		chOut	<=		perifData	when '1',
						(others => 'Z') when others;
						
end architecture iop_ch_selector;