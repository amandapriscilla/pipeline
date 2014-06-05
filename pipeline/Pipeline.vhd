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
			saida_mem, saida_ULA 	: out std_logic_vector(31 downto 0) -- instrucao na memoria
			 
		);
end Pipeline;

architecture arq of Pipeline is


	component fetch is
	port(				--entradas 
		clk 			: in std_logic;
		rst 			: in std_logic;
		input_end 	: in std_logic_vector(31 downto 0); -- Endereco inicial
		start 		: out std_logic;
						-- Saidas
		saida_pc  	: out std_logic_vector(31 downto 0); -- saida do somador pc + 4
		saida_mem 	: out std_logic_vector(31 downto 0); -- instrucao na memoria
		r_start 		: out std_logic -- booleano inicio (1) ou continuacao (0)
	);
	end component;
	
	component Buf_IF_ID is
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
	end component;

	component decode is
	port(
		clk			: in std_logic;
		write_rd		: in std_logic; -- define se grava rd
		op     		: in std_logic_vector(5 downto 0); -- operacao
		rd     		: in std_logic_vector(4 downto 0); -- registrador de destino
		rd_WB			: in std_logic_vector(4 downto 0); -- registrador de destino do banco de registradores
		rt     		: in std_logic_vector(4 downto 0); -- registrador t
		rs     		: in std_logic_vector(4 downto 0); -- registrador s
		funct  		: in std_logic_vector(5 downto 0); -- funcao
		imediato  	: in std_logic_vector(15 downto 0); -- valor imediato, instrucao do tipo I 
		dataULA_WB, dataMult_WB	: in std_logic_vector(31 downto 0);
		r_rd			: out std_logic_vector(4 downto 0); -- saida do registrador d
		read_rs		: out std_logic_vector(31 downto 0); -- read data 1 rs
		read_rt		: out std_logic_vector(31 downto 0); -- read data 2 rt
		signEx		: out std_logic_vector(31 downto 0); -- sing extend 32
		WB				: out std_logic_vector(1 downto 0); -- saida para buffer 
		EX				: out std_logic_vector(5 downto 0)
	);
	end component;
	
	component Buf_ID_EX is
	port(
		clk, rst			: in std_logic;
		rd					: in std_logic_vector(4 downto 0); -- saida do registrador d
		read_rs			: in std_logic_vector(31 downto 0); -- read data 1 rs
		read_rt			: in std_logic_vector(31 downto 0); -- read data 2 rt
		signEx			: in std_logic_vector(31 downto 0); -- sing extend 32
		WB					: in std_logic_vector(1 downto 0);
		EX					: in std_logic_vector(5 downto 0);
		r_rd				: out std_logic_vector(4 downto 0); -- repetir entradas
		r_read_rs		: out std_logic_vector(31 downto 0); -- 
		r_read_rt		: out std_logic_vector(31 downto 0); --                
		r_signEx			: out std_logic_vector(31 downto 0); --                        
		r_WB				: out std_logic_vector(1 downto 0); --
		EX_mux_alu		: out std_logic; -- mux ula - rt ou inteiro imediato
		alu_op		: out std_logic_vector(3 downto 0)
	);
end component;

component execute is
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
end component;

component Buf_EX_WB is
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
end component;


component write_back is
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
end component;
	
	-- Sinais Fetch
	signal start : std_logic := '1';
	signal pc  : std_logic_vector(31 downto 0); -- saida do somador pc + 4
	signal prox_inst	: std_logic_vector(31 downto 0); -- proxima instrucao na memoria
	-- Sinais Buffer Fetch-Decode
	signal op, func	: std_logic_vector(5 downto 0); -- operacao
	signal rd, rt, rs : std_logic_vector(4 downto 0); -- registrador de destino
	signal imediato  	: std_logic_vector(15 downto 0); -- valor imediato, instrucao do tipo (ADD/SUB)I 
	
	-- Sinais Decode
	signal rd_exe		: std_logic_vector(4 downto 0);
	signal read_rs1, read_rt1, signEx1		: std_logic_vector(31 downto 0); -- read data 1 rs
	signal WB1 : std_logic_vector(1 downto 0); -- saida para buffer 
	signal EX1 : std_logic_vector(5 downto 0);
	
	-- Sinais ID-EXE
	signal rd_exe2	: std_logic_vector(4 downto 0); 
	signal read_rs2, read_rt2, signEx2	: std_logic_vector(31 downto 0);
	signal WB2 : std_logic_vector(1 downto 0);
	signal EX_mux_alu : std_logic;
	signal EX_alu_op : std_logic_vector(3 downto 0);

	-- Sinais Execute	
	signal WB3	: std_logic_vector(1 downto 0);
	signal rd_exe3	: std_logic_vector(4 downto 0);
	signal alu_result, hi_alu_result	: std_logic_vector(31 downto 0);
	signal zero	: std_logic;
	
	-- Sinais EX_WB
	signal WB4	: std_logic_vector(1 downto 0);
	signal rd_exe4	: std_logic_vector(4 downto 0);
	signal alu_result2, hi_alu_result2	: std_logic_vector(31 downto 0);

	-- Sinais write_back
	signal write_rd	: std_logic := '0'; -- define se grava rd (determinado pelo WB)
	signal rd_WB		: std_logic_vector(4 downto 0); -- registrador de destino
	signal dataULA_WB, dataMult_WB : std_logic_vector(31 downto 0); -- Resultado vindo da ULA e high da multiplicacao
	

	begin
	
	c1: fetch port map (clk,rst,input_end, start, pc, prox_inst, start);
	c2: Buf_IF_ID port map (clk,rst, pc, 
									op, rd, rt, rs, func, imediato);
									
	c3: decode port map (clk, write_rd, op, rd, rd_WB, rt, rs, func, imediato, dataULA_WB, dataMult_WB, 
								rd_exe, read_rs1, read_rt1, signEx1, WB1, EX1);
	
	c4: Buf_ID_EX port map(clk, rst, rd_exe, read_rs1, read_rt1, signEx1, WB1, EX1, 
									rd_exe2, read_rs2, read_rt2, signEx2, WB2, EX_mux_alu, EX_alu_op);
									
	c5: execute port map(rd_exe2, read_rs2, read_rt2, signEx2, WB2,  EX_mux_alu, EX_alu_op, 
								WB3, rd_exe3, alu_result, zero, hi_alu_result);
								
								
								
								
								
	c6: Buf_EX_WB port map(clk, rst, WB3, rd_exe3, alu_result, hi_alu_result,  
								WB4, rd_exe4,alu_result2, hi_alu_result2);		
								
								
	c7: write_back port map(clk, rst, alu_result2, hi_alu_result2, rd_exe4, WB4, 
									write_rd, dataULA_WB, dataMult_WB, rd_WB, saida_ULA);	

		
	
end arq;