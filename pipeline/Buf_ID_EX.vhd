library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Buf_ID_EX is
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
end Buf_ID_EX;

architecture arq of Buf_ID_EX is
		signal r_rd_reg				: std_logic_vector(4 downto 0); -- repetir entradas
		signal r_read_rs_reg			: std_logic_vector(31 downto 0); -- 
		signal r_read_rt_reg			: std_logic_vector(31 downto 0); --                
		signal r_signEx_reg			: std_logic_vector(31 downto 0); --                      
		signal r_WB_reg				: std_logic_vector(1 downto 0); --
		signal EX_mux_alu_reg		: std_logic; 
		signal alu_op_reg			: std_logic_vector(3 downto 0);
begin
 	   r_rd <= r_rd_reg;				
		r_read_rs <= r_read_rs_reg;				
		r_read_rt <= r_read_rt_reg;				        
		r_signEx <= r_signEx_reg;			                  
		r_WB <= r_WB_reg;							
		EX_mux_alu <= EX_mux_alu_reg;		
		alu_op <= alu_op_reg;		
		
		process(rst, clk, rd, read_rs, read_rt, signEx, WB, EX)
		begin
			if rst = '1' then
				r_rd_reg					<= (others => '0');
				r_read_rs_reg			<= (others => '0');
				r_read_rt_reg			<= (others => '0');       
				r_signEx_reg			<= (others => '0');                     
				r_WB_reg					<= (others => '0');
				EX_mux_alu_reg			<= '0';
				alu_op_reg			<= (others => '0');
			elsif  clk'event and clk = '1' then
				r_rd_reg 				<= rd(4 downto 0); 
				r_read_rs_reg 			<= read_rs(31 downto 0); 
				r_read_rt_reg 			<= read_rt(31 downto 0); 
				r_signEx_reg 			<= signEx(31 downto 0); 
				r_WB_reg 				<= WB(1 downto 0);
				EX_mux_alu_reg 		<= EX(0);		
				alu_op_reg			<= EX(4 downto 1);		
			end if;
		end process;
	
end arq;




