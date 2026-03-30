-- made by Kai Rasco #300304789
-- for ceg3155

-- ==== 1-bit INVERTER (for subtraction)
library ieee;
use ieee.std_logic_1164.all;
entity inverter_1bit is 
  port (
    a, s: in std_logic;
    o : out std_logic
  );
end inverter_1bit;

architecture structural of inverter_1bit is
  begin
  o <= a xor s;
end structural;