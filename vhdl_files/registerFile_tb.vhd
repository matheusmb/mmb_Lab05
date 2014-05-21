LIBRARY ieee;
USE ieee.std_logic_1164.all;

use work.mmb_dcs.all;

entity mmb_registerFile_tb is
end entity mmb_registerFile_tb;

architecture lut of mmb_registerFile_tb is
component mmb_registerFile is
	port(
		A_bus, B_bus, C_bus : inout std_logic_vector(13 downto 0);
		clk, rst : in std_logic;
		regSelA, regSelB : in std_logic_vector(15 downto 0); -- Mux Selector register in
		regSelOut_A, regSelOut_B, regSelOut_C : in std_logic_vector(3 downto 0); -- Mux selec register out
		triSel : in std_logic_vector(2 downto 0)
	);

end component mmb_registerFile;
		signal 		A_bus_tb, B_bus_tb, C_bus_tb :	std_logic_vector(BUS_WIDTH-1 downto 0);
		signal 		clk_tb, rst_tb		:   	std_logic;		
		signal 		regSelA_tb, regSelB_tb : std_logic_vector(15 downto 0); 
		signal 		regSelOut_A_tb, regSelOut_B_tb, regSelOut_C_tb :  std_logic_vector(3 downto 0);
		signal		triSel_tb :  std_logic_vector(2 downto 0);

		
		
		type r_test_vector is record
			A_bus_tb, B_bus_tb, C_bus_tb : 	std_logic_vector(BUS_WIDTH-1 downto 0);
			clk_tb, rst_tb		:   	std_logic;		
			regSelA_tb, regSelB_tb : std_logic_vector(15 downto 0); 
			regSelOut_A_tb, regSelOut_B_tb, regSelOut_C_tb :  std_logic_vector(3 downto 0);
			triSel_tb : std_logic_vector(2 downto 0);
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
			regSelA_tb			=>		"0000000000000000",
			regSelB_tb 			=>		"0000000000000000",
			regSelOut_A_tb		=>		"0000",
			regSelOut_B_tb		=>		"0000",
			regSelOut_C_tb 	=>		"0000",
			triSel_tb 			=>		"000"
		),
   -------------------------------------------
	---	Test Vector 1 - Write on Reg 1 from BUS B			
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"10101010101010",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			regSelA_tb			=>		"0000000000000010",
			regSelB_tb 			=>		"0000000000000000",
			regSelOut_A_tb		=>		"0000",
			regSelOut_B_tb		=>		"0000",
			regSelOut_C_tb 	=>		"0000",
			triSel_tb 			=>		"000"
		),		
   -------------------------------------------
	---	Test Vector 2 - Read from Reg 1 to BUS A			
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			regSelA_tb			=>		"0000000000000000",
			regSelB_tb 			=>		"0000000000000000",
			regSelOut_A_tb		=>		"0001",
			regSelOut_B_tb		=>		"0000",
			regSelOut_C_tb 	=>		"0000",
			triSel_tb 			=>		"001"
		),
   -------------------------------------------
	---	Test Vector 3 - Read from Reg 15 to BUS C		
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			regSelA_tb			=>		"0000000000000000",
			regSelB_tb 			=>		"0000000000000000",
			regSelOut_A_tb		=>		"0000",
			regSelOut_B_tb		=>		"0000",
			regSelOut_C_tb 	=>		"1111",
			triSel_tb 			=>		"100"
		),
   -------------------------------------------
	---	Test Vector 4 - Read from Reg 1 to Bus A; Write from Reg 15 from BUS C		
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			regSelA_tb			=>		"1000000000000000",
			regSelB_tb 			=>		"1000000000000000",
			regSelOut_A_tb		=>		"0000",
			regSelOut_B_tb		=>		"0000",
			regSelOut_C_tb 	=>		"0001",
			triSel_tb 			=>		"100"
		),
	-------------------------------------------
	---	Test Vector 5 - Read from Reg 15 to BUS B	
	-------------------------------------------
		(
			A_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			B_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			C_bus_tb				=>		"ZZZZZZZZZZZZZZ",
			clk_tb				=>		'0',
			rst_tb				=>		'0',		
			regSelA_tb			=>		"0000000000000000",
			regSelB_tb 			=>		"0000000000000000",
			regSelOut_A_tb		=>		"0000",
			regSelOut_B_tb		=>		"1111",
			regSelOut_C_tb 	=>		"0000",
			triSel_tb 			=>		"010"
		)
	);
	

begin	
	UUT: 
	mmb_registerFile port map (
			A_bus				=>		A_bus_tb,
			B_bus				=>		B_bus_tb,
			C_bus				=>		C_bus_tb,
			clk				=>		clk_tb,
			rst				=>		rst_tb,		
			regSelA			=>		regSelA_tb,
			regSelB 			=>		regSelB_tb ,
			regSelOut_A		=>		regSelOut_A_tb,
			regSelOut_B		=>		regSelOut_B_tb,
			regSelOut_C 	=>		regSelOut_C_tb,
			triSel 			=>		triSel_tb
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
			regSelA_tb				<=		test_vectors(i).regSelA_tb;
			regSelB_tb 				<=		test_vectors(i).regSelB_tb;
			regSelOut_A_tb			<=		test_vectors(i).regSelOut_A_tb;
			regSelOut_B_tb			<=		test_vectors(i).regSelOut_B_tb;
			regSelOut_C_tb 		<=		test_vectors(i).regSelOut_C_tb;
			triSel_tb 				<=		test_vectors(i).triSel_tb;
			
			wait for period;
			
			clk_tb <= '1';
			
			wait for period;
				
			
		end loop;
		
		report "Test Bench Completed!";
		wait;
		end process;
	
	
end architecture lut;