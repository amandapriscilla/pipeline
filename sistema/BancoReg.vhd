library ieee;
use ieee.std_logic_1164.all;

ENTITY BancoReg IS
	PORT(	clk: in std_logic;
			RoW: in std_logic;
			Adr1,Adr2, AdrW: in std_logic_vector(4 downto 0);
			Data_In: in std_logic_vector(31 downto 0);
			Data_Out1,Data_Out2: out std_logic_vector(31 downto 0)
		);
END BancoReg;

ARCHITECTURE behavior OF BancoReg IS

	SIGNAL Reg0		: std_logic_vector (31 downto 0):="00000000000000000000000000000000"; -- Reg0 = 0 - 0	 
	SIGNAL Reg1		: std_logic_vector (31 downto 0):="00000000000000000000000000000001"; -- Reg1 = 1 - 1	
	SIGNAL Reg2		: std_logic_vector (31 downto 0):="00000000000000000000000000000010"; -- Reg2 = 2 - 2		
	SIGNAL Reg3		: std_logic_vector (31 downto 0):="00000000000000000000000000000011"; -- Reg3 = 3 - 3		
	SIGNAL Reg4		: std_logic_vector (31 downto 0):="00000000000000000000000000000100"; -- Reg4 = 4 - 4	
	SIGNAL Reg5		: std_logic_vector (31 downto 0):="00000000000000000000000000000101"; -- Reg5 = 5 - 5		
	SIGNAL Reg6		: std_logic_vector (31 downto 0):="00000000000000000000000000000110"; -- Reg6 = 6 - 6	
	SIGNAL Reg7		: std_logic_vector (31 downto 0):="00000000000000000000000000000111"; -- Reg7 = 7 - 7	
	SIGNAL Reg8		: std_logic_vector (31 downto 0):="00000000000000000000000000001000"; -- Reg8 = 8 - 8	
	SIGNAL Reg9 	: std_logic_vector (31 downto 0):="00000000000000000000000000001001"; -- Reg9 = 9 - 9
	SIGNAL Reg10	: std_logic_vector (31 downto 0):="11111111110000000000000000000000"; -- Reg10 = 10 - A
	SIGNAL Reg11	: std_logic_vector (31 downto 0):="00000000000000000000000000000111"; -- Reg11 = 100 - B
	SIGNAL Reg12	: std_logic_vector (31 downto 0):="00000000000000000000010111011100"; -- Reg12 = 1500 - 5DC
	SIGNAL Reg13	: std_logic_vector (31 downto 0):="00000000000000000010111011100000"; -- Reg13 = 12000 - 2EE0
	SIGNAL Reg14	: std_logic_vector (31 downto 0):="00000000000000001100001101010000"; -- Reg14 = 50000 - C350
	SIGNAL Reg15	: std_logic_vector (31 downto 0):="00000000000000011000011010100000"; -- Reg15 = 100000 - 186A0
	SIGNAL Reg16	: std_logic_vector (31 downto 0):="00000000000000111101000010010000"; -- Reg16 = 250000 - 3D090
	SIGNAL Reg17	: std_logic_vector (31 downto 0):="00000000000001110011111101111000"; -- Reg17 = 475000 - 73F78
	SIGNAL Reg18	: std_logic_vector (31 downto 0):="00000000000001111010000100100000"; -- Reg18 = 500000 - 7A120
	SIGNAL Reg19	: std_logic_vector (31 downto 0):="00000000000010010010011111000000"; -- Reg19 = 600000 - 927C0
	SIGNAL Reg20	: std_logic_vector (31 downto 0):="00000000000010110111000110110000"; -- Reg20 = 750000 - B71B0
	SIGNAL Reg21	: std_logic_vector (31 downto 0):="00000000000011110100001001000000"; -- Reg21 = 1000000 - F4240
	SIGNAL Reg22	: std_logic_vector (31 downto 0):="00000000000101101110001101100000"; -- Reg22 = 1500000 - 16E360
	SIGNAL Reg23	: std_logic_vector (31 downto 0):="00000000000110101011001111110000"; -- Reg23 = 1750000 - 1AB3F0
	SIGNAL Reg24	: std_logic_vector (31 downto 0):="00000000000111101000010010000000"; -- Reg24 = 2000000 - 1E8480
	SIGNAL Reg25	: std_logic_vector (31 downto 0):="00000000001001100010010110100000"; -- Reg25 = 2500000 - 2625A0
	SIGNAL Reg26	: std_logic_vector (31 downto 0):="00000000001011011100011011000000"; -- Reg26 = 3000000 - 2DC6C0
	SIGNAL Reg27	: std_logic_vector (31 downto 0):="00000000010011000100101101000000"; -- Reg27 = 5000000 - 4C4B40
	SIGNAL Reg28	: std_logic_vector (31 downto 0):="00000000100110001001011010000000"; -- Reg28 = 10000000 - 989680
	SIGNAL Reg29	: std_logic_vector (31 downto 0):="00000001001100010010110100000000"; -- Reg29 = 20000000 - 1312D00
	SIGNAL Reg30	: std_logic_vector (31 downto 0):="00000000000000000000000000000000"; -- Reg30 = 0 - 0
	SIGNAL Reg31	: std_logic_vector (31 downto 0):="00000000000000000000000000000000"; -- Reg31 = 0 - 0
	
	
	BEGIN

	
		WITH Adr1 SELECT
			Data_Out1 <= 	Reg0  WHEN "00000",
								Reg1  WHEN "00001",
								Reg2  WHEN "00010",
								Reg3  WHEN "00011",
								Reg4  WHEN "00100",
								Reg5  WHEN "00101",
								Reg6  WHEN "00110",
								Reg7  WHEN "00111",
								Reg8  WHEN "01000",
								Reg9  WHEN "01001",
								Reg10 WHEN "01010",
								Reg11 WHEN "01011",
								Reg12 WHEN "01100",
								Reg13 WHEN "01101",
								Reg14 WHEN "01110",
								Reg15 WHEN "01111",
								Reg16 WHEN "10000",
								Reg17 WHEN "10001",
								Reg18 WHEN "10010",
								Reg19 WHEN "10011",
								Reg20 WHEN "10100",
								Reg21 WHEN "10101",
								Reg22 WHEN "10110",
								Reg23 WHEN "10111",
								Reg24 WHEN "11000",
								Reg25 WHEN "11001",
								Reg26 WHEN "11010",
								Reg27 WHEN "11011",
								Reg28 WHEN "11100",
								Reg29 WHEN "11101",
								Reg30 WHEN "11110",
								Reg31 WHEN "11111";
								
		
		WITH Adr2 SELECT
			Data_Out2 <= 	Reg0  WHEN "00000",
								Reg1  WHEN "00001",
								Reg2  WHEN "00010",
								Reg3  WHEN "00011",
								Reg4  WHEN "00100",
								Reg5  WHEN "00101",
								Reg6  WHEN "00110",
								Reg7  WHEN "00111",
								Reg8  WHEN "01000",
								Reg9  WHEN "01001",
								Reg10 WHEN "01010",
								Reg11 WHEN "01011",
								Reg12 WHEN "01100",
								Reg13 WHEN "01101",
								Reg14 WHEN "01110",
								Reg15 WHEN "01111",
								Reg16 WHEN "10000",
								Reg17 WHEN "10001",
								Reg18 WHEN "10010",
								Reg19 WHEN "10011",
								Reg20 WHEN "10100",
								Reg21 WHEN "10101",
								Reg22 WHEN "10110",
								Reg23 WHEN "10111",
								Reg24 WHEN "11000",
								Reg25 WHEN "11001",
								Reg26 WHEN "11010",
								Reg27 WHEN "11011",
								Reg28 WHEN "11100",
								Reg29 WHEN "11101",
								Reg30 WHEN "11110",
								Reg31 WHEN "11111";

	process (clk)
		begin
			if (clk = '1' and clk'event) then
				if(RoW = '1') then		
					case AdrW is
						when "00000" =>	Reg0  <= Data_In;
						when "00001" =>	Reg1  <= Data_In;
						when "00010" =>	Reg2  <= Data_In;
						when "00011" =>	Reg3  <= Data_In;
						when "00100" =>	Reg4  <= Data_In;
						when "00101" =>	Reg5  <= Data_In;
						when "00110" =>	Reg6  <= Data_In;
						when "00111" =>	Reg7  <= Data_In;
						when "01000" =>	Reg8  <= Data_In;
						when "01001" =>	Reg9  <= Data_In;
						when "01010" =>	Reg10 <= Data_In;
						when "01011" =>	Reg11 <= Data_In;
						when "01100" =>	Reg12 <= Data_In;
						when "01101" =>	Reg13 <= Data_In;
						when "01110" =>	Reg14 <= Data_In;
						when "01111" =>	Reg15 <= Data_In;
						when "10000" =>	Reg16 <= Data_In;
						when "10001" =>	Reg17 <= Data_In;
						when "10010" =>	Reg18 <= Data_In;
						when "10011" =>	Reg19 <= Data_In;
						when "10100" =>	Reg20 <= Data_In;
						when "10101" =>	Reg21 <= Data_In;
						when "10110" =>	Reg22 <= Data_In;
						when "10111" =>	Reg23 <= Data_In;
						when "11000" =>	Reg24 <= Data_In;
						when "11001" =>	Reg25 <= Data_In;
						when "11010" =>	Reg26 <= Data_In;
						when "11011" =>	Reg27 <= Data_In;
						when "11100" =>	Reg28 <= Data_In;
						when "11101" =>	Reg29 <= Data_In;
						when "11110" =>	Reg30 <= Data_In;
						when "11111" =>	Reg31 <= Data_In;
					end case;
				end if;
			end if;

	end process;

END behavior;
