-- SISTEMA Projeto VHDL 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sistema is
port ( 	clk,rst: std_logic;
			botao1, botao2: in std_logic;
			dados: in std_logic_vector(15 downto 0);
			saida_led: out std_logic;
			display0,display1,display2,display3,display4,display5,display6,display7: out std_logic_vector(6 downto 0);
			
			state: out std_logic_vector (1 downto 0)
		);
end sistema;

architecture arq of sistema is
	
	component entrada is
	port(
			input: in std_logic_vector (15 downto 0);
			bt1, bt2,rst, clk: in std_logic;
			op, funct: out std_logic_vector (5 downto 0);
			rs, rt, rd: out std_logic_vector (4 downto 0);
			pronto: out std_logic
	);
	end component;
	
	component controlador is
	port ( 
---Entradas
	-- modulo de entrada
		op, func: in std_logic_vector(5 downto 0);
		rd, rs, rt: std_logic_vector(4 downto 0);
		pronto: std_logic;		
	-- aula/registrador -- saida_reg1 = rs, saida_reg2 = rt
		saida_ula, saida_reg1, saida_reg2 : in std_logic_vector (31 downto 0);
	
		clk, rst: in std_logic;
--Saidas
		end_reg1, end_reg2, end_regW: out std_logic_vector (4 downto 0);
		ent_ula1, ent_ula2, ent_reg: out std_logic_vector (31 downto 0);
		le_reg	: out std_logic;
		state: out std_logic_vector (1 downto 0)	
		
);
	end component;
	
	component acessoM is
	port(	
			--Entradas
			endereco	: in std_logic_vector (4 downto 0);
			clock	: in std_logic := '1';
			dados_entr	: in std_logic_vector (31 downto 0);
			ler_escrever	: in STD_LOGIC;
			--Saída
			dados_saida	: out std_logic_vector (31 downto 0)
	);
	end component;
	
	component BancoReg is
	port(	
			clk: in std_logic;
			RoW: in std_logic;
			Adr1,Adr2, AdrW: in std_logic_vector(4 downto 0);
			Data_In: in std_logic_vector(31 downto 0);
			Data_Out1,Data_Out2: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component ula is
	port(
			ent1,ent2: in std_logic_vector(31 downto 0);    
			op: in std_logic_vector(5 downto 0);    
			funct: in std_logic_vector(5 downto 0);   	
			saida_ula: out std_logic_vector(31 downto 0)   
	);
	end component;
	
	component conversorBCD32 is
	port( R: in STD_LOGIC_VECTOR(31 DOWNTO 0);      
			SEG0,SEG1,SEG2,SEG3,SEG4,SEG5,SEG6,SEG7: out STD_LOGIC_VECTOR(6 DOWNTO 0)
	); 
	end component;
	
	component saida is
	port( 
			--Entradas
			on_off: in std_logic;
			clk, rst: in std_logic;

			--Saida
			led: out std_logic
	);
	end component;
	
	-- Sinais Entrada
	signal pronto: std_logic;
	signal rs,rt,rd: std_logic_vector (4 downto 0);
	signal op0, funct0: std_logic_vector (5 downto 0);
	
	-- Sinais Acesso a Memoria
	signal LerEscrever0: std_logic;
	signal Endereco0: std_logic_vector (4 downto 0);
	signal Dados_entr0, Dados_saida0: std_logic_vector (31 downto 0);
	
	-- Sinais BancoReg
	signal LoE: std_logic;
	signal Adr1, Adr2, AdrW: std_logic_vector (4 downto 0);
	signal Dat_IN, Data_Out1, Data_Out2: std_logic_vector (31 downto 0);
	
	-- Sinais ULA
	signal Ent0, Ent1, SaidaULA: std_logic_vector (31 downto 0);
	
	-- Sinais Saidas_LED/BCD
	signal Entrada_LED: std_logic:='1';
	signal Entrada_BCD: std_logic_vector (31 downto 0);
		
	
	begin
	
	c1: entrada port map (dados,botao1,botao2,rst,clk,
									op0,funct0,rs,rt,rd,pronto);
	
	c3: acessoM port map (Endereco0,clk,Dados_entr0,LerEscrever0,Dados_saida0);
	
	c4: BancoReg port map (clk,LoE,Adr1,Adr2, AdrW,Dat_IN,Data_Out1,Data_Out2);
	
	c5: ula port map (Ent0,Ent1,op0,funct0,SaidaULA);
	
	c6: conversorBCD32 port map (Entrada_BCD,display0,display1,display2,display3,display4,display5,display6,display7);
	c7: saida port map (Entrada_LED,clk,rst,saida_led);
	
	
	c2: controlador port map (op0,funct0,rd,rs,rt,pronto,SaidaULA, Data_Out1, Data_Out2, clk, rst, 
										Adr1, Adr2, AdrW,Ent0, Ent1,Dat_IN,LoE,state);
	
	
	
end arq;
	