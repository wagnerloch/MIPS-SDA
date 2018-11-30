library IEEE; 
use IEEE.STD_LOGIC_1164.all; 

package newtype is
	subtype rows is STD_LOGIC_VECTOR (7 DOWNTO 0);
	type matrix_type is array(5 downto 0) of rows;
end newtype;