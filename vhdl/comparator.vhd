library ieee;
use ieee.std_logic_1164.all;


entity comparator is 
generic (bit_width : integer := 32);
	port( 
    a : in std_logic_vector (bit_width - 1 downto 0);
    b : in std_logic_vector (bit_width - 1 downto 0);
    equal : out std_logic;
    not_equal  : out std_logic
	);
end comparator;


architecture rtl of comparator is
begin
equal <= a AND b;
end rtl;
	

