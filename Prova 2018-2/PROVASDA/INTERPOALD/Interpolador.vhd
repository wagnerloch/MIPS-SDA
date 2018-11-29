library IEEE;
use IEEE.std_logic_1164.all;
Use work.newtype.all; 

ENTITY Interpolador IS
	port( clock, inicio  			:	in STD_LOGIC;
			amostraIN					:	in matrix_type;
			amostraOUT, amostraOUT2	:	out STD_LOGIC_VECTOR (7 DOWNTO 0);
			endereco						:	out STD_LOGIC_VECTOR (9 DOWNTO 0);
			trocaLinha, incioImagem, valido	:	out STD_LOGIC 
			);
END Interpolador;

architecture behavioral of Interpolador is
	
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
	
	signal EE, FF, GG, HH, II, JJ: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
begin

	process(clock)
	begin
		loop1:	FOR i IN 0 TO 512 
			loop2: FOR j IN 0 TO 512 	
				loop3: FOR k IN 0 TO 5 
					if (k = 0) then
						EE <= amostraIN(i + j + k);
					elsif (k = 1) then
						FF <= (amostraIN(i + j + k) << 2) + amostraIN(i + j + k);
					elsif (k = 2) then
						GG <= (amostraIN(i + j + k) << 4) + (amostraIN(i + j + k) << 2);
					elsif (k = 3) then
						HH <= (amostraIN(i + j + k) << 4) + (amostraIN(i + j + k) << 2);
					elsif (k = 4) then
						II <= (amostraIN(i + j + k) << 2) + amostraIN(i + j + k);
					elsif (k = 5) then
						JJ <= amostraIN(i + j + k);
					end if;
				END loop3;
				amostraOUT <= amostraIN(i + j);
				amostraOUT2 <= EE - FF + GG + HH - II + JJ;
			END loop2;
		END loop1;
	end process;
	
end behavioral;