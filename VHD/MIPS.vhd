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

--Declaraçao de Sinais de Controle

signal sinalFontePC								: std_logic;
signal sinalRDST									: std_logic;
signal sinalRDST2									: std_logic;
signal sinalAluSrc								: std_logic;
signal sinalAluSrc2								: std_logic;
signal sinalMemWrite								: std_logic;
signal sinalMemWrite2							: std_logic;
signal sinalMemWrite3							: std_logic;
signal sinalMemRead								: std_logic;
signal sinalMemRead2								: std_logic;
signal sinalMemRead3								: std_logic;
signal sinalBranch								: std_logic;
signal sinalBranch2								: std_logic;
signal sinalBranch3								: std_logic;
signal sinalMemToReg								: std_logic;
signal sinalMemToReg2							: std_logic;
signal sinalMemToReg3							: std_logic;
signal sinalMemToReg4							: std_logic;
signal sinalRegWrite								: std_logic;
signal sinalRegWrite2							: std_logic;
signal sinalRegWrite3							: std_logic;
signal sinalRegWrite4							: std_logic;
signal sinalWriteEnReg							: std_logic;
signal sinalZeroULA								: std_logic;
signal sinalZeroULA2								: std_logic;
signal sinalOpUla									: std_logic_vector (1 downto 0);
signal sinalOpUla2								: std_logic_vector (1 downto 0);
signal sinalOperacaoULA 						: std_logic_vector (3 downto 0);
signal sinalLeituraReg1							: std_logic_vector (4 downto 0);
signal sinalLeituraReg2							: std_logic_vector (4 downto 0);
signal sinalLeituraReg22						: std_logic_vector (4 downto 0);
signal sinalRegDestino							: std_logic_vector (4 downto 0);
signal sinalRegDestino2							: std_logic_vector (4 downto 0);
signal sinalEscreverNr							: std_logic_vector (4 downto 0);
signal sinalEscReg								: std_logic_vector (4 downto 0);
signal sinalEscReg2								: std_logic_vector (4 downto 0);
signal sinalOpCode								: std_logic_vector (5 downto 0);
signal sinalFuncao								: std_logic_vector (5 downto 0);
signal sinalImed									: std_logic_vector (15 downto 0);
signal sinalEntradaPC 							: std_logic_vector (31 downto 0);
signal sinalEntradaPC2 							: std_logic_vector (31 downto 0);
signal sinalSaidaPC								: std_logic_vector (31 downto 0);
signal sinalSaidaPC4								: std_logic_vector (31 downto 0);
signal sinalSaidaPC4_2							: std_logic_vector (31 downto 0);
signal sinalSaidaPC4_3							: std_logic_vector (31 downto 0);
signal sinalSaidaJump1							: std_logic_vector (31 downto 0);
signal sinalSaidaJump2							: std_logic_vector (31 downto 0);
signal sinalInst									: std_logic_vector (31 downto 0);
signal sinalDadoLido1							: std_logic_vector (31 downto 0);
signal sinalDadoLido12							: std_logic_vector (31 downto 0);
signal sinalDadoLido2							: std_logic_vector (31 downto 0);
signal sinalDadoLido22							: std_logic_vector (31 downto 0);
signal sinalDadoLido23							: std_logic_vector (31 downto 0);
signal sinalImedExtend							: std_logic_vector (31 downto 0);
signal sinalImedExtend2							: std_logic_vector (31 downto 0);
signal sinalSaidaJump							: std_logic_vector (31 downto 0);
signal sinalEntradaULA							: std_logic_vector (31 downto 0);
signal sinalResultULA							: std_logic_vector (31 downto 0);
signal sinalResultULA2							: std_logic_vector (31 downto 0);
signal sinalResultULA3							: std_logic_vector (31 downto 0);
signal sinalDadoReg								: std_logic_vector (31 downto 0);
signal sinalSaidaMemDados1 					: std_logic_vector (31 downto 0);
signal sinalSaidaMemoriaInstrucoes 			: std_logic_vector (31 downto 0);
signal sinalSaidaMemoriaDados 				: std_logic_vector (31 downto 0);
signal sinalEntradaPipe1, sinalSaidaPipe1 : std_logic_vector (63 downto 0);
signal sinalEntradaPipe2, sinalSaidaPipe2 : std_logic_vector (146 downto 0);
signal sinalEntradaPipe3, sinalSaidaPipe3 : std_logic_vector (106 downto 0);
signal sinalEntradaPipe4, sinalSaidaPipe4 : std_logic_vector (70 downto 0);

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
		WriteReg								: in std_logic_vector(31 downto 0);
		reset, clock, EnableWrite		: in std_logic;
		ReadReg1, ReadReg2, WriteRegNr: in std_logic_vector(4 downto 0);
		out1, out2							: out std_logic_vector(31 downto 0)
	);
END component;

component memData
	PORT(
		address	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		   : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

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
		RegWrite		: out std_logic;
		MemToReg		: out std_logic; 
		AluSrc		: out std_logic; 
		MemWrite		: out std_logic; 
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
	--Início Segundo Estagio
	
	sinalSaidaPC4_2 <= sinalSaidaPipe1(63 downto 32);
	sinalInst <= sinalSaidaPipe1(31 downto 0);
	
	sinalOpCode <= sinalInst(31 downto 26);
	sinalLeituraReg1 <= sinalInst (25 downto 21);
	sinalLeituraReg2 <= sinalInst (20 downto 16);
	sinalImed <= sinalInst(15 downto 0);
	sinalRegDestino <= sinalInst(15 downto 11);
	
	CONTROLADOR: controle port map (
		opcode => sinalOpCode, 		
		operacaoUla => sinalOpUla,
		RegWrite	=> sinalRegWrite,
		MemToReg	=> sinalMemToReg,
		AluSrc => sinalAluSrc,
		MemWrite	=> sinalMemWrite,
		MemRead => sinalMemRead, 
		Branch => sinalBranch,
		RegDst => sinalRDST
	);
	
	REGISSTRADORES : RegBank port map (
		WriteReg	=> sinalDadoReg,
		reset => reset,
		clock => clock,
		EnableWrite	=>	sinalWriteEnReg,
		ReadReg1 => sinalLeituraReg1,
		ReadReg2 => sinalLeituraReg2,
		WriteRegNr => sinalEscreverNr,
		out1 => sinalDadoLido1,
		out2 => sinalDadoLido2
	);
	
	EXTENSORDESINAL : extend_16_to_32 port map (
		entrada => sinalImed,
		saida => sinalImedExtend
	);
	
	sinalEntradaPipe2 <= sinalOpUla & sinalRDST & sinalAluSrc & sinalMemWrite & sinalMemRead & sinalBranch & sinalMemToReg & sinalRegWrite & sinalSaidaPC4_2 & sinalDadoLido1 & sinalDadoLido2 & sinalImedExtend & sinalLeituraReg2 & sinalRegDestino;

	PIPE2: flipflop GENERIC MAP (DATA_WIDTH => 147) PORT MAP (
		clk => clock,
		rst => reset,
		D => sinalEntradaPipe2,
		Q => sinalSaidaPipe2
	);
	--Fim do segundo estagio
	--Inicio do terceiro estagio
	
	sinalOpUla2 		<= sinalSaidaPipe2 (146 downto 145);
	sinalRDST2 			<= sinalSaidaPipe2 (144);
	sinalAluSrc2 		<= sinalSaidaPipe2 (143);
	sinalMemWrite2		<= sinalSaidaPipe2 (142);
	sinalMemRead2		<= sinalSaidaPipe2 (141);
	sinalBranch2		<= sinalSaidaPipe2 (140);
	sinalMemToReg2		<= sinalSaidaPipe2 (139);
	sinalRegWrite2 	<= sinalSaidaPipe2 (138);
	sinalSaidaPC4_3	<= sinalSaidaPipe2 (137 downto 106);
	sinalDadoLido12	<= sinalSaidaPipe2 (105 downto 74);
	sinalDadoLido22	<= sinalSaidaPipe2 (73 downto 42);
	sinalImedExtend2 	<= sinalSaidaPipe2 (41 downto 10);
	sinalFuncao			<= sinalImedExtend2 (5 downto 0);
	sinalLeituraReg22 <= sinalSaidaPipe2 (9 downto 5);
	sinalRegDestino2	<= sinalSaidaPipe2 (4 downto 0);
	
	sinalEntradaPC2 <= sinalImedExtend2 (29 downto 0) & "00";
	
	ENTRADAPC : adderAB GENERIC MAP (N => 32)	port map (
		A => sinalSaidaPC4_3, 
		B => sinalEntradaPC2,
		S => sinalSaidaJump
	);
	
	mux : mux_2x1 GENERIC MAP (N => 32) PORT MAP (
		entrada1	=> sinalDadoLido22,
		entrada2	=> sinalImedExtend2,
		sel => sinalAluSrc2,
		saida	=> sinalEntradaULA
	);
		
	OPERACAOULA : opULA PORT MAP (
		ULAop => sinalOpUla2,
		funct => sinalFuncao,
		oper => sinalOperacaoULA
	);
	
	ULA1 : ULA port map (
		entrada0 => sinalDadoLido12,
		entrada1 => sinalEntradaULA,
		operacao => sinalOperacaoULA,
		zero => sinalZeroULA,
		saida => sinalResultULA
	);
	
	mux2 : mux_2x1 GENERIC MAP (N => 5) PORT MAP (
		entrada1	=> sinalLeituraReg22,
		entrada2	=> sinalRegDestino2,
		sel => sinalRDST2,
		saida	=> sinalEscReg
	);
	
	sinalEntradaPipe3 <= sinalMemWrite2 & sinalMemRead2 & sinalBranch2 & sinalMemToReg2 & sinalRegWrite2 & sinalSaidaJump & sinalZeroULA & sinalResultULA & sinalDadoLido22 & sinalEscReg;
	
	PIPE3 : flipflop GENERIC MAP (DATA_WIDTH => 107) PORT MAP (
		clk => clock,
		rst => reset,
		D => sinalEntradaPipe3,
		Q => sinalSaidaPipe3
	);
	
	--Fim terceiro estagio
	--Inicio quarto estagio
	
	sinalMemWrite3 <= sinalSaidaPipe3 (106);
	sinalMemRead3	<= sinalSaidaPipe3 (105);
	sinalBranch3	<= sinalSaidaPipe3 (104);
	sinalMemToReg3 <= sinalSaidaPipe3 (103);
	sinalRegWrite3 <= sinalSaidaPipe3 (102);
	sinalSaidaJump2<= sinalSaidaPipe3 (101 downto 70);
	sinalZeroULA2	<= sinalSaidaPipe3 (69);
	sinalResultULA2<= sinalSaidaPipe3 (68 downto 37);
	sinalDadoLido23<= sinalSaidaPipe3 (36 downto 5);
	sinalEscReg2	<= sinalSaidaPipe3 (4 downto 0);
	
	sinalFontePC <= sinalBranch3 and sinalZeroULA2;
	
	MEMORIADADOS : memData PORT MAP (
		address	 => sinalResultULA2(11 downto 2),
		clock	 => clock,
		data => sinalDadoLido23,
		wren => sinalMemWrite3,
		q	 => sinalSaidaMemoriaDados
	);
	
	sinalEntradaPipe4 <= sinalMemToReg3 & sinalRegWrite3 & sinalSaidaMemoriaDados & sinalResultULA2 & sinalEscReg2;
	
	PIPE4: flipflop GENERIC MAP (DATA_WIDTH => 71) PORT MAP (
		clk => clock,
		rst => reset,
		D => sinalEntradaPipe4,
		Q => sinalSaidaPipe4
	);
	
	--FIM QUARTO ESTADIO
	--INICIO QUINTO ESTAGIO
	
	sinalMemToReg4 		<= sinalSaidaPipe4 (70);
	sinalWriteEnReg 		<= sinalSaidaPipe4 (69);
	sinalSaidaMemDados1	<= sinalSaidaPipe4 (68 downto 37);
	sinalResultULA3		<= sinalSaidaPipe4 (36 downto 5);
	sinalEscreverNr		<= sinalSaidaPipe4 (4 downto 0);
	
	mux3 : mux_2x1 GENERIC MAP (N => 32) PORT MAP (
		entrada1	=> sinalResultULA3,
		entrada2	=> sinalSaidaMemDados1,
		sel => sinalMemToReg4,
		saida	=> sinalDadoReg
	);
	
	saida <= sinalDadoReg;
	
	--FIM
	
end MIPS_ARC;