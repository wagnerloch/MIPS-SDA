library IEEE;
use IEEE.std_logic_1164 .all;
USE ieee.std_logic_unsigned.all;

ENTITY adderAB IS
	GENERIC (N 		: integer := 32);
	port (
		A, B	: in std_logic_vector (N-1 downto 0);
		S		: out std_logic_vector (N-1 downto 0)
	);
END ENTITY;

ARCHITECTURE behavioral OF adderAB IS

begin

	S <= A + B;

end architecture;