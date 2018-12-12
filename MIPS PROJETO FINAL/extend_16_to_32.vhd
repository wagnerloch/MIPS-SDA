library IEEE;
use IEEE.std_logic_1164.all;

ENTITY extend_16_to_32 IS
	PORT (
		entrada		: in	std_logic_vector (15 downto 0);
		saida		: out	std_logic_vector (31 downto 0)
		);
END extend_16_to_32;

ARCHITECTURE behavioral OF extend_16_to_32 IS

BEGIN
	
	saida <= "0000000000000000" & entrada;

END behavioral;