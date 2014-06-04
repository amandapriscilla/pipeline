-- SISTEMA Projeto VHDL 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Pipeline is
port ( 	clk,rst: std_logic;
			input_end 	: in std_logic_vector(31 downto 0); -- Endereco inicial
			saida_pc  	: out std_logic_vector(31 downto 0); -- saida do somador pc + 4
			saida_mem 	: out std_logic_vector(31 downto 0) -- instrucao na memoria
		);
end Pipeline;

architecture arq of Pipeline is


	component fetch is
	port(				--entradas 
		clk 			: in std_logic;
		rst 			: in std_logic;
		input_end 	: in std_logic_vector(31 downto 0); -- Endereco inicial
						-- Saidas
		saida_pc  	: out std_logic_vector(31 downto 0); -- saida do somador pc + 4
		saida_mem 	: out std_logic_vector(31 downto 0) -- instrucao na memoria
	);
	end component;
	
	
	
	
		-- Sinais Entrada
	signal pronto: std_logic;
	signal rs,rt,rd: std_logic_vector (4 downto 0);
	signal op0, funct0: std_logic_vector (5 downto 0);
	

	
	begin
	
	c1: fetch port map (clk,rst,input_end, saida_pc, saida_mem);
	
end arq;