library ieee;
use ieee.std_logic_1164.all;

entity addOp is 
	port(
		addOp : out std_logic_vector(2 downto 0)
	);
end addOp;

architecture rtl of addOp is
begin
	addOp <= "010";
end rtl;