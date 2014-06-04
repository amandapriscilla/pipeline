

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Buf_EX_WB is
	port (
		clk  			: in std_logic;
		rst  			: in std_logic;
		WB				: in std_logic_vector(1 downto 0);
		alu_result 		: in std_logic_vector(31 downto 0);
		
		add_result      : in std_logic_vector(31 downto 0);
		
		mux				: in std_logic_vector(4 downto 0);
		r_WB			: out std_logic_vector(1 downto 0);
		M_data_memory	: out std_logic;
		r_add_result    : out std_logic_vector(31 downto 0);
		
		r_alu_result 	: out std_logic_vector(31 downto 0);
		r_mux			: out std_logic_vector(4 downto 0)
	);
end Buf_EX_WB;

architecture arq of Buf_EX_WB is
		signal r_WB_reg				: std_logic_vector(1 downto 0);
		signal M_data_memory_reg	: std_logic;
		signal r_add_result_reg	    : std_logic_vector(31 downto 0);
		signal r_alu_result_reg 	: std_logic_vector(31 downto 0);
		signal r_rd2_reg			: std_logic_vector(31 downto 0);
		signal r_mux_reg			: std_logic_vector(4 downto 0);	
begin
		r_WB 				<= r_WB_reg;
		M_data_memory 	<= M_data_memory_reg;
		r_add_result 	<= r_add_result_reg;
		r_alu_result 	<= r_alu_result_reg;
		r_rd2 			<= r_rd2_reg;
		r_mux 			<= r_mux_reg;

		process(rst, WB, M, add_result, alu_result, mux)
		begin
			if rst = '1' then
				r_WB_reg <= (others => '0');
				M_data_memory_reg <= '0';
				r_add_result_reg <= (others => '0');
				r_alu_result_reg <= (others => '0');
				r_rd2_reg <= (others => '0');
				r_mux_reg <= (others => '0');
			else
				r_WB_reg <= WB(1 downto 0);
				M_data_memory_reg <= M(0);
				r_add_result_reg <= add_result(31 downto 0);
				r_alu_result_reg <= alu_result(31 downto 0);
				r_rd2_reg <= rd2(31 downto 0);
				r_mux_reg <= mux(4 downto 0);
			end if;
		end process;

end arq;
	
