

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Buf_EX_WB is
	port (
		clk  			: in std_logic;
		rst  			: in std_logic;
		WB				: in std_logic_vector(1 downto 0);
		rd				: in std_logic_vector(4 downto 0);
		alu_result, alu_result_hi 	: in std_logic_vector(31 downto 0);
		
		r_WB				: out std_logic_vector(1 downto 0);
		r_rd				: out std_logic_vector(4 downto 0);
		r_alu_result, r_alu_result_hi 	: out std_logic_vector(31 downto 0)
		
	);
end Buf_EX_WB;

architecture arq of Buf_EX_WB is
		signal r_WB_reg				: std_logic_vector(1 downto 0);
		signal r_alu_result_reg, r_alu_result_hi_reg 	: std_logic_vector(31 downto 0);
		signal r_rd_reg			: std_logic_vector(4 downto 0);
begin
		process(rst, WB, alu_result, alu_result_hi)
		begin
			if rst = '1' then
				r_WB_reg <= (others => '0');
				r_alu_result_reg <= (others => '0');
				r_alu_result_hi_reg <= (others => '0');
				r_rd_reg <= (others => '0');
			else
				r_WB_reg <= WB(1 downto 0);
				r_alu_result_reg <= alu_result(31 downto 0);
				r_alu_result_hi_reg <= alu_result_hi(31 downto 0);
				r_rd_reg <= rd(4 downto 0);
			end if;
		end process;
		
		r_WB 				<= r_WB_reg;
		r_alu_result 	<= r_alu_result_reg;
		r_alu_result_hi <= r_alu_result_hi_reg;
		r_rd 			<= r_rd_reg;

end arq;
	
