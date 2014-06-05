library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
	port (
		clk, rst		: in std_logic;
		alu_result, alu_result_hi		: in std_logic_vector(31 downto 0); -- resultado ula
		rd				: in std_logic_vector(4 downto 0);
		regWrite		: in std_logic_vector(1 downto 0);
		r_regWrite	 	: out std_logic;
		r_alu_result	: out std_logic_vector(31 downto 0); -- resultado ula
		r_mult_hi		: out std_logic_vector(31 downto 0); -- resultado hi da multiplicacao
		r_rd				: out std_logic_vector(4 downto 0);
		saida_ULA		: out std_logic_vector(31 downto 0)
	);
end write_back;

architecture arq of write_back is
	signal r_alu_result_reg		: std_logic_vector(31 downto 0);
	signal r_alu_result_hi_reg	: std_logic_vector(31 downto 0);
	signal r_rd_reg				: std_logic_vector(4 downto 0);
begin
	r_alu_result <= r_alu_result_reg;
	r_rd <= r_rd_reg;	
	
	process(rst, regWrite, rd, alu_result)
	begin
		if rst = '1' then
			r_regWrite <= '0';
			r_alu_result_reg <= (others => '0');
			r_alu_result_hi_reg <= (others => '0');
			r_rd_reg <= (others => '0');
			saida_ULA <= (others => '0');
			
		else
			if regWrite = "11" then
				r_regWrite <= '1';
			end if;
			r_rd_reg <= rd(4 downto 0);
			r_alu_result_reg <= alu_result(31 downto 0);
			r_alu_result_hi_reg<= alu_result_hi(31 downto 0);
			saida_ULA <= (others => '0');
		end if;
		
	end process;
	
end arq;
