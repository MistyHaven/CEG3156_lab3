library ieee;
use ieee.std_logic_1164.all;

entity hazardDetectionUnit is 
  generic (
    bit_width : integer := 5
  );
  port(
    IdExMemRead : in std_logic; 
    IdExRegRt, IfIdRegRs, IfIdRegRt : in std_logic_vector(bit_width-1 downto 0);
    branch, jump, bne : in std_logic;

    o_stall, o_flush : out std_logic
);
end hazardDetectionUnit;

architecture rtl of hazardDetectionUnit is
component equalsChecker is
  generic ( n : integer := 4 );
  port (
    x , y: in std_logic_vector(n-1 downto 0);
    o: out std_logic
 );
end component;
signal eq1, eq2 : std_logic;
begin
  o_flush <= branch or jump or bne;

  rtRs: equalsChecker
   generic map( n => bit_width)
   port map(
      x => IdExRegRt,
      y => IfIdRegRs,
      o => eq1
  );

  rtRt: equalsChecker
   generic map( n => bit_width)
   port map(
      x => IdExRegRt,
      y => IfIdRegRt,
      o => eq2
  );
  o_stall <= IdExMemRead and (eq1 or eq2);
end rtl;
