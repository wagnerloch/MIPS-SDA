library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

PACKAGE matrix32x32 IS 

	SUBTYPE column IS std_logic_vector(31 downto 0);
	TYPE matrix32 IS array (31 downto 0) of column;

END matrix32x32; 

PACKAGE BODY matrix32x32 IS 

END matrix32x32; 