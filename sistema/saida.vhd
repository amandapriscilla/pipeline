-- CONTROLADOR Projeto VHDL 
library ieee;
use ieee.std_logic_1164.all;

entity saida is
port ( 
--Entradas
		on_off: in std_logic := '0';
		clk, rst: in std_logic;

--Saida
		led: out std_logic
);
end saida;

architecture behavior of saida is
signal status: std_logic := '0';
begin
statereg: process(clk, rst, status) -- reg de estado
	begin
	  if(rst='1') then -- initial state
		 status<='0';
	  elsif(clk='1' and clk'event) then
		status <= on_off;
	  end if;
	  led<= status;
	  
	end process;
end behavior;