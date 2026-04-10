library ieee;
use ieee.std_logic_1164.all;

entity buffer_IfId is 
  port (
    clk: in std_logic;
    flush: in std_logic;
    
    i_IfInstruction : in std_logic_vector(32-1 downto 0);
    i_IfEffectiveAddress : in std_logic_vector(32-1 downto 0);

    o_IdInstruction : out std_logic_vector(32-1 downto 0);
    o_IdEffectiveAddress : out std_logic_vector(32-1 downto 0)
  );
end buffer_IfId;

architecture rtl of buffer_IfId is
  component regPIPO_nBit is
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;
      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;

  signal buffer_in : std_logic_vector(64-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
  signal buffer_out : std_logic_vector(64-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE

begin

  buffer_in(31 downto 0) <= i_IfInstruction;
  buffer_in(63 downto 32) <= i_IfEffectiveAddress;

  o_IdInstruction <= buffer_out(31 downto 0);
  o_IdEffectiveAddress <= buffer_out(63 downto 32);

  buf: regPIPO_nBit
  generic map( bit_width => 32) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => clk,
    reset => flush,
    load => clk,
    d => buffer_in,
    o => buffer_out
  );
end rtl;

