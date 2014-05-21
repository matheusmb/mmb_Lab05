library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.commonPkg.all;


entity fu_alu is
	port(
		opSel 		 	: in std_logic_vector(ALU_OP_FIELD_SIZE-1 downto 0); -- 5 bits - more or less?
		clk, rst		 	: in std_logic;
		aluExec			: in std_logic;
		inpA, inpB 	 	: in signed(13 downto 0);
		talu, tr, tsr  : out std_logic_vector(13 downto 0)
	);

end entity fu_alu;



architecture fu_alu_arch of fu_alu is
	signal s_TALU :  signed(13 downto 0) := (others => '0');
	signal s_TR : signed(13 downto 0) := (others => '0');
	signal s_SR : std_logic_vector(13 downto 0) := (others => '0');

	
	-- Aliases
	alias c : std_logic is s_SR(13);
	alias n : std_logic is s_SR(12);
	alias v : std_logic is s_SR(11);
	alias z : std_logic is s_SR(10);
	
	-- SIMD Status Bits
	alias c1 : std_logic is s_SR(9);
	alias n1 : std_logic is s_SR(8);
	alias v1 : std_logic is s_SR(7);
	alias z1 : std_logic is s_SR(6);
	
	alias c0 : std_logic is s_SR(5);
	alias n0 : std_logic is s_SR(4);
	alias v0 : std_logic is s_SR(3);
	alias z0 : std_logic is s_SR(2);
	
	
	-- Auxiliar Functions	
	function checkZero(a : signed) return std_logic is
	begin
		if(a = (a'range => '0')) then -- if(sum = "00000000000000")
			return '1';
		else
			return '0';
		end if;
	end function checkZero;

	
	function checkOverflow(a, b, sig : std_logic) return std_logic is
	begin
		--if(a AND (NOT result)) OR (NOT a) AND (NOT b) and result
		if( (a = '1' AND b ='1' AND sig = '0') OR
			  (a = '0' AND b = '0' AND sig = '1')) then
			return '1';
		else
			return '0';
		end if;
	end function checkOverflow;
	
begin

	op : process(clk)
		variable tmp 	: signed(14 downto 0)   			:= (others => '0'); -- requires use of variable due timing assingments between signal vs variable
		variable tmp2 	: signed(14 downto 0)   			:= (others => '0'); 
		variable tmpL 	: signed(27 downto 0)				:= (others => '0');
		variable ri  	: signed(14 downto 0) 				:= (others => '0'); -- Signed??
		variable rj  	: signed(14 downto 0) 				:= (others => '0');
--		variable tmpU  : unsigned(14 downto 0)				:= (others => '0');
		variable tmpSIMD_msb	:	signed(7 downto 0)			:= (others => '0');
		variable tmpSIMD_lsb	:	signed(7 downto 0)			:= (others => '0');
		
	begin 		
		if(rising_edge(clk) and aluExec = '1') then
			ri 	:= (c & inpA); -- rename
			rj 	:= (c & inpB);
			tmp 	:= (others => '0');
			tmp2 	:= (others => '0');
			tmpL 	:= (others => '0');
	
-- Arithmetical operations	
			if(opSel = ALU_OP_ADD) then
				tmp := ri + rj;
				
			elsif(opSel = ALU_OP_SUB) then -- How to work with 2'cs?
				tmp := ri - rj;
				tmp(14) := NOT tmp(14); -- to avoid carry error
				
			elsif(opSel = ALU_OP_ADDC) then
				--rj  := rj + 1;
				tmp := ri + rj;
				
			elsif(opSel = ALU_OP_SUBC) then
				-- removed the +1
				tmp := ri - rj;
				tmp(14) := NOT tmp(14);
				
			elsif(opSel = ALU_OP_MUL) then -- What if Im working with unsigned, how to solve it?
				tmpL := ri(13 downto 0) * rj(13 downto 0);
				tmp  := '0' & tmpL(13 downto 0); -- LSb
				tmp2 := '0' & tmpL(27 downto 14); -- MSb
				
			elsif(opSel = ALU_OP_DIV) then
				tmp 	:= ri / rj;
				tmp2	:= ri rem rj;
				
			elsif(opSel = ALU_OP_MULC) then
				--rj 	:= rj +1;
				tmpL := ri(13 downto 0) * rj(13 downto 0);
				tmp  := '0' & tmpL(13 downto 0); -- LSb
				tmp2 := '0' & tmpL(27 downto 14); -- MSb
				
			elsif(opSel = ALU_OP_DIVC) then
				--rj 	:= rj + 1;
				tmp 	:= ri / rj;
				tmp2	:= ri rem rj;


-- Logical Operations				
			elsif(opSel = ALU_OP_NOT) then
				tmp := NOT ri;
				tmp(14) := '0'; -- fix not change
			
			elsif(opSel = ALU_OP_AND) then
				tmp := ri AND rj;
			
			elsif(opSel = ALU_OP_OR) then
				tmp := ri OR rj;
				
			elsif(opSel = ALU_OP_XOR) then
				tmp := ri XOR rj;
				
-- Shift operations	- Use instr field values instead?		
			
			elsif(opSel = ALU_OP_SHLL or opSel = ALU_OP_SHLA) then
				tmp(13 downto 0) := ri(13 downto 0) sll to_integer(rj(3 downto 0));
			
			elsif(opSel = ALU_OP_SHRL) then
				tmp(13 downto 0) := ri(13 downto 0) srl to_integer(rj(3 downto 0)); -- bad coding, find how to remove to_integer(rj)				
			
			elsif(opSel = ALU_OP_SHRA) then
				tmp := shift_right(ri, to_integer(rj(3 downto 0)));
				--ri sra to_integer(rj);	-- undefined sra
				
-- Rotate operations				
				
			elsif(opSel = ALU_OP_ROTL ) then
				tmp := ri(14) & ( ri(13 downto 0) rol to_integer(rj(3 downto 0)) );	
				
			elsif(opSel = ALU_OP_ROTR) then
				tmp := ri(14) & ( ri(13 downto 0) ror to_integer(rj(3 downto 0)) );
				
			elsif(opSel = ALU_OP_RTLC) then
				tmp := ri rol to_integer(rj(3 downto 0));
				
			elsif(opSel = ALU_OP_RTRC) then
				tmp := ri ror to_integer(rj(3 downto 0));
	
		
-- SIMD Instructions
			
			elsif(opSel = ALU_OP_ADDV)	then
				tmpSIMD_msb :=	'0' & inpA(13 downto 7) + inpB(13 downto 7);
				tmpSIMD_lsb := '0' & inpA(6 downto 0) + inpB(6 downto 0);
								
				tmp	:=		'0' & tmpSIMD_msb(6 downto 0) & tmpSIMD_lsb(6 downto 0);
			
			elsif(opSel = ALU_OP_SUBV) then
				tmpSIMD_msb :=	'0' & inpA(13 downto 7) - inpB(13 downto 7);
				tmpSIMD_lsb := '0' & inpA(6 downto 0)  - inpB(6 downto 0);
								
				tmp	:=		'0' & tmpSIMD_msb(6 downto 0) & tmpSIMD_lsb(6 downto 0);
				
			end if;
			
			
			s_TALU <= tmp(13 downto 0);
			s_TR	<= tmp2(13 downto 0);			
			
			-- TODO: determine what operations change the flags
			z <= checkZero(tmp(13 downto 0));
			c <= tmp(14);
			n <= tmp(13);
			v <= checkOverflow(inpA(13), inpB(13), tmp(13));	
			
			-- SIMD Flags
			z1 <= checkZero(tmpSIMD_msb(6 downto 0));
			c1	<=	tmpSIMD_msb(7);
			n1	<=	tmpSIMD_msb(6);
			v1	<= checkOverflow(inpA(13), inpB(13), tmpSIMD_msb(6));
			
			z0 <= checkZero(tmpSIMD_lsb(6 downto 0));
			c0	<=	tmpSIMD_lsb(7);
			n0	<=	tmpSIMD_lsb(6);
			v0	<= checkOverflow(inpA(6), inpB(6), tmpSIMD_lsb(6));		
		end if;
	end process op;
	

	
	talu 	<= std_logic_vector(s_TALU);
	tr 	<= std_logic_vector(s_TR);
	tsr <= s_SR;
	

	
end architecture fu_alu_arch;