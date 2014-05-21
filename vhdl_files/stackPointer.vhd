library IEEE;

use IEEE.std_logic_1164.all;
use work.commonPkg.all;

entity mmb_stackPointer is
	port (
		clk, rst			:		in			std_logic;
		data				:		inout		std_logic_vector(REG_MAX_INDEX downto 0);
		addr				:		in			std_logic_vector(IOP_ADDR_BITS-1 downto 0);
		readReq			:		in			std_logic;
		writeReq			:		in			std_logic
	);
end entity mmb_stackPointer;


architecture SP of mmb_stackPointer is
	signal s_reg		:		std_logic_vector(REG_MAX_INDEX downto 0);
	signal s_din		:		std_logic_vector(REG_MAX_INDEX downto 0);
	
	signal s_dataOut	:		std_logic_vector(REG_MAX_INDEX downto 0);
begin
	
	Requests :
		process(clk, addr, data, readReq, writeReq) 
		begin
			if(addr = "0000") then -- Should it be clk synchronous?
				if(readReq = '1') then
					s_dataOut 	<= s_reg;
				else 
					s_dataOut	<= (others => 'Z');
				end if;
				
				
				if(writeReq = '1') then
					s_din		<=		data;
				else
					s_din		<=		s_reg;
				end if;								
			else
				s_dataOut	<=	(others => 'Z');
				s_din		<=	s_reg;
			end if;
		end process;
	
	
	StackPointerReg :
		register14b port map (
			clk		=>		clk,
			rst		=>		rst,
			din		=>		s_din,
			dout	=>		s_reg
		);
		
		data	<=		s_dataOut;

end architecture SP;