
-------------------------- Conversor de 32 bits (oito displays) -----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conversorBCD32 is
port( R : in STD_LOGIC_VECTOR(31 DOWNTO 0);      
      SEG0,SEG1,SEG2,SEG3,SEG4,SEG5,SEG6,SEG7: out STD_LOGIC_VECTOR(6 DOWNTO 0)
); 
end conversorBCD32;

architecture arq of conversorBCD32 is

component conversorBCD is
port( BCD : in STD_LOGIC_VECTOR(3 DOWNTO 0);      
      SEG: out STD_LOGIC_VECTOR(6 DOWNTO 0));  
end component;

begin
disp0: conversorBCD port map (R(3 downto 0),SEG0);
disp1: conversorBCD port map (R(7 downto 4),SEG1);
disp2: conversorBCD port map (R(11 downto 8),SEG2);
disp3: conversorBCD port map (R(15 downto 12),SEG3);
disp4: conversorBCD port map (R(19 downto 16),SEG4);
disp5: conversorBCD port map (R(23 downto 20),SEG5);
disp6: conversorBCD port map (R(27 downto 24),SEG6);
disp7: conversorBCD port map (R(31 downto 28),SEG7);

end arq;