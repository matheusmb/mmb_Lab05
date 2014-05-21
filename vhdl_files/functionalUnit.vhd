library IEEE; 

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.commonPkg.all;

entity functionalUnit is
	port(
		A_bus, B_bus, C_bus 	: inout	 std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst					: in		 std_logic; -- does it need a reset?
		muxSelTA, muxSelTB 	: in		 std_logic_vector(1 downto 0);
		ctGenSel					: in		 std_logic_vector(3 downto 0);
		aluExec					: in		 std_logic;
		opSel						: in		 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0);
		outSelTALU				: in 		 std_logic_vector(2 downto 0);
		outSelTR					: in 		 std_logic_vector(2 downto 0);
		outSelTSR				: in 		 std_logic_vector(2 downto 0)		
	);
end entity functionalUnit;



architecture functionalUnit_arch of functionalUnit is
	signal s_aluOut	  : std_logic_vector(3*REGISTER_SIZE-1 downto 0);	
	signal clkn		  : std_logic;

	
	alias aluOutTALU 	:	std_logic_vector(REGISTER_SIZE-1 downto 0) is s_aluOut(REGISTER_SIZE-1 downto 0);
	alias aluOutTR 	:	std_logic_vector(REGISTER_SIZE-1 downto 0) is s_aluOut(2*REGISTER_SIZE-1 downto REGISTER_SIZE);
	alias aluOutTSR 	:	std_logic_vector(REGISTER_SIZE-1 downto 0) is s_aluOut(3*REGISTER_SIZE-1 downto REGISTER_SIZE*2);
		
	signal TA, TB		:	std_logic_vector(REGISTER_SIZE-1 downto 0);
	
	component fu_in is
		port (
			A_bus, B_bus, C_bus 		:		in		std_logic_vector(BUS_WIDTH-1 downto 0);
			clk, rst						:		in		std_logic;
			muxSelTA, muxSelTB 		: 		in		std_logic_vector(1 downto 0);
			ctGenSel						: 		in		std_logic_vector(3 downto 0);
			
			TA_out, TB_out				:		out	std_logic_vector(REGISTER_SIZE-1 downto 0)
		);
	end component fu_in;	
	
	component fu_out is
		port (
			A_bus, B_bus, C_bus 					:		out		std_logic_vector(BUS_WIDTH-1 downto 0);
			clk, rst									:		in			std_logic;
			--aluOutTSR, aluOutTR, aluOutTR		:		in			std_logic_vector(REGISTER_SIZE-1 downto 0);
			aluOut									:		in			std_logic_vector(3*REGISTER_SIZE-1 downto 0);
			outSelTALU, outSelTR, outSelTSR	: 		in 		 std_logic_vector(2 downto 0)
		);
	end component fu_out;	
begin
	
	clkn 	<=		NOT clk;
	
	Alu_in :
		fu_in port map (
			A_bus		=>		A_bus,
			B_bus		=>		B_bus,
			C_bus		=>		C_bus,
			clk		=>		clk,
			rst		=>		rst,
			muxSelTA	=>		muxSelTA,
			muxSelTB =>		muxSelTB,
			ctGenSel	=>		ctGenSel,
			TA_out	=>		TA,
			TB_out	=>		TB
		);

	
	alu :
		fu_alu port map (
			opSel		=> opSel,
			clk		=> clk,
			rst		=> rst,
			inpA		=> signed(TA),
			inpB		=> signed(TB),
			talu		=> aluOutTALU,
			tr			=> aluOutTR,
			tsr		=> aluOutTSR,
			aluExec	=> aluExec
		);
		
	Alu_out :
		fu_out port map (
			A_bus			=>		A_bus,
			B_bus			=>		B_bus,
			C_bus			=>		C_bus,
			clk			=>		clkn,
			rst			=>		rst,
			aluOut		=>		s_aluOut,
			outSelTALU	=>		outSelTALU,
			outSelTR		=>		outSelTR,
			outSelTSR	=>		outSelTSR
		);
		
		


end architecture functionalUnit_arch;








library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.commonPkg.all;


entity fu_out is
	port (
		A_bus, B_bus, C_bus 					:		out		std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst									:		in			std_logic;
		aluOut									:		in			std_logic_vector(3*REGISTER_SIZE-1 downto 0);
		outSelTALU, outSelTR, outSelTSR	: 		in 		std_logic_vector(2 downto 0)
	);
end entity fu_out;

architecture arch_fu_out of fu_out is
	signal outSel		:		std_logic_vector(8 downto 0);
begin
		outSel	<=	outSelTSR & outSelTR & outSelTALU;
		
		OutRegs :
		for i in 2 downto 0 generate
			signal alu_dout : std_logic_vector(REGISTER_SIZE-1 downto 0);			
		begin
		
				regs : register14b port map (
					din	=> aluOut(REGISTER_SIZE*i+REGISTER_SIZE-1 downto i*REGISTER_SIZE),
					clk	=> clk, -- Check it here!
					rst	=> rst,
					dout	=> alu_dout
				);
			
			decode:	decoder1to3 port map (
					a 		=> A_bus,
					b 		=> B_bus,
					c 		=> C_bus,
					din 	=> alu_dout,
					chSel	=> outSel(3*i+2 downto 3*i)
				);
		
		end generate;
end architecture arch_fu_out;
















library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.commonPkg.all;




entity fu_in is
	port (
		A_bus, B_bus, C_bus 		:		in		std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst						:		in		std_logic;
		muxSelTA, muxSelTB 		: 		in		std_logic_vector(1 downto 0);
		ctGenSel						: 		in		std_logic_vector(3 downto 0);
		
		TA_out, TB_out				:		out	std_logic_vector(REGISTER_SIZE-1 downto 0)
	);
end entity fu_in;

architecture arch_fu_in of fu_in is	
	signal registers : std_logic_vector(2*REGISTER_SIZE-1 downto 0);
	
	alias TA 	: std_logic_vector(REGISTER_SIZE-1 downto 0) is registers(REGISTER_SIZE-1 downto 0);
	alias TB 	: std_logic_vector(REGISTER_SIZE-1 downto 0) is registers(2*REGISTER_SIZE-1 downto REGISTER_SIZE);	
	
	signal ctVal	 		: std_logic_vector(REGISTER_SIZE-1 downto 0);
	signal TA_in, TB_in	: std_logic_vector(REGISTER_SIZE-1 downto 0);
begin	
-- CT Generator	
	
	ct_gen : fu_ct_gen port map (
			fu_ct_sel => ctGenSel,
			fu_ct_out => ctVal
		);
		
		
-- TA Register In
	TA_muxIn	:
		mux4to1 port map (
			a			=>		A_bus,
			b			=>		B_bus,
			c			=>		C_bus,
			d			=>		TA,
			muxSel	=>		muxSelTA,
			muxOut	=>		TA_in
		);
		
	TA_reg :
		register14b port map(
			clk		=>		clk,
			rst		=>		rst,
			din		=>		TA_in,
			dout		=>		TA
		);
		
	TB_muxIn	:
		mux4to1 port map (
			a			=>		A_bus,
			b			=>		B_bus,
			c			=>		C_bus,
			d			=>		ctVal,
			muxSel	=>		muxSelTB,
			muxOut	=>		TB_in
		);
		
	TB_reg :
		register14b port map(
			clk		=>		clk,
			rst		=>		rst,
			din		=>		TB_in,
			dout		=>		TB
		);	
	
		TA_out 	<=		TA;
		TB_out	<=		TB;

end architecture arch_fu_in;

library IEEE;
use IEEE.std_logic_1164.all;


entity fu_ct_gen is
	port(
		fu_ct_sel : in std_logic_vector(3 downto 0);
		fu_ct_out : out std_logic_vector(13 downto 0)
	);
end entity fu_ct_gen;

architecture fu_ct_gen of fu_ct_gen is
begin
	fu_ct_out <= "0000000000" & fu_ct_sel;
--	with fu_ct_sel select
--		fu_ct_out <= "00000000000001" when "00", -- 1
--						 "00000000000010" when "01", -- 2
--						 "00000000000100" when "10", -- 4
--						 "00000000001000" when "11", -- 8
--						 "00000000000000" when others;

end architecture fu_ct_gen;