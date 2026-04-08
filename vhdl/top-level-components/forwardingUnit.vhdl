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
  component equalsChecker is
    generic ( n : integer := 4 );
    port (
      x , y: in std_logic_vector(n-1 downto 0);
      o: out std_logic
   );
  end component;
  component isZero is
  port (
    i : in std_logic_vector(4 downto 0);
    o : out std_logic
  );
  end component;

  signal eq_ExMemRd_IdExRs, eq_MemWbRd_IdExRs,
          eq_ExMemRd_IdExRt,eq_MemWbRd_IdExRt  : std_logic;
  signal RsRtEq, ExMemRdZero, MemWbRdZero: std_logic;
begin
  eq1: equalsChecker
    generic map ( n => bit_width )
    port map (
      x => ExMemRegRd,
      y => IdExRegRs,
      o => eq_ExMemRd_IdExRs
   );

  eq2: equalsChecker
    generic map ( n => bit_width )
    port map (
      x => MemWbRegRd,
      y => IdExRegRs,
      o => eq_MemWbRd_IdExRs
   );

  eq3: equalsChecker
    generic map ( n => bit_width )
    port map (
      x => ExMemRegRd,
      y => IdExRegRt,
      o => eq_ExMemRd_IdExRt
   );

  eq4: equalsChecker
    generic map ( n => bit_width )
    port map (
      x => MemWbRegRd,
      y => IdExRegRt,
      o => eq_MemWbRd_IdExRt
   );

  z1: isZero
   port map(
      i => ExMemRegRd,
      o => ExMemRdZero
  );

  z2: isZero
   port map(
      i => MemWbRegRd,
      o => MemWbRdZero
  );

  forwardA(1) <= ExMemRegWrite and not ExMemRdZero and eq_ExMemRd_IdExRs;
  forwardA(0) <= MemWbRegWrite and not MemWbRdZero and eq_MemWbRd_IdExRs;

  forwardB(1) <= ExMemRegWrite and not ExMemRdZero and eq_ExMemRd_IdExRt;
  forwardB(0) <= MemWbRegWrite and not MemWbRdZero and eq_MemWbRd_IdExRt;
end rtl;
