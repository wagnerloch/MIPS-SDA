library ieee;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPS is
    Port (
		saida: out std_logic_vector(31 downto 0);
		clock, reset: in std_logic
	 );
end MIPS;

architecture MIPS_ARC of MIPS is
--Declaraçao de Sinais
signal sinalEntradaPC 	: std_logic_vector(31 downto 0);
signal sinalSaidaPC		: std_logic_vector(31 downto 0);
signal sinalSaidaPC4		: std_logic_vector(31 downto 0);
signal sinalSaidaJump1	: std_logic_vector(31 downto 0);
signal sinalEntradaPipe1, sinalSaidaPipe1 : std_logic_vector (63 downto 0);
signal sinalSaidaMemoriaInstrucoes : std_logic_vector (31 downto 0);
signal sinalFontePC		: std_logic;



--Declaraçao de Componentes

component RegN
	GENERIC (N 		: integer := 8);
	PORT (
		entrada		: in	std_logic_vector (N-1 downto 0);
		reset			: in	std_logic;
		clock			: in	std_logic;
		enable		: in 	std_logic;
		saida			: out	std_logic_vector (N-1 downto 0)
		);
END component;

component memInst
	PORT(
		address	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
	
component memInst2
	generic (
		wlength: integer := 32;
		words  : integer := 10
	);
	Port(
		data: IN std_logic_vector(wlength-1 downto 0);
		address: IN std_logic_vector(words-1 downto 0);
		clock, wren: IN std_logic;
		q: OUT std_logic_vector(wlength-1 downto 0)
	);
end component;

component DataMem 
	PORT (
		WriteReg: 						in std_logic_vector(31 downto 0);
		WriteRegNr:						in std_logic_vector(4 downto 0);
		reset, clock, EnableWrite: 		in std_logic;
		out1: 							out std_logic_vector(31 downto 0)
	);
END component;

component adderAB
	GENERIC (N 		: integer := 8);
	port (
		A, B	: in std_logic_vector (N-1 downto 0);
		S		: out std_logic_vector (N-1 downto 0)
	);
END component;

component mux_2x1
	GENERIC (N 		: integer := 32);
	PORT (
		entrada1		: in	std_logic_vector (N-1 downto 0);
		entrada2		: in	std_logic_vector (N-1 downto 0);
		sel			: in 	std_logic;
		saida			: out	std_logic_vector (N-1 downto 0)
		);
END component;

component PC
	generic(
		DATA_WIDTH : natural := 5
	);
	port(
		clk, rst: in std_logic;  
		D : in  std_logic_vector ((DATA_WIDTH-1) downto 0);  
		Q : out std_logic_vector ((DATA_WIDTH-1) downto 0)
	);  
end component;

component RegBank
	PORT (
		WriteReg: 						in std_logic_vector(31 downto 0);
		reset, clock, EnableWrite: 		in std_logic;
		ReadReg1, ReadReg2, WriteRegNr: in std_logic_vector(4 downto 0);
		out1, out2: 					out std_logic_vector(31 downto 0)
	);
END component;

component extend_16_to_32
	PORT (
		entrada		: in	std_logic_vector (15 downto 0);
		saida		: out	std_logic_vector (31 downto 0)
		);
END component;

component controle
	PORT (
		opcode 		: in std_logic_vector (5 downto 0);
		operacaoUla : out std_logic_vector (1 downto 0);
		RegWrite	: out std_logic;
		MemToReg	: out std_logic; 
		AluSrc		: out std_logic; 
		MemWrite	: out std_logic; 
		MemRead		: out std_logic; 
		Branch		: out std_logic; 
		RegDst		: out std_logic 
	);
END component;

component flipflop
	generic(
		DATA_WIDTH : natural := 32
	);
	port(
		clk, rst : in std_logic;  
		D : in  std_logic_vector ((DATA_WIDTH-1) downto 0);  
		Q : out std_logic_vector ((DATA_WIDTH-1) downto 0)
	);  
end component;

component ULA
port (
	entrada0 : in std_logic_vector(31 downto 0);
	entrada1 : in std_logic_vector(31 downto 0);
	operacao : in std_logic_vector(3 downto 0);
	zero : out std_logic;
	saida : out std_logic_vector(31 downto 0)
);
end component;

component opULA
		PORT (
			ULAop :in std_logic_vector(1 downto 0);
			funct :in std_logic_vector(5 downto 0);
			oper :out std_logic_vector(3 downto 0)
		);
	END component;

begin
	-- Primeiro Estagio
	ProgramCounter: PC generic map( DATA_WIDTH => 32) port map(
		clk => clock,
		rst => reset,
		D => sinalEntradaPC,
		Q => sinalSaidaPC
	);
	
	MuxEntradaPC: mux_2x1 generic map (N=>32)port map (
		entrada1 => sinalSaidaPC4, 
		entrada2 => sinalSaidaJump1,
		sel => sinalFontePC,
		saida => sinalEntradaPC
		);
		
	PCSoma4: adderAB generic map(N=>32)	port map (
		A => sinalSaidaPC,
		B => "00000000000000000000000000000100",
		S => sinalSaidaPC4
	);
	
	memInstrucao: memInst2 PORT MAP (
		address	 => sinalSaidaPC(11 downto 2),
		clock	 => clock,
		data => (others => '0'),
		wren => '0',
		q	 => sinalSaidaMemoriaInstrucoes
	);
	
	sinalEntradaPipe1 <= sinalSaidaPC4 & sinalSaidaMemoriaInstrucoes;
	
	PIPE1: flipflop GENERIC MAP (DATA_WIDTH => 64) PORT MAP (
		clk => clock,
		rst => reset,
		D => sinalEntradaPipe1,
		Q => sinalSaidaPipe1
	);

	--Fim Primeiro Estagio
end MIPS_ARC;