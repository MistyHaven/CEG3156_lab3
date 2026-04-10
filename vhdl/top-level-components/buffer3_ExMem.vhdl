library ieee;
use ieee.std_logic_1164.all;

entity buffer_ExMem is 
  port (
    i_clk: in std_logic;
    i_flush: in std_logic

    
  );
end buffer_ExMem;

architecture rtl of buffer_ExMem is
  component regPIPO_nBit is
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;
      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;
  signal buffer_in : std_logic_vector(32 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
  signal buffer_out : std_logic_vector(32 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
begin


  buf: regPIPO_nBit
  generic map( bit_width => 32) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => i_clk,
    reset => i_flush,
    load => i_clk,
    d => buffer_in,
    o => buffer_out
  );
end architecture;

