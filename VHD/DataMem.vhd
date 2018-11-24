Library IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DataMem IS
	PORT (
		WriteReg: 						in std_logic_vector(31 downto 0);
		WriteRegNr:						in std_logic_vector(4 downto 0);
		reset, clock, EnableWrite: 		in std_logic;
		out1: 							out std_logic_vector(31 downto 0)
	);
END DataMem;

ARCHITECTURE behavioral OF DataMem IS

	signal aux: std_logic_vector(31 downto 0);

	COMPONENT RegN
		GENERIC (N 		: integer := 32);
		PORT (
			entrada		: in	std_logic_vector (N-1 downto 0);
			reset		: in	std_logic;
			clock		: in	std_logic;
			enable		: in 	std_logic;
			saida		: out	std_logic_vector (N-1 downto 0)
			);
	END COMPONENT;

BEGIN
	aux <= WriteReg;
	
	Reg: RegN
		GENERIC MAP (N => 32)
		PORT MAP(
			entrada 	=> aux,
			reset 		=> reset,
			clock 		=> clock,
			enable 		=> '1',
			saida 		=> out1
		);	

END behavioral;	 