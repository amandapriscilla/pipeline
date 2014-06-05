library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
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
end banco_reg;

architecture arq of banco_reg is
    type regs_table is array (0 to 31) of std_logic_vector(31 downto 0);
    signal regs : regs_table;

begin
   regs <= (0 => "00000000000000000000000000000000", others => x"00000000");
  
    process(clk, write_rd, rs, rt, rd, v_rd)
    begin
        if clk'event and clk = '1' then
            if write_rd = '1' then
					regs(to_integer(unsigned(rd))) <= v_rd;
					if to_integer(unsigned(rd))= 30 then
						regs(to_integer(unsigned(rd))+1) <= v_hi;
					end if;
            end if;
        end if;
    end process;
    
    v_rs <= regs(to_integer(unsigned(rs)));
    v_rt <= regs(to_integer(unsigned(rt)));

end arq;
