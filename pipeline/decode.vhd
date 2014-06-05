library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decode is
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
end decode;

architecture arq of decode is

component banco_reg is
    port (
        clk 		: in std_logic;
        write_rd  : in std_logic;
        rd    		: in std_logic_vector(4 downto 0);
        rs    : in std_logic_vector(4 downto 0);
        rt    : in std_logic_vector(4 downto 0);
        v_rd, v_hi  : in std_logic_vector(31 downto 0);
        v_rs  : out std_logic_vector(31 downto 0);
        v_rt  : out std_logic_vector(31 downto 0)
    );
end component;

		signal op_F     			: std_logic_vector(5 downto 0); -- operacao
		signal func_F   			: std_logic_vector(5 downto 0); -- funcao
		signal imediato_F  		: std_logic_vector(15 downto 0); -- valor imediato, instrucao do tipo I 
		signal read_rs_F			: std_logic_vector(31 downto 0); -- read data 1
		signal read_rt_F			: std_logic_vector(31 downto 0); -- read data 2		signal 
		signal signEx_F			: std_logic_vector(31 downto 0); -- sing extend 32		signal 
	

begin

Instruction_decode_u : banco_reg port map(clk, write_rd, rd_WB, rs, rt, dataULA_WB, dataMult_WB, read_rs, rea                                                                                                                                                                                                                                                  d_rt);

	r_rd <= rd;

	-- signal extend
	process (imediato)
	begin
		if imediato(15) = '1' then
			signEx <= "1111111111111111" & imediato;
		else
			signEx <= "0000000000000000" & imediato;
		end if;	
	end process;

	-- controle
	
	process (op, funct)
	begin
	     -- o primeiro bit do EX controla o regdst
	     -- os 4 bits internos controlam as operacoes da ula
	     -- o ultimo bit controla o mux da ula
			if op = "000000" then --todas do tipo R tem opcode 000000
				
				if funct = "100000" then -- add
					EX <= "100000"; -- x0000x soma na ula
					WB <= "11";
				elsif funct = "100010" then -- sub
					EX <= "100010"; -- x0001x sub na ula
					WB <= "11";
				elsif funct = "011000" then -- mult
					EX <= "100100"; -- x0010x mult na ula
					WB <= "11";
				elsif funct = "100100" then -- and
					EX <= "100110"; -- x0011x and na ula
					WB <= "11";
				elsif funct = "100101" then -- or
					EX <= "101000"; -- x0100x or na ula
					WB <= "11";
				elsif funct = "100111" then -- nor
					EX <= "101010"; -- x0101x nor na ula
					WB <= "11";	
				
				end if;
				
				
			else -- operacoes do tipo i
 				if op = "001000" then -- addi
					EX <= "000001";
					WB <= "11";
				end if;
			end if;
	
	end process;

end arq;
