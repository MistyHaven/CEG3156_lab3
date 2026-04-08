library ieee;
use ieee.std_logic_1164.all;

entity shl2 is
generic (bit_width : integer := 32);
port (
  i : in std_logic_vector(bit_width-3 downto 0);
  o_shifted : out std_logic_vector(bit_width-1 downto 0)
);
end shl2;

architecture rtl of shl2 is
begin
  o_shifted(bit_width-1 downto 2) <= i(bit_width-3 downto 0);
  o_shifted(1 downto 0) <= "00" ; 
end rtl;