library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY shift_left_2 IS
	PORT (
		entrada		: in	std_logic_vector (31 downto 0);
		saida		: out	std_logic_vector (31 downto 0)
		);
END shift_left_2;

ARCHITECTURE behavioral OF shift_left_2 IS

BEGIN
	
	saida <= std_logic_vector(shift_left(unsigned(entrada), 2));

END behavioral;