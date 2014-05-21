LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

PACKAGE commonPkg IS


----------------- GENERAL CONSTANTS ----------------------
	
	constant BUS_WIDTH 		: integer := 14;
	constant REGISTER_SIZE	: integer := BUS_WIDTH;
	constant	REG_MAX_INDEX	: integer := REGISTER_SIZE-1;
	
	constant	INSTRSEL_SIZE	: integer := 4;
	constant	OPSEL_SIZE		: integer := 2;
	
	constant CU_MEM_SIZE		: integer := 5;
	constant NUM_REGS			: integer := 16;
	constant REG_FIELD_SIZE	: integer := 4;
	
	constant IOP_ADDR_BITS	: integer := 4; -- 4 bits for addressing the I/O-P Unit

-------------- ALU CONSTANTS --------------------
	constant ALU_OP_FIELD_SIZE : integer := INSTRSEL_SIZE+OPSEL_SIZE; 
	
	
	
--	constant ALU_OP_ADD  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00000";
--	constant ALU_OP_ADDC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00001";
--	constant ALU_OP_SUB  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00010";
--	constant ALU_OP_SUBC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00011";
--	
--	constant ALU_OP_MUL  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00100";
--	constant ALU_OP_DIV  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00101";
--	constant ALU_OP_MULC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00110";
--	constant ALU_OP_DIVC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "00111";
--	
--	constant ALU_OP_NOT  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "01000";
--	constant ALU_OP_AND  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "01001";
--	constant ALU_OP_OR	: std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "01010";
--	constant ALU_OP_XOR  : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "01011";
--	
--	constant ALU_OP_SHLL : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "10000";
--	constant ALU_OP_SHRL : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "10001";
--	constant ALU_OP_SHLA : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "10010";
--	constant ALU_OP_SHRA : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "10011";
--	
--	constant ALU_OP_ROTL : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "11000";
--	constant ALU_OP_ROTR : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "11001";
--	constant ALU_OP_RTLC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "11010";
--	constant ALU_OP_RTRC : std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) := "11011";

	
	constant ALU_OP_ADD	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000000";
	constant ALU_OP_SUB	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000001";
	constant ALU_OP_ADDC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000010";
	constant ALU_OP_SUBC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000011";

	constant ALU_OP_MUL	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000100";
	constant ALU_OP_DIV	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000101";
	constant ALU_OP_MULC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000110";
	constant ALU_OP_DIVC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "000111";

	constant ALU_OP_NOT	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001000";
	constant ALU_OP_AND	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001001";
	constant ALU_OP_OR	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001010";
	constant ALU_OP_XOR	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001011";

	constant ALU_OP_SHLL	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001100";
	constant ALU_OP_SHRL	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001101";
	constant ALU_OP_SHLA	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001110";
	constant ALU_OP_SHRA	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "001111";

	constant ALU_OP_ROTL	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "010000";
	constant ALU_OP_ROTR	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "010001";
	constant ALU_OP_RTLC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "010010";
	constant ALU_OP_RTRC	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "010011";



	
-- DATA TRANSFERS
	constant ALU_OP_CPY	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "101100";
	constant ALU_OP_SWAP	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "101101";
	
-- SIMD INSTRUCTIONS	
	constant ALU_OP_ADDV	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "011000";
	constant ALU_OP_SUBV	:	 std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0) :=  "011001";


	
	

	
	
	
-------------- COMPONENTS DECLARATION --------------------
	component mux4to1 is
		Port(
			a, b, c, d  : in std_logic_vector(13 downto 0); -- 4 channels of 14 bits each
			muxSel : in std_logic_vector(1 downto 0);
			muxOut : out std_logic_vector(13 downto 0)		
		);
	end component mux4to1;

	component mux16to1 is
		Port(
			  x0,  x1,  x2,  x3,
			  x4,  x5,  x6,  x7,
			  x8,  x9, x10, x11,
			 x12, x13, x14, x15 : in std_logic_vector(13 downto 0); -- 16 channels of 14 bits each
			 
			 muxSel : in std_logic_vector(3 downto 0);
			 muxOut : out std_logic_vector(13 downto 0)		
		);
	end component mux16to1;

	component register14b is
		Port(
			  din  : in std_logic_vector(13 downto 0);
			  clk  : in std_logic;
			  rst  : in std_logic;
			  dout : out std_logic_vector(13 downto 0)
		);
	end component register14b;

	component triState is
		port(
			din  : in std_logic_vector(13 downto 0);
			s	  : std_logic;
			dout : out std_logic_vector(13 downto 0)
		);
	end component triState;

	component fu_ct_gen is
		port(
			fu_ct_sel : in std_logic_vector(3 downto 0);
			fu_ct_out : out std_logic_vector(13 downto 0)
		);
	end component fu_ct_gen;
	
	component decoder1to3 is
		port(
			  a, b, c : out std_logic_vector(BUS_WIDTH-1 downto 0);
			  din 	 : in  std_logic_vector(BUS_WIDTH-1 downto 0);
			  chSel	 : in  std_logic_vector(2 downto 0)
		);
	end component decoder1to3;

	component fu_alu is
		port(
			opSel 		 	: in std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0); -- 5 bits - more or less?
			clk, rst		 	: in std_logic;
			aluExec			: in std_logic;
			inpA, inpB 	 	: in signed(13 downto 0);
			talu, tr, tsr  : out std_logic_vector(13 downto 0)
		);
	end component fu_alu;
	

	component rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		rden		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
	end component rom;

	component program_counter is 
	port(
		clk, rst	:	in std_logic;
		aEff		: 	in std_logic_vector(REG_MAX_INDEX downto 0);		
		adOut		:  out std_logic_vector(REG_MAX_INDEX downto 0); -- find better names
		incPc		: 	in std_logic;
		ldPc		: 	in std_logic
	);
	end component program_counter;
	
	component ram IS
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
	end component ram;
	
	component mux2to1 is
	port(
		a, b	 : in std_logic_vector(13 downto 0);
		muxSel : in std_logic;
		muxOut : out std_logic_vector(13 downto 0)		
	);
	end component mux2to1;
	
	component sum2inp is
	port (
		a, b	:	in		std_logic_vector(REG_MAX_INDEX downto 0);
		result:	out	std_logic_vector(REG_MAX_INDEX downto 0)
	);
	end component sum2inp;
	
	component counter2bit is
	port(
		clk, rst		:	in		std_logic;
		inc			:	in		std_logic;
		q				:	out	std_logic_vector(1 downto 0)
	);
	end component counter2bit;
	
	component counter3bit is
	port(
		clk, rst		:	in		std_logic;
		inc			:	in		std_logic;
		q				:	out	std_logic_vector(2 downto 0)
	);
	end component counter3bit;
	
	component cu_rom is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (99 DOWNTO 0)
	);
	end component cu_rom;
	
	
	component cu_uSequencer is
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
	end component cu_uSequencer;
	
	
	

	component rfMuxSetter is
		port (
			bitA 					:		in		std_logic;
			bitB					:		in		std_logic;
			regNum				:		in		std_logic_vector(REG_FIELD_SIZE-1 downto 0);
			regSelA, regSelB	:		out	std_logic_vector(NUM_REGS-1 downto 0)
		);
	end component rfMuxSetter;	

	
	component registerFile is
	port(
		A_bus, B_bus, C_bus 							:		inout std_logic_vector(13 downto 0);
		clk, rst											:		in 	std_logic;
		regSelA, regSelB								: 		in 	std_logic_vector(15 downto 0); -- Mux Selector register in
		regSelOut_A, regSelOut_B, regSelOut_C 	: 		in 	std_logic_vector(3 downto 0); -- Mux selec register out
		triSel 											: 		in 	std_logic_vector(2 downto 0)
	);
	end component registerFile;
	
	component functionalUnit is
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
	end component functionalUnit;

	component mem_unit is
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
		muxPMAdrSel		:	in		std_logic;
		rstMAXreg		:	in		std_logic
	);
	end component mem_unit;

	component controlUnit is
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
	end component controlUnit;


	component mmb_pll is
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
	end component mmb_pll;
	
-- I/O-P Unit
	component iop_unit is
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
	end component iop_unit;

	component iop_pad_in is
		port (
			ch			:		out		std_logic_vector(REG_MAX_INDEX downto 0);
			chSel		:		in			std_logic_vector(3 downto 0);
			en			:		in			std_logic;
			x0, x1, x2, x3,
			x4, x5, x6, x7,
			x8, x9, x10, x11,
			x12, x13, x14, x15 :	in 	std_logic_vector(REG_MAX_INDEX downto 0)
		);
	end component iop_pad_in;

	component iop_pad_out is
		port (
			ch			:		in			std_logic_vector(REG_MAX_INDEX downto 0);
			chSel		:		in			std_logic_vector(3 downto 0);
			en			:		in			std_logic;
			x0, x1, x2, x3,
			x4, x5, x6, x7,
			x8, x9, x10, x11,
			x12, x13, x14, x15 :	out 	std_logic_vector(REG_MAX_INDEX downto 0)
		);
	end component iop_pad_out;
	
	component mmb_stackPointer is
		port (
			clk, rst			:		in			std_logic;
			data				:		inout		std_logic_vector(REG_MAX_INDEX downto 0);
			addr				:		in			std_logic_vector(IOP_ADDR_BITS-1 downto 0);
			readReq			:		in			std_logic;
			writeReq			:		in			std_logic
		);
	end component mmb_stackPointer;	
	

end commonPkg;


package body commonPkg is
end commonPkg;