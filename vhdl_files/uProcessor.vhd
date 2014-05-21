library IEEE;
use IEEE.std_logic_1164.all;

use work.commonPkg.all;


entity uProcessor is
	port(
		clk 	:	in		std_logic;
		clk2	:	in		std_logic;
		rst	:	in		std_logic
	);
end entity uProcessor;



architecture mmb_cpu of uProcessor is
	signal s_A_bus			:			std_logic_vector(BUS_WIDTH-1 downto 0)	:=	(others => 'Z');
	signal s_B_bus			:			std_logic_vector(BUS_WIDTH-1 downto 0)	:=	(others => 'Z');
	signal s_C_bus			:			std_logic_vector(BUS_WIDTH-1 downto 0)	:=	(others => 'Z');
	
	signal c0, c1, lkd	:	std_logic;
	
	
	
-- REGISTER FILE SIGNALS	
	signal 	s_rf_regSelA, s_rf_regSelB				:			std_logic_vector(15 downto 0);	
	signal 	s_rf_triSel									:			std_logic_vector(2 downto 0);
	signal 	s_rf_regSelOut_A, s_rf_regSelOut_B, s_rf_regSelOut_C : 	std_logic_vector(3 downto 0);
	signal	s_rf_srBusIn								:			std_logic_vector(1 downto 0);
	signal	s_rf_srBusOut								:			std_logic_vector(2 downto 0);
	
-- FUNCTIONAL UNIT SIGNALs
	signal 	s_fu_muxSelTA, s_fu_muxSelTB 	: 			 std_logic_vector(1 downto 0);
	signal	s_fu_ctGenSel						: 			 std_logic_vector(3 downto 0);
	signal 	s_fu_aluExec						: 			 std_logic;
	signal	s_fu_opSel							: 		 	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0);
	signal	s_fu_outSelTALU					:  		 std_logic_vector(2 downto 0);
	signal	s_fu_outSelTR						:  		 std_logic_vector(2 downto 0);
	signal	s_fu_outSelTSR						:  		 std_logic_vector(2 downto 0);

	
-- MEMORY UNIT SIGNALS
	signal	s_mu_ldIR				:	 		std_logic;		
	signal	s_mu_incPc				:   		std_logic;
	signal	s_mu_ldPc				: 			std_logic;				
	signal	s_mu_dmWRen				:			std_logic;
	signal	s_mu_dmOutBusSel		:			std_logic_vector(2 downto 0);	
	signal	s_mu_muxDMin			:			std_logic_vector(1 downto 0);
	signal	s_mu_muxMAXinpSel		:			std_logic_vector(1 downto 0);
	signal	s_mu_muxDMAdrSel 		:			std_logic;
	signal	s_mu_SP					:			std_logic_vector(REG_MAX_INDEX downto 0);
	signal	s_mu_irOut				:	 		std_logic_vector(REG_MAX_INDEX downto 0);	
	signal	s_mu_pmOutBusSel		:			std_logic_vector(2 downto 0);
	signal 	s_mu_muxPMAdrSel 		: 			std_logic;
	signal	s_mu_rstMAXreg			:			std_logic;
	
-- I/O-P UNIT SIGNALS
	signal	s_iop_addr				:			std_logic_vector(IOP_ADDR_BITS-1  downto 0);
	signal	s_iop_ldIPR				:			std_logic;
	signal	s_iop_outOPR			:			std_logic;
	signal	s_iop_outBusSel		:			std_logic_vector(1 downto 0);
	signal	s_iop_inBusSel			:			std_logic_vector(2 downto 0);
	
	signal	s_iop_p0					:			std_logic_vector(REG_MAX_INDEX downto 0); -- Peripheral to SP
	signal	s_iop_pX					:			std_logic_vector(REG_MAX_INDEX downto 0) := (others => 'Z'); -- Temporary Signal
	

begin

	resetProcess :
		process(rst) 
		begin
			if(rst = '1') then
				s_A_bus 	<= 	(others => 'Z');
				s_A_bus 	<= 	(others => 'Z');
				s_A_bus 	<= 	(others => 'Z');
			end if;
		end process resetProcess;


	registerFileBlock :
		registerFile port map (
			A_bus				=>		s_A_bus,
			B_bus				=>		s_B_bus,
			C_bus				=>		s_C_bus, 
			clk				=>		clk,
			rst				=>		rst,
			regSelA			=> 	s_rf_regSelA,
			regSelB 			=>		s_rf_regSelB,
			regSelOut_A		=>		s_rf_regSelOut_A,
			regSelOut_B		=>		s_rf_regSelOut_B,
			regSelOut_C		=>		s_rf_regSelOut_C,
			triSel 			=>		s_rf_triSel
--			srBusIn			=>		s_rf_srBusIn,
--			srBusOut			=>		s_rf_srBusOut	
		);

	
	functionalUnitBlock	:
		functionalUnit port map (
			A_bus				=>		s_A_bus,
			B_bus				=>		s_B_bus,
			C_bus				=>		s_C_bus,
			clk				=>		clk,
			rst				=>		rst,
			muxSelTA			=>		s_fu_muxSelTA,
			muxSelTB			=>		s_fu_muxSelTB, 	
			ctGenSel			=>		s_fu_ctGenSel, 
			aluExec			=>		s_fu_aluExec, 			
			opSel				=>		s_fu_opSel, 					
			outSelTALU		=>		s_fu_outSelTALU, 				
			outSelTR			=>		s_fu_outSelTR, 				
			outSelTSR		=>		s_fu_outSelTSR 				
		);
	
	memoryUnitBlock :
		mem_unit port map (
			A_bus				=>		s_A_bus,
			B_bus				=>		s_B_bus,
			C_bus				=>		s_C_bus,
			clk				=>		clk,
			clk2			=>		clk2,
			rst				=>		rst,		
			ldIR			=>		s_mu_ldIR,
			pmOutBusSel		=>		s_mu_pmOutBusSel,
			incPc				=>		s_mu_incPc,	
			ldPc				=>		s_mu_ldPc,					
			dmWRen			=>		s_mu_dmWRen,		
			dmOutBusSel		=>		s_mu_dmOutBusSel,	
			muxDMin			=>		s_mu_muxDMin,		
			muxMAXinpSel	=>		s_mu_muxMAXinpSel,
			muxDMAdrSel		=>		s_mu_muxDMAdrSel, 
			SP					=>		s_mu_SP,				
			irOut				=>		s_mu_irOut,
			muxPMAdrSel		=>	s_mu_muxPMAdrSel,
			rstMAXreg		=>		s_mu_rstMAXreg	
	);
	
	IOPUnit	:	
		iop_unit port map (
			A_bus				=>		s_A_bus,
			B_bus				=>		s_B_bus,
			C_bus 			=>		s_C_bus,
			clk				=>		clk,
			rst				=>		rst,
			addr				=>		s_iop_addr,
			outOPR			=>		s_iop_outOPR,
			ldIPR				=>		s_iop_ldIPR,
			outBusSel		=>		s_iop_outBusSel,
			inBusSel			=>		s_iop_inBusSel,
			p0					=>		s_iop_p0,
			p1					=>		s_iop_pX,
			p2					=>		s_iop_pX,
			p3					=>		s_iop_pX,
			p4					=>		s_iop_pX,
			p5					=>		s_iop_pX,
			p6					=>		s_iop_pX,
			p7					=>		s_iop_pX,
			p8					=>		s_iop_pX,
			p9					=>		s_iop_pX,
			p10				=>		s_iop_pX,
			p11				=>		s_iop_pX,
			p12				=>		s_iop_pX,
			p13				=>		s_iop_pX,
			p14				=>		s_iop_pX,
			p15				=>		s_iop_pX		
		);
	
	StackPointer :
		mmb_stackPointer port map (
			clk				=>		clk,
			rst				=>		rst,
			data				=>		s_iop_p0,
			addr				=>		s_iop_addr,
			readReq			=>		s_iop_ldIPR,
			writeReq			=>		s_iop_outOPR
		);
	
	s_mu_sp <= s_iop_p0;
	
	controlUnitBlock :
		controlUnit port map ( 
			A_bus				=>		s_A_bus,
			B_bus				=>		s_B_bus,
			C_bus				=>		s_C_bus,
			clk				=>		clk,
			rst				=>		rst,
			
			instrReg			=>		s_mu_irOut,
		
-- Register File Control Signals		
		
			rf_regSelA			=>		s_rf_regSelA,
			rf_regSelB			=>		s_rf_regSelB,
			rf_regSelOut_A		=>		s_rf_regSelOut_A,
			rf_regSelOut_B		=>		s_rf_regSelOut_B,
			rf_regSelOut_C		=>		s_rf_regSelOut_C,
			rf_triSel			=>		s_rf_triSel,
			rf_srBusIn			=>		s_rf_srBusIn,
			rf_srBusOut			=>		s_rf_srBusOut,
		
		
-- Functional Unit Control Signals		
			fu_muxSelTA			=>		s_fu_muxSelTA,
			fu_muxSelTB			=>		s_fu_muxSelTB,						
			fu_ctGenSel			=>		s_fu_ctGenSel,											
			fu_aluExec			=>		s_fu_aluExec,											
			fu_opSel				=>		s_fu_opSel,											
			fu_outSelTALU		=>		s_fu_outSelTALU,
			fu_outSelTR			=>		s_fu_outSelTR,
			fu_outSelTSR		=>		s_fu_outSelTSR,	
	

--	Memory Unit Control Signals
			mu_ldIR			=>		s_mu_ldIR,
			mu_incPc				=>		s_mu_incPc,
			mu_ldPc				=>		s_mu_ldPc,
			mu_dmWRen			=>		s_mu_dmWRen, 
			mu_dmOutBusSel		=>		s_mu_dmOutBusSel,
			mu_muxDMin			=>		s_mu_muxDMin,
			mu_muxMAXinpSel	=>		s_mu_muxMAXinpSel,
			mu_muxDMAdreSel	=>		s_mu_muxDMAdrSel, -- VERIFY STD_LOGIC OR VECTOR??
			mu_pmOutBusSel		=>		s_mu_pmOutBusSel,
			mu_muxPMAdrSel		=>		s_mu_muxPMAdrSel,
			
			iop_addr				=>		s_iop_addr,
			iop_ldIPR			=>		s_iop_ldIPR,
			iop_outOPR			=>		s_iop_outOPR,
			iop_outBusSel		=>		s_iop_outBusSel,
			iop_inBusSel		=>		s_iop_inBusSel,

-- CU Control Signals
			cu_rstMCounter		=>		s_mu_rstMAXreg			
			);
	
	
	
	

end architecture;