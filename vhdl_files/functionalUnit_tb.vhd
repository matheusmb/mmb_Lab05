LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

use work.commonPkg.all;

entity mmb_functionalUnit_tb is
end entity mmb_functionalUnit_tb;

architecture lut of mmb_functionalUnit_tb is

component mmb_functionalUnit is
	port(
		A_bus, B_bus, C_bus 	: inout	 std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst					: in		 std_logic;
		muxSelTA, muxSelTB 	: in		 std_logic_vector(1 downto 0);
		ctGenSel					: in		 std_logic_vector(3 downto 0);
		aluExec					: in		 std_logic;
		opSel						: in		 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0);
		outSelTALU				: in 		 std_logic_vector(2 downto 0);
		outSelTR					: in 		 std_logic_vector(2 downto 0);
		outSelTSR				: in 		 std_logic_vector(2 downto 0)
		
	);
end component mmb_functionalUnit;

	signal	 A_bus_tb, B_bus_tb, C_bus_tb 	:		std_logic_vector(BUS_WIDTH-1 downto 0);
	signal 	clk_tb, rst_tb				:   		 std_logic;
	signal 	muxSelTA_tb, muxSelTB_tb:			 std_logic_vector(1 downto 0);
	signal	ctGenSel_tb					:	 		 std_logic_vector(3 downto 0);
	signal	aluExec_tb					:	 		 std_logic;
	signal	opSel_tb						:			 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0);
	signal	outSelTALU_tb				:			 std_logic_vector(2 downto 0);
	signal	outSelTR_tb					:  		 std_logic_vector(2 downto 0);
	signal	outSelTSR_tb				:  		 std_logic_vector(2 downto 0);

	
	
	type alu_results is record
		A_bus_out, B_bus_out 	:	std_logic_vector(BUS_WIDTH-1 downto 0);		
		c, n, v,	z		:	std_logic;
	end record alu_results;
	
	type alu_results_array is array(natural range <>) of alu_results;
	-- inpA = 10922 - 10101010101010
	-- inpB = 5461 - 01010101010101
	constant alu_results_vectors : alu_results_array := (
	------------------------------------------------------------------------------
	-- Result Vector 0 ADD
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "11111111111111",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			),
			
	------------------------------------------------------------------------------
	-- Result Vector 1 SUB
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '1',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
			
	------------------------------------------------------------------------------
	-- Result Vector 2 ADDC - C = 2
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "10101010101100",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			),

				------------------------------------------------------------------------------
	-- Result Vector 3 SUBC
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "10101010101000",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '1',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			),
			

	------------------------------------------------------------------------------
	-- Result Vector 4 MUL
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01110001110010",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),

	------------------------------------------------------------------------------
	-- Result Vector 5 DIV
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "00000000000010",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
			
	------------------------------------------------------------------------------
	-- Result Vector 6 MULC
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010100",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
		
	------------------------------------------------------------------------------
	-- Result Vector 7 DIVC
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),

	------------------------------------------------------------------------------
	-- Result Vector 8 NOT
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 9 AND
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "00000000000000",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '1'
			),

	------------------------------------------------------------------------------
	-- Result Vector 10 OR
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "11111111111111",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 11 XOR
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "11111111111111",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 12 shll - Using lower 4 bits of inpB 5d
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101000000",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 13 shrl
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "00000101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 14 shla
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101000000",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 15 shra
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "00000101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 16 rotl
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 17 rotr
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 18 rtlc
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "01010101001010",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '1',
				n						=> '0',
				v						=> '0',
				z						=> '0'
			),
	------------------------------------------------------------------------------
	-- Result Vector 19 rtrc
	------------------------------------------------------------------------------
			(
				A_bus_out			=> "10100101010101",
				B_bus_out			=> "ZZZZZZZZZZZZZZ",
				c						=> '0',
				n						=> '1',
				v						=> '0',
				z						=> '0'
			)				
	);

			
begin	
	UUT: mmb_functionalUnit port map (
		A_bus				=>		A_bus_tb,
		B_bus				=>		B_bus_tb,
		C_bus				=>		C_bus_tb,
		clk				=>		clk_tb,
		rst				=>		rst_tb,
		muxSelTA			=>		muxSelTA_tb,
		muxSelTB			=>		muxSelTB_tb,
		ctGenSel			=>		ctGenSel_tb,
		aluExec			=>		aluExec_tb,
		opSel				=>		opSel_tb,
		outSelTALU		=>		outSelTALU_tb,
		outSelTR			=>		outSelTR_tb,
		outSelTSR		=>		outSelTSR_tb
	);
	
	
	tb : 
	process
		constant period : time := 20 ns;
		constant NUM_OPS : integer := 19;
		constant Z_default	:	std_logic_vector(REGISTER_SIZE-1 downto 0) := (others => 'Z');
		constant inpA : std_logic_vector(REGISTER_SIZE-1 downto 0) := "10101010101010"; --
		constant inpB : std_logic_vector(REGISTER_SIZE-1 downto 0) := "01010101010101";
		constant inpC : std_logic_vector(REGISTER_SIZE-1 downto 0) := (others => 'Z');
--		
--		constant inpA : std_logic_vector(REGISTER_SIZE-1 downto 0) := "00000000000010";
--		constant inpB : std_logic_vector(REGISTER_SIZE-1 downto 0) := "10000000000111";
		variable inputSelB	:std_logic_vector(1 downto 0);
	begin
		for i in 0 to NUM_OPS loop
			if(i = 2 OR i = 3 OR i = 6 or i = 7) then		
				inputSelB := "00";
			else
				inputSelB := "10";
			end if;
			
-- Load Inputs
			A_bus_tb			<=		inpA; 
			B_bus_tb 		<=		inpB;
			C_bus_tb 		<=		InpC;
			clk_tb			<=		'0';
			rst_tb			<=		'0';
			muxSelTA_tb		<=		"01"; -- Always load from BUS A
			muxSelTB_tb		<=		inputSelB; -- Always load from BUS B
			ctGenSel_tb		<=		"0010"; -- Constant 2
			aluExec_tb		<=		'0';
			opSel_tb			<=		conv_std_logic_vector(i, 6);
			outSelTALU_tb	<=		"000";
			outSelTR_tb		<=		"000";
			outSelTSR_tb	<=		"000";
			
			wait for period;
			
			clk_tb			<= 	'1';
			
			wait for period;
			
-- Execute
			A_bus_tb			<=		Z_default; 
			B_bus_tb 		<=		Z_default;
			C_bus_tb 		<=		Z_default;
			clk_tb			<=		'0';
			rst_tb			<=		'0';
			muxSelTA_tb		<=		"01"; -- Always load from BUS A
			muxSelTB_tb		<=		inputSelB; -- Always load from BUS B
			ctGenSel_tb		<=		"0010"; -- Constant 2
			aluExec_tb		<=		'1';
			opSel_tb			<=		conv_std_logic_vector(i, 6);
			outSelTALU_tb	<=		"000";
			outSelTR_tb		<=		"000";
			outSelTSR_tb	<=		"000";

			wait for period;
			clk_tb			<= '1';
			wait for period;
			
-- Write Back	
			A_bus_tb			<=		Z_default; 
			B_bus_tb 		<=		Z_default;
			C_bus_tb 		<=		Z_default;
			clk_tb			<=		'0';
			rst_tb			<=		'0';
			muxSelTA_tb		<=		"01"; -- Always load from BUS A
			muxSelTB_tb		<=		inputSelB; -- Always load from BUS B
			ctGenSel_tb		<=		"0010"; -- Constant 2
			aluExec_tb		<=		'0';
			opSel_tb			<=		conv_std_logic_vector(i, 6);
			outSelTALU_tb	<=		"001"; -- Writes on A
			outSelTR_tb		<=		"000";
			outSelTSR_tb	<=		"100"; -- Writes on C
			
			wait for period;
			clk_tb		<= '1';
			wait for period;
			
			ASSERT(
				(A_bus_tb = alu_results_vectors(i).A_bus_out) AND
				(B_bus_tb = alu_results_vectors(i).B_bus_out) AND
				(C_bus_tb(13) = alu_results_vectors(i).c) AND
				(C_bus_tb(12) = alu_results_vectors(i).n) AND
				(C_bus_tb(11) = alu_results_vectors(i).v) AND
				(C_bus_tb(10) = alu_results_vectors(i).z)
			)
			REPORT "ALU test vector " & INTEGER'IMAGE(i) & " failed"
			SEVERITY error;
		end loop;
	
		report "Test Completed!";
		wait;
		end process;
	
	
end architecture lut;