library IEEE;

use ieee.std_logic_1164.all;
use work.commonPkg.all;

entity mem_unit is
	port (
		A_bus, B_bus, C_bus : inout	std_logic_vector(BUS_WIDTH-1 downto 0);
		clk, clk2, rst		:  in 	std_logic;		
		ldIR		:	in 	std_logic;		
		incPc			:  in 	std_logic;
		ldPc			: 	in		std_logic;				
		dmWRen		:	in		std_logic;
		dmOutBusSel	:	in		std_logic_vector(2 downto 0);	
		muxDMin		:	in		std_logic_vector(1 downto 0);
		muxMAXinpSel:	in		std_logic_vector(1 downto 0);
		muxDMAdrSel :	in		std_logic;
		pmOutBusSel	:	in		std_logic_vector(2 downto 0);
		SP				:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		irOut			:	out 	std_logic_vector(REG_MAX_INDEX downto 0);
		muxPMAdrSel	:	in		std_logic;
		rstMAXreg	:	in		std_logic
	);

end entity mem_unit;

architecture mem_unit_arch of mem_unit is
	signal registers	:	std_logic_vector(4*REGISTER_SIZE-1 downto 0);
	signal PMOut		:	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_muxDMin	: 	std_logic_vector(BUS_WIDTH-1 downto 0);
	signal s_dmOut		: 	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_muxAdrOut:	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_Aeff		: 	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_muxGenAdr:	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_PCin		:	std_logic_vector(REG_MAX_INDEX downto 0);
	
	signal s_updateIR:	std_logic;
	
	signal clkn   	:  std_logic;
	
	alias instrReg : std_logic_vector(REG_MAX_INDEX downto 0) is registers(REG_MAX_INDEX downto 0);
	alias	PCreg		: std_logic_vector(REG_MAX_INDEX downto 0) is registers(2*REGISTER_SIZE-1 downto REGISTER_SIZE);
	alias MAXreg	: std_logic_vector(REG_MAX_INDEX downto 0) is registers(3*REGISTER_SIZE-1 downto 2*REGISTER_SIZE);
	alias	MABreg	: std_logic_vector(REG_MAX_INDEX downto 0) is registers(4*REGISTER_SIZE-1 downto 3*REGISTER_SIZE);
	
	signal s_lastAeffVal	:	std_logic_vector(REG_MAX_INDEX downto 0);
	
	signal s_rstMAXreg		:	std_logic;
	
begin
-- Program Memory Block
	pm_rom :
		rom port map(
			address	 =>	PCreg,
			clock		 =>	clk,
			rden		 => 	'1',
			q			 => 	PMout
		);
		

-- Allow program memory go to the bus		
	DecoderPMtoBus :	
		decoder1to3 port map(
		  a		=>		A_bus,
		  b		=>		B_bus,
		  c		=>		C_bus,
		  din		=>		PMout,
		  chSel	=>		pmOutBusSel
		);	
		
	clkn <=  NOT clk;
	--s_updateIR <= clkn AND ldIR;
	s_updateIR <= clk2 AND ldIR;
	
	InstructionReg	:
		register14b port map(
				clk	=>		s_updateIR,
				rst	=>		'0',
				din	=>		PMout,
				dout	=>		instrReg
		);

		
	PogramCounter	:
		program_counter port map	(
			clk		=>	clk2,
			rst		=> rst,
			aEff		=> s_PCin,
			adOut		=> PCreg,
			incPc		=> incPc,
			ldPc		=>	ldPc
		);
	
	LastPCVal : -- Stores the last PC value to use on conditional jmps
		register14b port map(
			din  => s_Aeff,
		     clk  => clk2,
		     rst  => rst,
		     dout => s_lastAeffVal
		 );
		 
	MuxPMAdr : -- Select the Pm adr between the last PC Val ou the New one
		mux2to1	port map(
			a      => s_Aeff,
		     b      => s_lastAeffVal,
		     muxSel => muxPMAdrSel,
		     muxOut => s_PCin);	 

		irOut <= instrReg;	
-- End of Program Memory Block

-- Data Memory Block

	MuxDm_in 	:
		mux4to1 port map (
			a		 =>	A_bus,
			b		 => 	B_bus,
			c		 =>	C_bus,
			d		 =>	PCreg,
			muxSel =>	muxDMin,
			muxOut =>	s_muxDMin
		);
		
	MuxAddr_DM	:
		mux2to1 port map(
			a			=>	s_Aeff,
			b 			=> SP,
			muxSel	=> muxDMAdrSel,
			muxOut	=>	s_muxAdrOut			
		);


	dm_ram	:
		ram port map (
			address	=> s_muxAdrOut,
			clock		=> clk2,
			data		=> s_muxDMin,
			wren		=> dmWRen,
			q			=> s_dmOut
		);
		
		
	decoderPmOut	:
		decoder1to3 port map (
			a 		=> A_bus,
			b 		=> B_bus,
			c 		=> C_bus,
			din 	=> s_dmOut,
			chSel	=> dmOutBusSel
		);
		
		RegisterMab	:
			register14b port map (
				clk	=>	clkn,
				rst	=> rst,
				din	=> PMout,
				dout	=> MABreg
			);
		
		MuxGenAddr_DM	:
			mux4to1 port map (
				a			=> A_bus,
				b			=>	B_bus,
				c			=>	C_bus,
				d			=>	MAXreg,
				muxOut	=> s_muxGenAdr,
				muxSel	=> muxMAXinpSel
			);
			
		s_rstMAXreg	<=	rstMAXreg OR rst;
			
		RegisterMax :
			register14b port map( 
				clk		=> clk,
				rst		=> s_rstMAXreg,
				din		=> s_muxGenAdr,
				dout		=> MAXreg
			);
			
		CalcAeff	:
			sum2inp	port map (
				a 		 => MABreg,
				b 		 => MAXReg,
				result => s_Aeff
			);
			
		


-- End Data Memory Block		
end architecture mem_unit_arch;

library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.commonPkg.all;



entity sum2inp is
	port (
		a, b	:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		result:	out	std_logic_vector(REG_MAX_INDEX downto 0)
	);
end entity sum2inp;



architecture sum_arch of sum2inp is
begin
	
	result <= std_logic_vector( unsigned(a) + unsigned(b) );

end architecture sum_arch;

library IEEE;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.commonPkg.all;

entity program_counter is 
	port(
		clk, rst	:	in std_logic;
		aEff		: 	in std_logic_vector(REG_MAX_INDEX downto 0);		
		incPc		: 	in std_logic;
		ldPc		: 	in std_logic;
		adOut		:  out std_logic_vector(REG_MAX_INDEX downto 0) -- find better names
	);
end entity program_counter;


architecture pc_arch of program_counter is	
	signal addr		: 	unsigned(REG_MAX_INDEX downto 0) := (others => '0');
	signal clkEn 	: std_logic;
	signal s_adOut	:	std_logic_vector(REG_MAX_INDEX downto 0);
begin
	clkEn 	<=	(ldPc or incPc) AND clk;
	
	reg	:	
		register14b port map (
			clk 	=>		clkEn,
			rst	=>		rst,
			din	=>		std_logic_vector(addr),
			dout	=>		s_adOut
		);
		
		adOut <=	s_adOut;
		
		inc	: 
		process(clk)
			--variable tmpAddr : unsigned(REG_MAX_INDEX downto 0) := ;
		begin
			if(rising_edge(clk) and rst = '0') then
				--tmpAddr := unsigned(s_adOut);
			
				if(ldPc = '1') then
					addr <=	unsigned(aEff);
					
				elsif(incPc = '1') then
					addr <= unsigned(s_adOut) + 1;
				end if;
				
				--addr <= tmpAddr;

			end if;
		end process inc;
		

end architecture pc_arch;