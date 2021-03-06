-- ULA Projeto VHDL 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ula is
  port(
    ent1,ent2: in std_logic_vector(31 downto 0);    
    op: in std_logic_vector(5 downto 0);    
    funct: in std_logic_vector(5 downto 0);   	
	saida_ula: out std_logic_vector(31 downto 0)   
  );
end ula;

architecture arc of ula is
  signal conv: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
  signal alg1,aux: std_logic_vector(31 downto 0);
  begin
    process( ent1,ent2, op, funct, conv, alg1)
      begin
        if(op = "000001" and funct = "000000") then 
            saida_ula <=  ent1 + ent2;            
        elsif(op = "000001" and funct = "000001") then 
            saida_ula <=  ent1 + ent2;            
        elsif(op = "000011" and funct = "000010") then 
            conv <= (not ent2) + 1;
            saida_ula <=  ent1 + conv;            
        elsif(op = "000100" and funct = "011000") then 
            saida_ula <=  ent1(15 downto 0) * ent2(15 downto 0);    
        elsif(op = "100011") then 
            saida_ula <=  ent1 + ent2;
		  elsif(op = "101011") then 
            saida_ula <=  ent1 + ent2;
        elsif(op = "001111" and funct = "010000") then
            saida_ula <=  ent1; 
        elsif(op = "001110" and funct = "010010") then 
            saida_ula <=  ent1; 
        elsif(op = "000000" and funct = "100100") then
            saida_ula <=  ent1 and ent2;
        elsif(op = "000000" and funct = "100101") then 
            saida_ula <=  ent1 or ent2;
        elsif(op = "000000" and funct = "100110") then 
            saida_ula <= not  ent1;
		elsif(op = "000000" and funct = "100111") then 
            saida_ula <= ent1 xor ent2;
		elsif(op = "000000" and funct = "101000") then 
            saida_ula <= ent1 (31 downto 2) & "00";
		elsif(op = "000000" and funct = "101001") then 
            saida_ula <= "00" & ent1(31 downto 2);
		elsif(op = "100000" and funct = "000000") then 
				aux <= "00" & ent1(31 downto 2);
				alg1 <= aux (31 downto 16) & ent2 (15 downto 0);
				saida_ula <= alg1;            
		else
			saida_ula <= (others => '0');
      end if;
end process;
end arc;
