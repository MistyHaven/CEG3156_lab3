library ieee;
use ieee.std_logic_1164.all;

entity signExtend is
port (
  i_16 : in std_logic_vector(15 downto 0);
  o_32 : out std_logic_vector(31 downto 0)
);
end signExtend;

architecture rtl of signExtend is
begin
extend: for i in 31 downto 16 generate
  o_32(i) <= i_16(15); 
end generate;

o_32(15 downto 0) <= i_16;
end rtl;