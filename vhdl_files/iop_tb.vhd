LIBRARY ieee;
USE ieee.std_logic_1164.all;

use work.mmb_dcs.all;

entity mmb_iop_tb is
end entity mmb_iop_tb;

architecture lut of mmb_iop_tb is
component mmb_iop_unit is
	port (
		A_bus, B_bus, C_bus 	: 	inout	std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst					:	in		std_logic;
		addr						:	in		std_logic_vector(IOP_ADDR_BITS-1 downto 0);
		wen, ren					:	in		std_logic;
		outBusSel				:	in		std_logic_vector(1 downto 0);
		inBusSel					:	in		std_logic_vector(2 downto 0); -- CBA
		p0, p1, p2, p3,
		p4, p5, p6, p7,
		p8, p9, p10, p11,
		p12, p13, p14, p15	:	inout	std_logic_vector(REG_MAX_INDEX downto 0) -- Peripherals
		
	);
end component mmb_iop_unit;
		signal 		A_bus_tb, B_bus_tb, C_bus_tb :	std_logic_vector(BUS_WIDTH-1 downto 0);
		signal 		clk_tb, rst_tb			:   	std_logic;		
		signal 		addr_tb						:		std_logic_vector(IOP_ADDR_BITS-1 downto 0);
		signal 		wen_tb, ren_tb					:		std_logic;
		signal 		outBusSel_tb				:		std_logic_vector(1 downto 0);
		signal 		inBusSel_tb				:		std_logic_vector(2 downto 0); -- CBA
		signal 		p0_tb, p1_tb, p2_tb, p3_tb,
		p4_tb, p5_tb, p6_tb, p7_tb,
		p8_tb, p9_tb, p10_tb, p11_tb,
		p12_tb, p13_tb, p14_tb, p15_tb	:		std_logic_vector(REG_MAX_INDEX downto 0); -- Peripherals

		
		
		type r_test_vector is record
			A_bus_tb, B_bus_tb, C_bus_tb : 	std_logic_vector(BUS_WIDTH-1 downto 0);
			clk_tb, rst_tb		:   	std_logic;		
			addr_tb						:		std_logic_vector(IOP_ADDR_BITS-1 downto 0);
			wen_tb, ren_tb					:		std_logic;
			outBusSel_tb				:		std_logic_vector(1 downto 0);
			inBusSel_tb					:		std_logic_vector(2 downto 0); -- CBA
			p0_tb	, p1_tb	, p2_tb	, p3_tb	,
			p4_tb	, p5_tb	, p6_tb	, p7_tb	,
			p8_tb	, p9_tb	, p10_tb	, p11_tb	,
			p12_tb	, p13_tb	, p14_tb	, p15_tb		:		std_logic_vector(REG_MAX_INDEX downto 0); -- Peripherals
		end record r_test_vector;
		
		
	type test_vector is array(natural range<>) of r_test_vector;
	
	
	constant test_vectors : test_vector := 
	(
   -------------------------------------------
	---	Test Vector 0 - Reset 			
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'1',
			addr_tb				=>		"0000",
			wen_tb				=>		'0',
			ren_tb				=>		'0',
			outBusSel_tb		=>		"00",
			inBusSel_tb			=>		"000",
			p0_tb					=>		"00000000000000",
			p1_tb					=>		"00000000000000",
			p2_tb					=>		"00000000000000",
			p3_tb					=>		"00000000000000",
			p4_tb					=>		"00000000000000",
			p5_tb					=>		"00000000000000",
			p6_tb					=>		"00000000000000",
			p7_tb					=>		"00000000000000",
			p8_tb					=>		"00000000000000",
			p9_tb					=>		"00000000000000",
			p10_tb				=>		"00000000000000",
			p11_tb				=>		"00000000000000",
			p12_tb				=>		"00000000000000",
			p13_tb				=>		"00000000000000",
			p14_tb				=>		"00000000000000",
			p15_tb				=>		"00000000000000"	

		),
   -------------------------------------------
	---	Test Vector 1 - Read(IN) From P1 (LOAD IPR)		
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',
			addr_tb				=>		"0001",
			wen_tb				=>		'0',
			ren_tb				=>		'1',
			outBusSel_tb		=>		"00",
			inBusSel_tb			=>		"000",
			p0_tb					=>		"00000000000000",
			p1_tb					=>		"10101010101010",
			p2_tb					=>		"00000000000000",
			p3_tb					=>		"00000000000000",
			p4_tb					=>		"00000000000000",
			p5_tb					=>		"00000000000000",
			p6_tb					=>		"00000000000000",
			p7_tb					=>		"00000000000000",
			p8_tb					=>		"00000000000000",
			p9_tb					=>		"00000000000000",
			p10_tb				=>		"00000000000000",
			p11_tb				=>		"00000000000000",
			p12_tb				=>		"00000000000000",
			p13_tb				=>		"00000000000000",
			p14_tb				=>		"00000000000000",
			p15_tb				=>		"00000000000000"	

		),
		-------------------------------------------
		---	Test Vector 2 - IPR to bus A		
		-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',
			addr_tb				=>		"0001",
			wen_tb				=>		'0',
			ren_tb				=>		'1',
			outBusSel_tb		=>		"00",
			inBusSel_tb			=>		"001",
			p0_tb					=>		"00000000000000",
			p1_tb					=>		"10101010101010",
			p2_tb					=>		"00000000000000",
			p3_tb					=>		"00000000000000",
			p4_tb					=>		"00000000000000",
			p5_tb					=>		"00000000000000",
			p6_tb					=>		"00000000000000",
			p7_tb					=>		"00000000000000",
			p8_tb					=>		"00000000000000",
			p9_tb					=>		"00000000000000",
			p10_tb				=>		"00000000000000",
			p11_tb				=>		"00000000000000",
			p12_tb				=>		"00000000000000",
			p13_tb				=>		"00000000000000",
			p14_tb				=>		"00000000000000",
			p15_tb				=>		"00000000000000"	

		),
		
		-------------------------------------------
		---	Test Vector 3 - Load OPR from bus A	
		-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',
			addr_tb				=>		"0001",
			wen_tb				=>		'0',
			ren_tb				=>		'1',
			outBusSel_tb		=>		"01",
			inBusSel_tb			=>		"001",
			p0_tb					=>		"00000000000000",
			p1_tb					=>		"10101010101010",
			p2_tb					=>		"00000000000000",
			p3_tb					=>		"00000000000000",
			p4_tb					=>		"00000000000000",
			p5_tb					=>		"00000000000000",
			p6_tb					=>		"00000000000000",
			p7_tb					=>		"00000000000000",
			p8_tb					=>		"00000000000000",
			p9_tb					=>		"00000000000000",
			p10_tb				=>		"00000000000000",
			p11_tb				=>		"00000000000000",
			p12_tb				=>		"00000000000000",
			p13_tb				=>		"00000000000000",
			p14_tb				=>		"00000000000000",
			p15_tb				=>		"ZZZZZZZZZZZZZZ"	

		),
		-------------------------------------------
		---	Test Vector 4 - Write(OUT) OPR on P15 
		-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',
			addr_tb				=>		"1111",
			wen_tb				=>		'1',
			ren_tb				=>		'0',
			outBusSel_tb		=>		"00",
			inBusSel_tb			=>		"000",
			p0_tb					=>		"00000000000000",
			p1_tb					=>		"10101010101010",
			p2_tb					=>		"00000000000000",
			p3_tb					=>		"00000000000000",
			p4_tb					=>		"00000000000000",
			p5_tb					=>		"00000000000000",
			p6_tb					=>		"00000000000000",
			p7_tb					=>		"00000000000000",
			p8_tb					=>		"00000000000000",
			p9_tb					=>		"00000000000000",
			p10_tb				=>		"00000000000000",
			p11_tb				=>		"00000000000000",
			p12_tb				=>		"00000000000000",
			p13_tb				=>		"00000000000000",
			p14_tb				=>		"00000000000000",
			p15_tb				=>		"ZZZZZZZZZZZZZZ"	

		)
	
	
	);
	

begin	
	UUT: 
	mmb_iop_unit port map (
			A_bus				=>		A_bus_tb,
			B_bus				=>		B_bus_tb,
			C_bus				=>		C_bus_tb,
			clk				=>		clk_tb,
			rst				=>		rst_tb,		
			addr				=>		addr_tb,
			wen				=>		wen_tb,
			ren				=>		ren_tb,
			outBusSel		=>		outBusSel_tb,
			inBusSel			=>		inBusSel_tb,
			p0					=>		p0_tb,
			p1					=>		p1_tb,
			p2					=>		p2_tb,
			p3					=>		p3_tb,
			p4					=>		p4_tb,
			p5					=>		p5_tb,
			p6					=>		p6_tb,
			p7					=>		p7_tb,
			p8					=>		p8_tb,
			p9					=>		p9_tb,
			p10				=>		p10_tb,
			p11				=>		p11_tb,
			p12				=>		p12_tb,
			p13				=>		p13_tb,
			p14				=>		p14_tb,
			p15				=>		p15_tb	
	);
	
	
	tb : process
	constant period : time := 20 ns;
	begin
		for i in test_vectors'range loop
			A_bus_tb					<=		test_vectors(i).A_bus_tb;
			B_bus_tb					<=		test_vectors(i).B_bus_tb;
			C_bus_tb					<=		test_vectors(i).C_bus_tb;
			clk_tb					<=		test_vectors(i).clk_tb;
			rst_tb					<=		test_vectors(i).rst_tb;
			addr_tb					<=		test_vectors(i).addr_tb;
			wen_tb					<=		test_vectors(i).wen_tb;
			ren_tb					<=		test_vectors(i).ren_tb;
			outBusSel_tb			<=		test_vectors(i).outBusSel_tb;
			inBusSel_tb				<=		test_vectors(i).inBusSel_tb;
			p0_tb						<=		test_vectors(i).p0_tb;
			p1_tb						<=		test_vectors(i).p1_tb;
			p2_tb						<=		test_vectors(i).p2_tb;
			p3_tb						<=		test_vectors(i).p3_tb;
			p4_tb						<=		test_vectors(i).p4_tb;
			p5_tb						<=		test_vectors(i).p5_tb;
			p6_tb						<=		test_vectors(i).p6_tb;
			p7_tb						<=		test_vectors(i).p7_tb;
			p8_tb						<=		test_vectors(i).p8_tb;
			p9_tb						<=		test_vectors(i).p9_tb;
			p10_tb					<=		test_vectors(i).p10_tb;
			p11_tb					<=		test_vectors(i).p11_tb;
			p12_tb					<=		test_vectors(i).p12_tb;
			p13_tb					<=		test_vectors(i).p13_tb;
			p14_tb					<=		test_vectors(i).p14_tb;
			p15_tb					<=		test_vectors(i).p15_tb;


			
			wait for period;
			
			clk_tb <= '1';
			
			wait for period;
					
			
		end loop;
		
		report "Test Bench Completed!";
		wait;
		end process;
	
	
end architecture lut;