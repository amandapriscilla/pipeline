library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute is
	port (
		rd					: in std_logic_vector(4 downto 0); -- repetir entradas
		read_rs			: in std_logic_vector(31 downto 0); -- 
		read_rt			: in std_logic_vector(31 downto 0); --                
		signEx			: in std_logic_vector(31 downto 0); --                     
		WB					: in std_logic_vector(1 downto 0); --	
		EX_mux_alu		: in std_logic;
		alu_op			: in std_logic_vector(3 downto 0);	
		
		r_WB				: out std_logic_vector(1 downto 0);
		r_rd				: out std_logic_vector(4 downto 0);
		alu_result 		: out std_logic_vector(31 downto 0);
		zero				: out std_logic;
		aux_hi_result	: out std_logic_vector(31 downto 0)
	);
end execute;

architecture arq of execute is
	signal saida_mux_ula_reg 	: std_logic_vector(31 downto 0);
	signal mux_reg : std_logic_vector( 4 downto 0);
	signal alu_result_reg : std_logic_vector(31 downto 0);
	signal mult_aux : std_logic_vector(63 downto 0);

begin
	r_WB <= WB;
	alu_result <= alu_result_reg(31 downto 0);
	
	-- mux para a ula - decide se entra rt ou imediato
	process(read_rt, signEx, EX_mux_alu)
	begin
		if EX_mux_alu = '0' then
			saida_mux_ula_reg <= read_rt(31 downto 0);
		else
			saida_mux_ula_reg <= signEx(31 downto 0);
		end if;
	end process;
	

	
	-- zero
	process(alu_result_reg)
	begin
		if alu_result_reg = x"00000000" then
			zero <= '1';
		else
			zero <= '0';
		end if; 
	end process;
	
	-- ula
	process(saida_mux_ula_reg, read_rs, alu_op)
	begin
		
		if alu_op = "0000" then -- soma
			alu_result_reg <= std_logic_vector((signed(saida_mux_ula_reg) + signed(read_rs)));
		elsif alu_op = "0001" then -- subtracao
			alu_result_reg <= std_logic_vector((signed(saida_mux_ula_reg) - signed(read_rs)));
		elsif alu_op = "0010" then -- mult
			mult_aux <= std_logic_vector((signed(saida_mux_ula_reg) * signed(read_rs))); -- 64 bits
			alu_result_reg <= mult_aux(31 downto 0);
			r_rd <= "11110"; -- Indica o registrador low = R30
			aux_hi_result <= mult_aux(63 downto 32); -- Se rd for low, valor de aux_hi_result sera gravado em hi
		elsif alu_op = "0011" then -- and
			alu_result_reg <= std_logic_vector((signed(saida_mux_ula_reg) and signed(read_rs)));
		elsif alu_op = "0100" then -- or
			alu_result_reg <= std_logic_vector((signed(saida_mux_ula_reg) or signed(read_rs)));
		elsif alu_op = "0101" then -- nor
			alu_result_reg <= std_logic_vector((signed(saida_mux_ula_reg) nor signed(read_rs)));
		end if;
	
	end process;

end arq;

