Library IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
USE IEEE.std_logic_arith.all;
USE work.matrix32x32.all; 

Entity RegBank IS
port (
	WriteReg: 						in std_logic_vector(31 downto 0);
	reset, clock, EnableWrite: 		in std_logic;
	ReadReg1, ReadReg2, WriteRegNr: in std_logic_vector(4 downto 0);
	out1, out2: 					out std_logic_vector(31 downto 0)
);
end RegBank;

ARCHITECTURE behavioral OF RegBank IS

	signal aux_enable, aux_dec: std_logic_vector(31 downto 0);
	signal aux_mux: matrix32;

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
	
	COMPONENT dec_5x1
		PORT (
			entrada		: in	std_logic_vector(4 downto 0);
			saida		: out	std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	COMPONENT mux_32x1
		PORT (
			entrada			: in	matrix32;
			sel				: in 	std_logic_vector(4 downto 0);
			saida			: out	std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
BEGIN

	Bank: FOR i IN 0 TO 31 GENERATE  -- Instancia dos 32 registradores
		RegBankx: RegN
			GENERIC MAP (N => 32)
			PORT MAP(
			entrada 	=> WriteReg,
			reset 		=> reset,
			clock 		=> clock,
			enable 		=> aux_enable(i),
			saida 		=> aux_mux(i)
			);
	END GENERATE;

	Dec_Out: dec_5x1 -- Enable dos registradores
		PORT MAP (
			entrada => WriteRegNr,
			saida => aux_dec
		);

	Write_Control: FOR i IN 0 TO 31 GENERATE -- Auxiliar para o enable dos registradores
		aux_enable(i) <= aux_dec(i) AND EnableWrite;
	END GENERATE;

	Mux_Out1: mux_32x1 -- Saida registrador 1
		PORT MAP (
			entrada => aux_mux,
			sel => ReadReg1,
			saida => out1
		);

	Mux_Out2: mux_32x1 -- Saida registrador 2
		PORT MAP (
			entrada => aux_mux,
			sel => ReadReg2,
			saida => out2
		);

END behavioral;	 