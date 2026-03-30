library ieee;
use ieee.std_logic_1164.all;

entity hazardDetectionUnit is 
  generic (
    bit_width : integer := 5
  );
  port(
    IdExMemRead, IfIdSelectRs,IfIdSelectRt : in std_logic; 
    branch, jump, bne : in std_logic;

    o_stall, o_flush : out std_logic
);
end hazardDetectionUnit;

architecture rtl of hazardDetectionUnit is
begin
  o_flush <= branch or jump or bne;
  o_stall <= IdExMemRead and (not (IdExMemRead xor IfIdSelectRs) or not (IdExMemRead xor IfIdSelectRt));
end rtl;
