library IEEE;
use IEEE.std_logic_1164.all;

ENTITY RegN IS
	GENERIC (N 		: integer := 32);
	PORT (
		entrada		: in	std_logic_vector (N-1 downto 0);
		reset		: in	std_logic;
		clock		: in	std_logic;
		enable		: in 	std_logic;
		saida		: out	std_logic_vector (N-1 downto 0)
		);
END RegN;

ARCHITECTURE behavioral OF RegN IS

BEGIN

	process(reset, clock)
	begin
		if reset = '1' then
			saida <= (OTHERS => '0');
		elsif clock'EVENT and clock = '1' and enable = '1' then
			saida <= entrada;
		end if;
	end process;

END behavioral;