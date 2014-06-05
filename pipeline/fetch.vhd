library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch is   -- busca de instrucao
	port ( 			--entradas 
		clk 			: in std_logic;
		rst 			: in std_logic;
		input_end 	: in std_logic_vector(31 downto 0); -- Endereco inicial
		start 		: in std_logic;

						-- Saidas
		saida_pc  	: out std_logic_vector(31 downto 0); -- saida do somador pc + 4
		saida_mem 	: out std_logic_vector(31 downto 0); -- instrucao na memoria
		r_start 		: out std_logic
	);
end fetch;

architecture arq of fetch is
	type inst_memoria is array (0 to 31) of std_logic_vector(31 downto 0);
	signal mem : inst_memoria;
	signal pc  : std_logic_vector(31 downto 0); -- sinal do pc
	signal add4 	 : std_logic_vector(31 downto 0); -- pc + 4 -- soma 1 byte, para fazer efeito de soma 4 bits
	signal saida_add : std_logic_vector(31 downto 0); -- depois de somar pc + 4
	signal s_mem : std_logic_vector(31 downto 0); -- saida da memoria de instrucao
	signal addr  : std_logic_vector(5 downto 0); -- sinal auxiliar para saida_mem de instrucoes
	
begin
	saida_pc <= pc;
	saida_mem <= s_mem;
	add4 <= x"00000001";
	-- pc
	process (rst,clk, start)
	begin
		if rst = '1' then
			pc <= input_end; --input_end;
			r_start <= '1';
		elsif clk'event and clk = '1' then
			if start = '1' then
				pc <= input_end;
			else
				pc <= saida_add;
			end if;
			r_start <= '0';
		end if;
	end process;

	-- somador do pc + 4
	process (pc,add4)
	begin
		saida_add <= std_logic_vector(signed(pc) + signed(add4));
	end process;

	mem <= (0 => "00000000000000000000000000000000", 
	       1 =>  "00000001001010100100000000100010", 
	       2 =>  "00000001001010100100000000100100", 
	       3 =>  "00000001010000000100100000100000", 
			 4 =>  "00000001000010010000000000011000",
	       others => x"00000000");

	-- memoria de instrucao
	addr <= pc(5 downto 0);
	process (addr)
		begin
			s_mem <= mem(to_integer(unsigned(addr)));
	end process;
	
end arq;