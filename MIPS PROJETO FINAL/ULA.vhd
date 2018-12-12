LIBRARY IEEE;
Use ieee.std_logic_1164.all;
Use ieee.std_logic_unsigned.all;
Use ieee.numeric_std.all;

Entity ULA is
port (
	entrada0 : in std_logic_vector(31 downto 0);
	entrada1 : in std_logic_vector(31 downto 0);
	operacao : in std_logic_vector(3 downto 0);
	zero : out std_logic;
	saida : out std_logic_vector(31 downto 0)
);
end ULA;

architecture ULA_ARQ of ULA is
	signal sinal_saida: std_logic_vector(31 downto 0);
	
begin

	process(operacao, entrada0, entrada1)
	begin
		case operacao is
			when "0000" => --and
				sinal_saida <= entrada0 and entrada1;
			when "0001" => --or
				sinal_saida <= entrada0 or entrada1;
			when "0010" => --soma
				sinal_saida <= entrada0 + entrada1;
			when "0011" => --multiplicacao
				sinal_saida <= std_logic_vector(unsigned (entrada0 * entrada1))(31 downto 0);
			--when "0100" => --divisao
				--sinal_saida <= std_logic_vector(unsigned (entrada0 / entrada1));
			when "0101" => --nor
				sinal_saida <= entrada0 nor entrada1;
			when "0110" => --subtracao
				sinal_saida <= entrada0 - entrada1;
			when "0111" => -- set on less than
				sinal_saida <= (0 => '1', others => '0');
			when "1000" => --xor
				sinal_saida <= entrada0 xor entrada1;
			when "1001" => --shift left
				sinal_saida <= std_logic_vector(signed(entrada0) sll to_integer(signed(entrada1)));
			when "1010" => --shift right
				sinal_saida <= std_logic_vector(signed(entrada0) srl to_integer(signed(entrada1)));
			when "1011" =>
				sinal_saida <= std_logic_vector(shift_right(signed(entrada0),to_integer(signed(entrada1))));
			when "1100" =>
				if (entrada0 < entrada1) then
					sinal_saida <= "00000000000000000000000000000001";
				else
					sinal_saida <= "00000000000000000000000000000000";
				end if;
			when "1101" =>
				if (unsigned(entrada0) < unsigned(entrada1)) then
					sinal_saida <= "00000000000000000000000000000001";
				else
					sinal_saida <= "00000000000000000000000000000000";
				end if;
			WHEN OTHERS =>
				sinal_saida <= entrada0;
		end case;
	end process;
	
	zero <= '1' when sinal_saida = "00000000000000000000000000000000"
		else '0';
	
	saida <= sinal_saida;
end ULA_ARQ;