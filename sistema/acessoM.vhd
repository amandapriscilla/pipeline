library ieee;
library altera_mf;
use ieee.std_logic_1164.all;
use altera_mf.all;

entity acessoM is
	port
	(	--Entradas
		endereco	: in std_logic_vector (4 downto 0);
		clock: in std_logic;
		dados_entr	: in std_logic_vector (31 downto 0);
		ler_escrever	: in STD_LOGIC;
		--Saída
		dados_saida	: out std_logic_vector (31 downto 0)
	);
end acessoM;


architecture arc of acessoM is

	component memoria
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	end component;

begin

	c1: memoria port map ( endereco, clock, dados_entr, ler_escrever, dados_saida);
	

end arc;