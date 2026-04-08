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
	
	--not (i(31) and i(30) and i(29) and i(28) and i(27) and i(26) and i(25) and i(24) and
			--			i(23) and i(22) and i(21) and i(20) and i(19) and i(18) and i(17) and i(16) and
				--		i(15) and i(14) and i(13) and i(12) and i(11) and i(10) and i(9) and i(8) and
					--	i(7) and i(6) and i(5) and i(4) and i(3) and i(2) and i(1) and i(0));
end rtl;
