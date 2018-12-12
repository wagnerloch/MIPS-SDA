library IEEE;
use IEEE.std_logic_1164.all;

ENTITY mux_2x1 IS
	GENERIC (N 		: integer := 32);
	PORT (
		entrada1		: in	std_logic_vector (N-1 downto 0);
		entrada2		: in	std_logic_vector (N-1 downto 0);
		sel				: in 	std_logic;
		saida			: out	std_logic_vector (N-1 downto 0)
		);
END mux_2x1;

ARCHITECTURE behavioral OF mux_2x1 IS

BEGIN
	
	WITH sel SELECT
		saida <= 	entrada1 WHEN '0',
					entrada2 WHEN OTHERS;

END behavioral;