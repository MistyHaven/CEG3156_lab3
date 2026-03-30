library ieee;
use ieee.std_logic_1164.all;
entity isZero is
port (
  i : in std_logic_vector(4 downto 0);
  o : out std_logic
);
end isZero;

architecture rtl of isZero is
begin
	o <= not (i(4) and i(3) and i(2) and i(1) and i(0));
end rtl;
