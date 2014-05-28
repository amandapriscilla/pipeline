-- CONTROLADOR Projeto VHDL 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity controlador is
port ( 
--Entradas
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
end controlador;

architecture behavior of controlador is
type statetype is
	(S_Wait, S_Read, S_ULA, S_WRITE);
signal currentstate, nextstate: statetype;
signal mem1, mem2, wrote1: std_logic;
signal zero, aux1, aux2: std_logic_vector (31 downto 0);


begin
statereg: process(clk, rst, nextstate) -- reg de estado
	begin
	  if(rst='1') then -- initial state
		 currentstate <= S_Wait;
	  else --if(clk='1' and clk'event) then
	     currentstate <= nextstate;
	  end if;
	end process;
comblogic: process(clk, currentstate, op, func, rd, rs, rt, pronto, saida_ula, saida_reg1, saida_reg2, mem1, mem2, wrote1) -- logica combinacional
begin
if(clk='1' and clk'event) then
  case currentstate is
		when S_Wait =>  
			le_reg<='0';
			if(pronto='0') then
				nextstate <= S_Wait;
			else
				nextstate <= S_Read;
			end if;
			state<="00";
			
			-- ZERANDO SAIDAS E SINAIS
			zero <= (others => '0');
			wrote1 <= '0';				
			
		-- **************** READ ENDERECOS **********************
		when S_Read => 
			state<="01";
			le_reg<='0';
			nextstate <= S_ULA;
			
			if(op = "001111" and func = "010000") then -- op = 0F -> $d = HI
					end_reg1 <= "11111"; -- ENDERECO HI - ultimo registrador
					end_reg2 <= "00000"; -- Zero
				elsif (op = "001110" and func = "010010") then -- op -> 0E = $d = LO
					end_reg1 <= "11110"; -- ENDERECO LO - penultimo registrador
					end_reg2 <= "00000"; -- Zero
				else
					end_reg1 <= rs; -- qqr chamada carrega do registrador
					end_reg2 <= rt;
			end if;

		-- **************** ULA **********************					
		when S_ULA => 
		
		state<="10";
		-- TRATANDO CASOS DE REGISTRADORES
		if(op = "000100" and func = "011000") then -- op=4 e func = 18 LO e HI
			-- ENVIA BITS MENOS SIGNIFICATIVOS
			if(wrote1 = '0') then -- ENVIA LO (MENOS SIGNIFICATIVOS) PRA ULA
				aux1 <= saida_reg1; 
				aux2 <= saida_reg2;
				
				-- LO
				Ent_ula1 <= zero(15 downto 0) & aux1(15 downto 0);	
				Ent_ula2 <= zero(15 downto 0) & aux2(15 downto 0);	
			else -- HI
				Ent_ula1 <= zero(15 downto 0) & aux1(31 downto 16);	
				Ent_ula2 <= zero(15 downto 0) & aux2(31 downto 16);				
			end if;
			
		else
				Ent_ula1 <= saida_reg1;
				Ent_ula2 <= saida_reg2;
		end if;

		nextstate <= S_Write;
		
				
		when S_WRITE =>
		state<="11";
		le_reg <= '1';
		if(op = "000100" and func = "011000") then -- GRAVA EM LO e HI - op=4 e func = 18
			if(wrote1 = '0') then -- grava LO
				end_regW <= "11110"; -- LO
				ent_reg <= saida_ula;
				wrote1 <= '1';
				nextstate <= S_ULA;
			else  -- grava HI
				end_regW <= "11111"; -- HI
				ent_reg <= saida_ula;
				nextstate <= S_Wait;
			end if;
		else -- outros casos
			le_reg <= '1';
			end_regW<= rd; 
			ent_reg <= saida_ula;
			nextstate <= S_Wait;
		end if;
				
					
				
	end case;
end if;
end process;
end behavior;