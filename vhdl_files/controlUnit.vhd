library IEEE;

use ieee.std_logic_1164.all;
use work.commonPkg.all;


entity controlUnit is
	port(
		clk, rst	:	in	std_logic;
		A_bus, B_bus, C_bus 	: 	in	 std_logic_vector(BUS_WIDTH-1 downto 0); -- Due status register

		instrReg					:	in		std_logic_vector(REG_MAX_INDEX downto 0);			
		
-- Register File Control Signals		
		
		rf_regSelA, rf_regSelB									:	out	std_logic_vector(15 downto 0);
		rf_regSelOut_A, rf_regSelOut_B, rf_regSelOut_C	:	out	std_logic_vector(3 downto 0);
		rf_triSel													:	out	std_logic_vector(2 downto 0);
		rf_srBusIn												:	out	std_logic_vector(1 downto 0);
		rf_srBusOut												:	out	std_logic_vector(2 downto 0);
		
		
-- Functional Unit Control Signals		
		fu_muxSelTA, fu_muxSelTB						:	out	std_logic_vector(1 downto 0);
		fu_ctGenSel											:	out 	std_logic_vector(3 downto 0);
		fu_aluExec											:	out	std_logic;
		fu_opSel												:	out	std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0);
		fu_outSelTALU, fu_outSelTR, fu_outSelTSR	:	out	std_logic_vector(2 downto 0);
	

--	Memory Unit Control Signals
		mu_ldIR, mu_incPc, mu_ldPc, mu_dmWRen 		: 	out	std_logic;
		mu_dmOutBusSel											:	out 	std_logic_vector(2 downto 0);
		mu_muxDMin,	mu_muxMAXinpSel						:	out	std_logic_vector(1 downto 0);
		mu_muxDMAdreSel										:	out	std_logic; -- CHECK!!!!
		mu_pmOutBusSel											:	out	std_logic_vector(2 downto 0);
		mu_muxPMAdrSel								:	out		std_logic;		
		
--		IOP Control Signals
		iop_ldIPR, iop_outOPR			:	out 	std_logic;
		iop_addr								:	out	std_logic_vector(IOP_ADDR_BITS-1 downto 0);
		iop_outBusSel						:	out	std_logic_vector(1 downto 0);
		iop_inBusSel						:	out	std_logic_vector(2 downto 0);
		
--	CU Control Signals
		cu_rstMCounter				:		out		std_logic	
	);	
end entity controlUnit;


architecture cu_arch of controlUnit is
	signal clkn : std_logic;
	signal ctrlSigBundle	:	std_logic_vector(99 downto 0);
	signal mCounterVal	:	std_logic_vector(2 downto 0);
	signal s_statusRegister	:	std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_srMuxOut		:		std_logic_vector(REG_MAX_INDEX downto 0);
	
	
-- Aliases	
	alias	s_iop_outOPR		:	std_logic							is	ctrlSigBundle(99);
	alias s_iop_ldIPR			:	std_logic							is	ctrlSigBundle(98);
	alias	s_iop_outBusSel	:	std_logic_vector(1 downto 0)	is	ctrlSigBundle(97 downto 96);
	alias	s_iop_inBusSel		:	std_logic_vector(2 downto 0)	is	ctrlSigBundle(95 downto 93);
	
	-- Free 80-92


	alias s_rf_regSelA 	  	: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(79 downto 78);
	alias s_rf_regSelB	  	: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(77 downto 76);
	
	alias s_rf_regSelOut_A 	: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(75 downto 74);-- Check the followin 3 signals
	alias s_rf_regSelOut_B 	: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(73 downto 72); -- They may should come just from IR
	alias s_rf_regSelOut_C 	: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(71 downto 70); -- CU just sends some enable signal	
	alias s_rf_triSel		  	:	std_logic_vector(2 downto 0)	is	ctrlSigBundle(69 downto 67);	
	alias s_rf_srBusIn		:	std_logic_vector(1 downto 0)	is	ctrlSigBundle(66 downto 65);
	alias s_rf_srBusOut		:	std_logic_vector(2 downto 0)	is	ctrlSigBundle(64 downto 62);
	-- Free 61 - 57	
	
	alias s_fu_muxSelTA		: 	std_logic_vector(1 downto 0)	is ctrlSigBundle(56 downto 55);
	alias s_fu_muxSelTB		: 	std_logic_vector(1 downto 0) 	is ctrlSigBundle(54 downto 53);
	--alias s_fu_ctGenSel		:	std_logic_vector(1 downto 0)	is	ctrlSigBundle(52 downto 51); -- based on RJ value
	-- Free 52-51
	
	
	alias s_fu_aluExec		:	std_logic							is	ctrlSigBundle(50);
	alias s_fu_outSelTALU	:	std_logic_vector(2 downto 0)	is ctrlSigBundle(49 downto 47);
	alias s_fu_outSelTR		:	std_logic_vector(2 downto 0)	is ctrlSigBundle(46 downto 44);
	alias s_fu_outSelTSR		:	std_logic_vector(2 downto 0)	is ctrlSigBundle(43 downto 41);
	-- Free 40
	
	alias s_mu_pmOutBusSel	:	std_logic_vector(2 downto 0) 	is ctrlSigBundle(39 downto 37);	
	alias s_mu_ldIR			:	std_logic							is ctrlSigBundle(36);
	alias s_mu_incPc			:	std_logic							is ctrlSigBundle(35);
	alias s_mu_ldPc			:	std_logic							is ctrlSigBundle(34);
	alias s_mu_dmWRen			:	std_logic							is ctrlSigBundle(33);
	
	alias s_mu_dmOutBusSel	:	std_logic_vector(2 downto 0)	is ctrlSigBundle(32 downto 30);

	alias s_mu_muxDMin		:	std_logic_vector(1 downto 0)	is ctrlSigBundle(29 downto 28);
	alias s_mu_muxMAXinpSel	:	std_logic_vector(1 downto 0)	is ctrlSigBundle(27 downto 26);
	alias s_mu_muxDMAdreSel	:	std_logic							is ctrlSigBundle(25);
	
	
	-- Free 24
	alias s_cu_srBusIn		:	std_logic_vector(1 downto 0)	is	ctrlSigBundle(22 downto 21);
	alias s_cu_uSelector		:	std_logic_vector(2 downto 0)	is	ctrlSigBundle(20 downto 18);
	alias s_cu_jmpAddrA		:	std_logic_vector(7 downto 0)	is ctrlSigBundle(17 downto 10);
	alias s_cu_jmpAddrB		:	std_logic_vector(7 downto 0)	is ctrlSigBundle(9 downto 2);
	alias s_cu_incMCounter	:	std_logic							is	ctrlSigBundle(1);
	alias s_cu_rstMCounter	:	std_logic							is	ctrlSigBundle(0);
	


	
	
	alias s_opCode				:	std_logic_vector(3 downto 0)	is instrReg(REG_MAX_INDEX downto REG_MAX_INDEX-3);
	alias s_instrSel 			:  std_logic_vector(1 downto 0) is instrReg(1 downto 0);
	alias s_ri_field			:	std_logic_vector(3 downto 0)	is	instrReg(9 downto 6);
	alias s_rj_field			:	std_logic_vector(3 downto 0)	is	instrReg(5 downto 2);
	
	signal s_rstMcounter		: 	std_logic;
	signal s_uPromAddr		:	std_logic_vector(7 downto 0);
	
	signal s_uSeqAddr			:	std_logic_vector(7 downto 0);
	
	signal s_regSelA_0		:	std_logic_vector(15 downto 0); -- RENAME MORE MEANINGFUL NAME
	signal s_regSelB_0		:	std_logic_vector(15 downto 0); -- RENAME MORE MEANINGFUL NAME
	signal s_regSelA_1		:	std_logic_vector(15 downto 0); -- RENAME MORE MEANINGFUL NAME
	signal s_regSelB_1		:	std_logic_vector(15 downto 0); -- RENAME MORE MEANINGFUL NAME
	
	
	signal s_regsSelA			:	std_logic_vector(15 downto 0); -- NAMES SIMILAR TO OTHER ALIAS
	signal s_regsSelB			:	std_logic_vector(15 downto 0); -- RENAME IT!
	
	signal s_busOut_0			:	std_logic_vector(3 downto 0);
	signal s_busOut_1			:	std_logic_vector(3 downto 0);
	signal s_busOut_2			:	std_logic_vector(3 downto 0);	

	signal s_busOut_0_ri		:	std_logic_vector(3 downto 0);
	signal s_busOut_1_ri		:	std_logic_vector(3 downto 0);
	signal s_busOut_2_ri		:	std_logic_vector(3 downto 0);		

	signal s_busOut_0_rj		:	std_logic_vector(3 downto 0);
	signal s_busOut_1_rj		:	std_logic_vector(3 downto 0);
	signal s_busOut_2_rj		:	std_logic_vector(3 downto 0);	

	
	signal s_iop_addr			:	std_logic_vector(IOP_ADDR_BITS-1 downto 0);
	
	signal s_mu_muxPMAdrSel 	: 	std_logic;
	
	
	
begin
	
	clkn	<=	NOT clk;
	s_rstMCounter	<=	rst OR s_cu_rstMCounter;
	cu_rstMCounter 	<=	s_cu_rstMCounter;	
	
--	STATUS REGISTER
	muxIn:	
		mux4to1 port map (
			a			=>		A_bus,
			b			=>		B_bus,
			c			=>		C_bus,
			d			=>		s_statusRegister,
			muxSel	=>		s_cu_srBusIn,
			muxOut	=>		s_srMuxOut
		);	
		
	StatusRegister :		
		register14b port map(
			clk	=>		clk,
			rst	=>		rst,
			din	=>		s_srMuxOut,
			dout	=>		s_statusRegister
		);	
	
	
	
	mCounter	:	
		counter3bit port map (
			clk	=>	clk,
			rst	=>	s_rstMCounter,
			inc	=> s_cu_incMCounter,
			q		=> mCounterVal		
		);
		
	uSeq	:
		cu_uSequencer port map(
			clk			=>		clkn,
			instrReg		=>		instrReg,
			statusReg	=>		s_statusRegister,			
			rst			=>		rst,
			mcCycle		=> 	mCounterVal,
			uSelector	=>		s_cu_uSelector,
			jmpAddrA		=>		s_cu_jmpAddrA,
			jmpAddrB		=>		s_cu_jmpAddrB,
			jmpLdPC		=>		s_mu_muxPMAdrSel,
			outAddr		=>		s_uSeqAddr
		);
		
	s_uPromAddr		<= s_uSeqAddr; 
		
		
	uProm	:
		cu_rom port map ( 
			clock		=>	clkn,
			address	=>	s_uPromAddr,
			q			=> ctrlSigBundle		
		);
	

	rfSelSetterA :
		rfMuxSetter port map( 
			bitA		=>		s_rf_regSelA(1),
			bitB		=>		s_rf_regSelB(1),
			regNum	=>		s_ri_field,
			regSelA	=>		s_regSelA_0,
			regSelB 	=>		s_regSelB_0
		);
		
	
	rfSelSetterB :
		rfMuxSetter port map( 
			bitA		=>		s_rf_regSelA(0),
			bitB		=>		s_rf_regSelB(0),
			regNum	=>		s_rj_field,
			regSelA	=>		s_regSelA_1,
			regSelB 	=>		s_regSelB_1
		);
		
		
		s_regsSelA	<= 	s_regSelA_0 OR s_regSelA_1;		
		s_regsSelB 	<= 	s_regSelB_0 OR s_regSelB_1;
		
		
		-- ADD RI AND RJ OPTION??
		s_busOut_0_ri	<=		(s_rf_regSelOut_A(1)&s_rf_regSelOut_A(1)&s_rf_regSelOut_A(1)&s_rf_regSelOut_A(1)) AND s_ri_field;
		s_busOut_1_ri	<=		(s_rf_regSelOut_B(1)&s_rf_regSelOut_B(1)&s_rf_regSelOut_B(1)&s_rf_regSelOut_B(1)) AND s_ri_field;
		s_busOut_2_ri	<=		(s_rf_regSelOut_C(1)&s_rf_regSelOut_C(1)&s_rf_regSelOut_C(1)&s_rf_regSelOut_C(1)) AND s_ri_field;
		
		s_busOut_0_rj	<=		(s_rf_regSelOut_A(0)&s_rf_regSelOut_A(0)&s_rf_regSelOut_A(0)&s_rf_regSelOut_A(0)) AND s_rj_field;
		s_busOut_1_rj	<=		(s_rf_regSelOut_B(0)&s_rf_regSelOut_B(0)&s_rf_regSelOut_B(0)&s_rf_regSelOut_B(0)) AND s_rj_field;
		s_busOut_2_rj	<=		(s_rf_regSelOut_C(0)&s_rf_regSelOut_C(0)&s_rf_regSelOut_C(0)&s_rf_regSelOut_C(0)) AND s_rj_field;
		
		
		s_busOut_0		<=		s_busOut_0_ri OR s_busOut_0_rj;
		s_busOut_1		<=		s_busOut_1_ri OR s_busOut_1_rj;
		s_busOut_2		<=		s_busOut_2_ri OR s_busOut_2_rj;
		
		
-- I/O-P Addressing
		s_iop_addr		<=		s_rj_field; -- Last RJ val
		
		
		
		--Outputs
		
		rf_regSelA		<=		s_regsSelA;
		rf_regSelB		<=		s_regsSelB;
		rf_regSelOut_A	<=		s_busOut_0;
		rf_regSelOut_B	<=		s_busOut_1;
		rf_regSelOut_C	<=		s_busOut_2;
		rf_triSel		<=		s_rf_triSel;
		rf_srBusIn		<=		s_rf_srBusIn;
		rf_srBusOut		<=		s_rf_srBusOut;

		
	
		fu_muxSelTA		<=		s_fu_muxSelTA;
		fu_muxSelTB		<=		s_fu_muxSelTB;
		fu_ctGenSel		<=		s_rj_field(3 downto 0);					
		fu_aluExec		<=		s_fu_aluExec;
		fu_opSel			<=		s_opCode & s_instrSel;
		fu_outSelTALU	<=		s_fu_outSelTALU;
		fu_outSelTR		<=		s_fu_outSelTR;
		fu_outSelTSR	<=		s_fu_outSelTSR;	
	

--	Memory Unit Control Signals
		mu_ldIR		<=		s_mu_ldIR or rst;
		mu_incPc			<=		s_mu_incPc;
		mu_ldPc			<=		s_mu_ldPc;
		mu_dmWRen		<=		s_mu_dmWRen;
		mu_dmOutBusSel	<=		s_mu_dmOutBusSel;
		mu_muxDMin		<=		s_mu_muxDMin;
		mu_muxMAXinpSel<=		s_mu_muxMAXinpSel;
		mu_muxDMAdreSel<=		s_mu_muxDMAdreSel;
		mu_pmOutBusSel	<=		s_mu_pmOutBusSel;
		mu_muxPMAdrSel	<=		s_mu_muxPMAdrSel;
		
--	I/O-P Control Signals
		iop_outOPR		<=		s_iop_outOPR;
		iop_ldIPR		<=		s_iop_ldIPR;
		iop_addr			<=		s_iop_addr;
		iop_outBusSel	<=		s_iop_outBusSel;
		iop_inBusSel	<=		s_iop_inBusSel;	

end architecture cu_arch;

library IEEE;


use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.commonPkg.all;



entity rfMuxSetter is
	port (
		bitA 					:		in		std_logic;
		bitB					:		in		std_logic;
		regNum				:		in		std_logic_vector(REG_FIELD_SIZE-1 downto 0);
		regSelA, regSelB	:		out	std_logic_vector(NUM_REGS-1 downto 0)
	);
end entity rfMuxSetter;


architecture rfMuxSetter of rfMuxSetter is
	signal s_selA 		:		unsigned(NUM_REGS-1 downto 0) := (others => '0');
	signal s_selB		:		unsigned(NUM_REGS-1 downto 0) := (others => '0');
		
begin

	s_selA(0) <= bitA;
	s_selB(0) <= bitB;
	
	regSelA <= std_logic_vector( s_selA sll to_integer( unsigned(regNum) ) );
	regSelB <= std_logic_vector( s_selB sll to_integer( unsigned(regNum) ) );

end architecture rfMuxSetter;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.commonPkg.all;



entity cu_uSequencer is
	port(
		clk		:	in		std_logic;
		instrReg	:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		statusReg:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		rst		:	in		std_logic;
		mcCycle	:	in		std_logic_vector(2 downto 0);
		uSelector:	in		std_logic_vector(2 downto 0);
		jmpAddrA	:	in		std_logic_vector(7 downto 0);
		jmpAddrB	:	in		std_logic_vector(7 downto 0);
		jmpLdPC		:	out		std_logic;
		outAddr	:	out	std_logic_vector(7 downto 0)		
	);
end entity cu_uSequencer;




architecture cu_sequencer of cu_uSequencer is
	signal s_opcode : std_logic_vector(OPSEL_SIZE+INSTRSEL_SIZE-1 downto 0);
	signal s_addr	 :	std_logic_vector(7 downto 0);
	signal s_jmpLdPC :	std_logic;
	
	alias	opCode		:	std_logic_vector(3 downto 0) 	is		instrReg(13 downto 10);
	alias instrSel		:	std_logic_vector(1 downto 0) 	is		instrReg(1 downto 0); -- MODIFY TO GENERIC
	
-- For jump instructions	
	alias jmpConds		:	std_logic_vector(3 downto 0)	is		instrReg(9 downto 6);
	alias condC			:	std_logic		is		instrReg(9);
	alias condN			:	std_logic		is		instrReg(8);
	alias condV			:	std_logic		is		instrReg(7);
	alias condZ			:	std_logic		is		instrReg(6);
	
-- System Status
	alias	flags			:	std_logic_vector(3 downto 0) 	is		statusReg(13 downto 10);
	alias C				:	std_logic		is		statusReg(13);
	alias N				:	std_logic		is		statusReg(12);
	alias V				:	std_logic		is		statusReg(11);
	alias Z				:	std_logic		is		statusReg(10);
	
	
	-- Free bits 5-4
	alias addrMode		:	std_logic_vector(1 downto 0)	is 	instrReg(3 downto 2); -- (0 => Direct AM, 1 => PC Relative AM, 2 => SP, 3=> R3_value)
	
	
	
begin
	s_opcode <= opCode & instrSel;
	
	op :
	process(mcCycle, rst)
		variable v_jmpLdPC : std_logic := '0';
	begin
		v_jmpLdPC := '0';
						
			if(rst = '1') then
				s_addr	<= 	"11111111";
				
			--elsif(rising_edge(clk)) then
				elsif(mcCycle = "001") then
					-- The addr may be automated by setting the opCode+InstrSel
					-- As the same addr inside the uProgram memory
					-- This way the HW uSequencer is not needed
						
						if(opCode(3 downto 2) = "11") then -- Same uInstruction to conditional jumps
																	  -- Use uSelector instead
							s_addr <= "00110000";
						else
							s_addr	<=	"00" & s_opcode;
						end if;
						
				elsif(uSelector = "011") then
				--elsif(mcCycle = "010" AND opCode(3 downto 2) = "11") then -- Jump Instruction				
					if( unsigned(flags AND jmpConds) > 0 ) then -- Some condition where satisfied
						s_addr	<=		jmpAddrB;
						v_jmpLdPC := '1'; -- force PC load due conditional jmp
					else
						s_addr	<=		jmpAddrA;
					end if;				
				else
					s_addr	<= jmpAddrA;					
				end if;	
				s_jmpLdPC	<=	v_jmpLdPC;
		end process op;
		
		outAddr <= s_addr;
		jmpLdPC <= s_jmpLdPC;
					
		
end architecture cu_sequencer;
