library ieee;
use ieee.std_logic_1164.all;

entity concat is
port (
  i_4 : in std_logic_vector(3 downto 0);
  i_28 : in std_logic_vector(27 downto 0);
  o_32 : out std_logic_vector(31 downto 0)
);
end concat;

architecture rtl of concat is
begin
o_32(31 downto 28) <= i_4;
o_32(27 downto 0) <= i_28;
end rtl;