library ieee;
use ieee.std_logic_1164.all;

entity entrada is
  port(
		 input: in std_logic_vector (15 downto 0);
		 bt1, bt2,rst, clk: in std_logic;
		 op, funct: out std_logic_vector (5 downto 0);
		 rs, rt, rd: out std_logic_vector (4 downto 0);
		 pronto: out std_logic
  );
end entrada;

architecture arc of entrada is
  type statetype is
(S0, S1, S2, S3);
  signal currentstate, nextstate: statetype;
  signal o1, o2: std_logic_vector (15 downto 0);
  signal o3: std_logic_vector (31 downto 0);
begin
statereg: process (clk, currentstate, bt1, bt2, rst)
begin
if (rst = '1') then
currentstate <= S0;
elsif (clk ='1' and clk'event) then
case currentstate is
            when S0 =>
					pronto <='0';
              if (bt1 = '0') then
						currentstate <= S1;
						o1 <= input;
              else
						currentstate <= S0;	              
              end if;
            when S1 =>
              if (bt1 = '0') then
					 currentstate <= S2;
					 o2 <= input;	
              else
                currentstate <= S1;
              end if;
				when S2 =>
					o3 <= o1 & o2;
					currentstate <= S3;	
            when S3 =>
              if (bt2 = '0') then
                currentstate <= S0;
                op <= o3(31 downto 26);
                rs <= o3(25 downto 21);
                rt <= o3(20 downto 16);
                rd <= o3(15 downto 11);
                funct <= o3(5 downto 0);
				pronto <= '1';
               else
                currentstate <= S3;
              end if;
          end case;
end if;

     end process;
end arc;