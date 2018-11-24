LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY controle IS
	PORT (
		opcode 		: in std_logic_vector (5 downto 0);
		operacaoUla : out std_logic_vector (1 downto 0);
		RegWrite	: out std_logic; --sinal que habilita a escrita no banco de registradores
		MemToReg	: out std_logic; --sinal que indica que o dado a ser escrito no registrador de destino é um dadovindo da memória
		AluSrc		: out std_logic; --sinal que indica operando da ula
		MemWrite	: out std_logic; --sinal que habilita a escrita na memória, gerado na instrução de store
		MemRead		: out std_logic; --sinal que habilita a leitura da memória, gerado na instrução de load
		Branch		: out std_logic; --sinal que indica salto
		RegDst		: out std_logic --sinal utilizada para selecionar registrador destino
	);
END controle;

ARCHITECTURE comportamento OF controle IS
BEGIN
	process (opcode)
		begin
			CASE opcode IS

			WHEN "000000" => -- Formato R
				RegDst <= '1';
				AluSrc <= '0';
				MemToReg <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				Branch <= '0';
				operacaoUla <= "10";

			WHEN "100011" => -- 35 loadword / Formato I
				RegDst <= '0';
				AluSrc <= '1';
				MemToReg <= '1';
				MemRead <= '1';
				MemWrite <= '0';
				RegWrite <= '1';
				Branch <= '0';
				operacaoUla <= "00";

			WHEN "101011" => -- 43 storeword / Formato I
				RegDst <= '-';
				AluSrc <= '1';
				MemToReg <= '-';
				MemRead <= '0';
				MemWrite <= '1';
				RegWrite <= '0';
				Branch <= '0';
				operacaoUla <= "00";

			WHEN "000100" => -- 4 beq / Formato I
				RegDst <= '-';
				AluSrc <= '0';
				MemToReg <= '-';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				Branch <= '1';
				operacaoUla <= "01";

			WHEN "001000" => -- 8 addi / Formato I
				RegDst <= '0';
				AluSrc <= '1';
				MemToReg <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				Branch <= '0';
				operacaoUla <= "00";

			WHEN "001101" => -- 13 ori / Formato I
				RegDst <= '0';
				AluSrc <= '1';
				MemToReg <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '1';
				Branch <= '0';
				operacaoUla <= "00";

			WHEN "000010" => -- 2 jump / Formato J
				RegDst <= '-';
				AluSrc <= '-';
				MemToReg <= '-';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				Branch <= '0';
				operacaoUla <= "00";

			WHEN OTHERS => 
				RegDst <= '0';
				AluSrc <= '0';
				MemToReg <= '0';
				MemRead <= '0';
				MemWrite <= '0';
				RegWrite <= '0';
				Branch <= '0';
				operacaoUla <= "00";

		END CASE;
	end process;
END comportamento;