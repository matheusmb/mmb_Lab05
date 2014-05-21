LIBRARY ieee;
USE ieee.std_logic_1164.all;

use work.mmb_dcs.all;

entity mmb_memUnit_tb is
end entity mmb_memUnit_tb;

architecture lut of mmb_memUnit_tb is
component mmb_mem_unit is
	port (
		A_bus, B_bus, C_bus : inout	std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, rst		:  in 	std_logic;		
		pmRdEn		:	in 	std_logic;		
		incPc			:  in 	std_logic;
		ldPc			: 	in		std_logic;				
		dmWRen		:	in		std_logic;
		dmOutBusSel	:	in		std_logic_vector(2 downto 0);	
		muxDMin		:	in		std_logic_vector(1 downto 0);
		muxMAXinpSel:	in		std_logic_vector(1 downto 0);
		muxDMAdrSel :	in		std_logic;
		pmOutBusSel	:	in		std_logic_vector(2 downto 0);
		SP				:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		irOut			:	out 	std_logic_vector(REG_MAX_INDEX downto 0)
	);

end component mmb_mem_unit;
		signal 		A_bus_tb, B_bus_tb, C_bus_tb :	std_logic_vector(BUS_WIDTH-1 downto 0);
		signal 		clk_tb, rst_tb		:   	std_logic;		
		signal 		pmRdEn_tb			:	 	std_logic;		
		signal 		incPc_tb				:   	std_logic;
		signal 		ldPc_tb				: 		std_logic;				
		signal 		dmWRen_tb			:		std_logic;
		signal 		dmOutBusSel_tb		:		std_logic_vector(2 downto 0);	
		signal 		muxDMin_tb			:		std_logic_vector(1 downto 0);
		signal 		muxMAXinpSel_tb	:		std_logic_vector(1 downto 0);
		signal 		muxDMAdrSel_tb 	:		std_logic;
		signal 		pmOutBusSel_tb		:		std_logic_vector(2 downto 0);
		signal 		SP_tb					:		std_logic_vector(REG_MAX_INDEX downto 0);
		signal 		irOut_tb				:	 	std_logic_vector(REG_MAX_INDEX downto 0);

		
		
		type r_test_vector is record
			A_bus_tb, B_bus_tb, C_bus_tb : 	std_logic_vector(BUS_WIDTH-1 downto 0);
			clk_tb, rst_tb		:   	std_logic;		
			pmRdEn_tb			:	 	std_logic;		
			incPc_tb				:   	std_logic;
			ldPc_tb				: 		std_logic;				
			dmWRen_tb			:		std_logic;
			dmOutBusSel_tb		:		std_logic_vector(2 downto 0);	
			muxDMin_tb			:		std_logic_vector(1 downto 0);
			muxMAXinpSel_tb	:		std_logic_vector(1 downto 0);
			muxDMAdrSel_tb 	:		std_logic;
			pmOutBusSel_tb		:		std_logic_vector(2 downto 0);
			SP_tb					:		std_logic_vector(REG_MAX_INDEX downto 0);
			irOut_tb				:	 	std_logic_vector(REG_MAX_INDEX downto 0);
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
			pmRdEn_tb			=>		'0',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'0',			
			dmOutBusSel_tb		=>		"000",		
			muxDMin_tb			=>		"00",			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'0', 	
			pmOutBusSel_tb		=>		"000",		
			SP_tb					=>		"00000000000000",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		),
   -------------------------------------------
	---	Test Vector 1 - Read To IR 			
	-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			pmRdEn_tb			=>		'1',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'0',			
			dmOutBusSel_tb		=>		"000",		
			muxDMin_tb			=>		"00",			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'0', 	
			pmOutBusSel_tb		=>		"000",		
			SP_tb					=>		"00000000000000",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		),
  -------------------------------------------
	---	Test Vector 2 - Write IR to Bus A			
	-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			pmRdEn_tb			=>		'1',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'0',			
			dmOutBusSel_tb		=>		"000",		
			muxDMin_tb			=>		"00",			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'0', 	
			pmOutBusSel_tb		=>		"001",		
			SP_tb					=>		"00000000000000",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		),
  -------------------------------------------
	---	Test Vector 3 - Write on RAM		
	-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			pmRdEn_tb			=>		'1',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'1',			
			dmOutBusSel_tb		=>		"000",		
			muxDMin_tb			=>		"01", -- BusA			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'1', 	 -- SP
			pmOutBusSel_tb		=>		"001",		
			SP_tb					=>		"00000000000000",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		),
  -------------------------------------------
	---	Test Vector 3 - Read from RAM to bus B		
	-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			pmRdEn_tb			=>		'1',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'0',			
			dmOutBusSel_tb		=>		"000",		
			muxDMin_tb			=>		"00", -- BusA			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'1', 	 -- SP
			pmOutBusSel_tb		=>		"001",		
			SP_tb					=>		"00000000000000",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		),
  -------------------------------------------
	---	Test Vector 4 - Read from RAM to bus B	addr 1 via SP	
	-------------------------------------------		
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			pmRdEn_tb			=>		'1',			
			incPc_tb				=>		'0',				
			ldPc_tb				=>		'0',							
			dmWRen_tb			=>		'0',			
			dmOutBusSel_tb		=>		"010",		
			muxDMin_tb			=>		"00", -- BusA			
			muxMAXinpSel_tb	=>		"00",	
			muxDMAdrSel_tb		=>		'1', 	 -- SP
			pmOutBusSel_tb		=>		"000",		
			SP_tb					=>		"00000000000001",				
			irOut_tb				=>		"ZZZZZZZZZZZZZZ"	
		)		
	
	);
	

begin	
	UUT: 
	mmb_mem_unit port map (
			A_bus				=>		A_bus_tb,
			B_bus				=>		B_bus_tb,
			C_bus				=>		C_bus_tb,
			clk				=>		clk_tb,
			rst				=>		rst_tb,		
			pmRdEn			=>		pmRdEn_tb,
			pmOutBusSel		=>		pmOutBusSel_tb,
			incPc				=>		incPc_tb,	
			ldPc				=>		ldPc_tb,					
			dmWRen			=>		dmWRen_tb,		
			dmOutBusSel		=>		dmOutBusSel_tb,	
			muxDMin			=>		muxDMin_tb,		
			muxMAXinpSel	=>		muxMAXinpSel_tb,
			muxDMAdrSel		=>		muxDMAdrSel_tb, 
			SP					=>		SP_tb,				
			irOut				=>		irOut_tb	
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
			pmRdEn_tb				<=		test_vectors(i).pmRdEn_tb;
			pmOutBusSel_tb			<=		test_vectors(i).pmOutBusSel_tb;
			incPc_tb					<=		test_vectors(i).incPc_tb;	
			ldPc_tb					<=		test_vectors(i).ldPc_tb;					
			dmWRen_tb				<=		test_vectors(i).dmWRen_tb;		
			dmOutBusSel_tb			<=		test_vectors(i).dmOutBusSel_tb;	
			muxDMin_tb				<=		test_vectors(i).muxDMin_tb;		
			muxMAXinpSel_tb		<=		test_vectors(i).muxMAXinpSel_tb;
			muxDMAdrSel_tb			<=		test_vectors(i).muxDMAdrSel_tb; 
			SP_tb						<=		test_vectors(i).SP_tb;				
			irOut_tb					<=		test_vectors(i).irOut_tb;

			
			wait for period;
			
			clk_tb <= '1';
			
			wait for period;
			
--			ASSERT (
--			(A_bus_tb	<=		rf_test_vectors(i).A_bus_tb) AND
--			(B_bus_tb	<=		rf_test_vectors(i).B_bus_tb) AND
--			(C_bus_tb	<=		rf_test_vectors(i).C_bus_tb))
--			
--			REPORT "RF test vector " & INTEGER'IMAGE(i) & " failed"
--			SEVERITY error;			
			
			
			
		end loop;
		
		report "Test Bench Completed!";
		wait;
		end process;
	
	
end architecture lut;