library IEEE;
use IEEE.std_logic_1164.all;
use work.matrix32x32.all;

ENTITY mux_32x1 IS
	PORT (
		entrada		: in	matrix32;
		sel			: in 	std_logic_vector(4 downto 0);
		saida			: out	std_logic_vector(31 downto 0)
		);
END mux_32x1;

ARCHITECTURE behavioral OF mux_32x1 IS

BEGIN
	
	WITH sel SELECT
		saida <= 	entrada(0) when "00000",
					entrada(1) when "00001",
					entrada(2) when "00010",
					entrada(3) when "00011",
					entrada(4) when "00100",
					entrada(5) when "00101",
					entrada(6) when "00110",
					entrada(7) when "00111",
					entrada(8) when "01000",
					entrada(9) when "01001",
					entrada(10) when "01010",
					entrada(11) when "01011",
					entrada(12) when "01100",
					entrada(13) when "01101",
					entrada(14) when "01110",
					entrada(15) when "01111",
					entrada(16) when "10000",
					entrada(17) when "10001",
					entrada(18) when "10010",
					entrada(19) when "10011",
					entrada(20) when "10100",
					entrada(21) when "10101",
					entrada(22) when "10110",
					entrada(23) when "10111",
					entrada(24) when "11000",
					entrada(25) when "11001",
					entrada(26) when "11010",
					entrada(27) when "11011",
					entrada(28) when "11100",
					entrada(29) when "11101",
					entrada(30) when "11110",
					entrada(31) when "11111",
					"00000000000000000000000000000000" when others;

END behavioral;