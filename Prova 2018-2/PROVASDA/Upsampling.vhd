library IEEE;
use IEEE.std_logic_1164.all;

entity Upsampling is
	port( clk : 		in bit;
			saida : 		out bit );
end Upsampling;

architecture behavioral of Upsampling is

	COMPONENT Memory IS
		PORT(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		data			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren			: IN STD_LOGIC ;
		q				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT Multiplier5 IS
		PORT(
		dataa			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT Multiplier20 IS
		PORT(
		dataa			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
	END COMPONENT;
	
begin

	
	
end behavioral;