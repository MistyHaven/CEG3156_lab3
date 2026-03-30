library ieee;
use ieee.std_logic_1164.all;

entity forwardingUnit is 
  generic ( bit_width : integer := 5 );
  port(
    ExMemRegWrite : in std_logic;
    MemWbRegWrite: in std_logic;
    ExMemRegRead: in std_logic;
    MemWbRegRead: in std_logic;

    ExMemRegRd: in std_logic_vector(bit_width-1 downto 0);
    MemWbRegRd: in std_logic_vector(bit_width-1 downto 0);
    IdExRegRs: in std_logic_vector(bit_width-1 downto 0);
    IdExRegRt: in std_logic_vector(bit_width-1 downto 0);

    forwardA : out std_logic_vector(1 downto 0);
    forwardB : out std_logic_vector(1 downto 0)
);
end forwardingUnit;

architecture rtl of forwardingUnit is
  signal eq_ExMemRd_IdExRs, eq_MemWbRd_IdExRs,
          eq_ExMemRd_IdExRt,eq_MemWbRd_IdExRt  : std_logic;
  signal RsRtEq, ExMemRdNotZero, MemWbRdNotZero: std_logic;
begin

  forwardA(1) <= ExMemRegWrite and ExMemRdNotZero and eq_ExMemRd_IdExRs;
  forwardA(0) <= MemWbRegWrite and MemWbRdNotZero and eq_MemWbRd_IdExRs;

  forwardB(1) <= ExMemRegWrite and ExMemRdNotZero and eq_ExMemRd_IdExRt;
  forwardB(0) <= MemWbRegWrite and MemWbRdNotZero and eq_MemWbRd_IdExRt;


end rtl;
