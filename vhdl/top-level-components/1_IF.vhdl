library ieee;
use ieee.std_logic_1164.all;

entity IF_1 is
  port (
    clock : in std_logic;
    i_BranchAddr : in std_logic_vector(32-1 downto 0);
    i_BranchSel : in std_logic;
    
    o_PcOut : out std_logic_vector(32-1 downto 0);
    o_EffectiveAddr : out std_logic_vector(32-1 downto 0)
  );
end IF_1;

architecture rtl of IF_1 is
  component regPIPO_nBit is
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;

      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;

  component addSub_nBit is
    generic ( n : integer := 32);
    port (
      x , y: in std_logic_vector(n-1 downto 0);
      ci: in std_logic;
      s: out std_logic_vector(n-1 downto 0);
      co: out std_logic
   );
  end component;

  component mux2_nBit is
  generic (bit_width : integer := 8);
  port (
    i_1, i_2 : in std_logic_vector(bit_width-1 downto 0);
    sel : in std_logic;
    o : out std_logic_vector(bit_width-1 downto 0)
  );
  end component;

  signal four : std_logic_vector(32-1 downto 0);
  signal zero : std_logic;
  signal PC_in, PC_out, PC_plusFour, EffectiveAddr: std_logic_vector(32-1 downto 0);

begin 

  four <= ( 2 => '1', others => '0' );
  zero <= '0';

  o_PcOut <= PC_out;
  o_EffectiveAddr <= EffectiveAddr;

  pc : regPIPO_nBit
  generic map ( bit_width => 32-1)
  port map (
    clock => clock,
    reset  => zero,
    load  => clock,
    d  => PC_in,
    o  => PC_out
  );

  pcPlusFour : addSub_nBit 
  generic map ( n => 32-1 )
  port map (
    x => PC_out,
    y => four,
    s => PC_plusFour,
    ci => zero
  );

  pcInMUX : mux2_nBit
  generic map (bit_width => 32-1) 
  port map (
    i_1 => PC_plusFour,
    i_2 => i_BranchAddr,
    sel => i_BranchSel,
    o => PC_in
  );
end rtl;
