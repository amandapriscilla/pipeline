library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Buf_IF_ID is
	port (
		clk  				: in std_logic;
		rst  				: in std_logic;
		inst   			: in std_logic_vector(31 downto 0); -- valor de PC da memoria de instrucao
		op     			: out std_logic_vector(5 downto 0); -- operacao
		rd     			: out std_logic_vector(4 downto 0); -- registrador de destino
		rt     			: out std_logic_vector(4 downto 0); -- registrador t
		rs     			: out std_logic_vector(4 downto 0); -- registrador s
		func   			: out std_logic_vector(5 downto 0); -- funcao
		imediato  		: out std_logic_vector(15 downto 0) -- valor imediato, instrucao do tipo (ADD/SUB)I 
	);
end Buf_IF_ID;

architecture arq of Buf_IF_ID is
	signal op_reg     	 : std_logic_vector(5 downto 0);
	signal rd_reg		    : std_logic_vector(4 downto 0);
	signal rt_reg		    : std_logic_vector(4 downto 0);
	signal rs_reg  		 : std_logic_vector(4 downto 0);
	signal imediato_reg 	 : std_logic_vector(15 downto 0);
	signal func_reg 		 : std_logic_vector(5 downto 0);
	signal saida_add_out_reg : std_logic_vector(31 downto 0);
begin
	op <= op_reg;
	rs <= rs_reg;
	rt <= rt_reg;	
	rd <= rd_reg;
	func <= func_reg;
	imediato <= imediato_reg;
	
	process(clk, rst, inst)
	begin
		if rst = '1' then
			op_reg		 		<= (others => '0');
			rd_reg		 		<= (others => '0');
			rt_reg		 		<= (others => '0');
			rs_reg		 		<= (others => '0');
			rd_reg 				<= (others => '0');
			func_reg		 		<= (others => '0');
			imediato_reg 		<= (others => '0');

		elsif clk'event and clk = '1' then
			op_reg		 		<= inst(31 downto 26);
			rs_reg		 		<= inst(25 downto 21);
			rt_reg		 		<= inst(20 downto 16);
			rd_reg		 		<= inst(15 downto 11);
			func_reg 			<= inst(5 downto 0);
			imediato_reg 		<= inst(15 downto 0);
		end if;
	end process;
end arq;


