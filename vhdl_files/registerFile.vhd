LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

USE work.commonPkg.all;

entity registerFile is
	port(
		A_bus, B_bus, C_bus 							:		inout std_logic_vector(13 downto 0);
		clk, rst											:		in 	std_logic;
		regSelA, regSelB								: 		in 	std_logic_vector(15 downto 0); -- Mux Selector register in
		regSelOut_A, regSelOut_B, regSelOut_C 	: 		in 	std_logic_vector(3 downto 0); -- Mux selec register out
		triSel 											: 		in 	std_logic_vector(2 downto 0)
	);

end entity registerFile;



architecture registerFileArch of registerFile is
	signal regs 			:		std_logic_vector(223 downto 0); -- 14 bits * 16 registers = 224
	signal tri_out			:		std_logic_vector(41 downto 0) := (others => 'Z'); -- 3 buses * 14 bits = 42
	signal mux_set_out 	:		std_logic_vector(11 downto 0); -- Set mux out selectors

	
--	function mmb_comparator(a, b : std_logic_vector(13 downto 0)) return std_logic is
--	begin
--		if(unsigned(a) = unsigned(b)) then
--			return '1';
--		else
--			return '0';
--		end if;
--	end function mmb_comparator;
	
	
begin

	mux_set_out(3 downto 0) <= regSelOut_A;
	mux_set_out(7 downto 4) <= regSelOut_B;
	mux_set_out(11 downto 8) <= regSelOut_C;
	
	registers_block : 
		for i in 15 downto 0 generate
			signal mux_dout : std_logic_vector(13 downto 0); -- muxOut data	
			signal mux_selector : std_logic_vector(1 downto 0);
		begin			
			mux_selector <= regSelA(i) & regSelB(i); 
			mux_in : mux4to1 port map (
				a => A_bus,
				b => B_bus,
				c => C_bus,
				d => regs(i*14 + 13 downto i*14),
				muxSel => mux_selector,
				muxOut => mux_dout
				);
				
			registers : register14b port map (
				din => mux_dout,
				rst => rst,
				clk => clk,
				dout => regs(i*14 + 13 downto i*14)		
			);
		end generate;
		
		
	stage_out :
		for i in 2 downto 0 generate
			signal mux_out : std_logic_vector(13 downto 0);
			begin
			muxes : mux16to1 port map (
				x0 => regs(13 downto 0), 
				x1 => regs(27 downto 14), 
				x2 => regs(41 downto 28), 
				x3 => regs(55 downto 42), 
				x4 => regs(69 downto 56), 
				x5 => regs(83 downto 70), 
				x6 => regs(97 downto 84), 
				x7 => regs(111 downto 98), 
				x8 => regs(125 downto 112), 
				x9 => regs(139 downto 126), 
				x10 => regs(153 downto 140), 
				x11 => regs(167 downto 154), 
				x12 => regs(181 downto 168), 
				x13 => regs(195 downto 182), 
				x14 => regs(209 downto 196), 
				x15 => regs(223 downto 210),
				muxSel => mux_set_out(i*4+3 downto i*4),
				muxOut => mux_out
			);
			
			stage_triState : triState port map (
				din => mux_out,
				dout => tri_out(i*14+13 downto i*14),
				s => triSel(i)				
			);
		end generate;
		
	
--	STATUS REGISTER
--	muxIn:	
--		mmb_mux4to1 port map (
--			a			=>		A_bus,
--			b			=>		B_bus,
--			c			=>		C_bus,
--			d			=>		s_srReg,
--			muxSel	=>		srBusIn,
--			muxOut	=>		s_srMuxOut
--		);			
--		
--	SR	:	
--		mmb_register14b port map(
--			clk	=>		clk,
--			rst	=>		rst,
--			din	=>		s_srMuxOut,
--			dout	=>		s_srReg
--		);
--	
--	srTriState	:
--		for i in 2 downto 0 generate
--		begin
--			srTriOut	:
--				mmb_triState port map (
--					din	=>		s_srReg,
--					dout	=>		tri_out(i*14+13 downto i*14),
--					s		=>		srBusOut(i)
--				);
--		end generate;
				
					

	A_bus <= tri_out(13 downto 0);
	B_bus <= tri_out(27 downto 14);
	C_bus <= tri_out(41 downto 28);
	
end architecture registerFileArch;
