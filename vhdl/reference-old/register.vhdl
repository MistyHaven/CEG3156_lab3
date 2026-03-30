library ieee;
use ieee.std_logic_1164.all;

entity nBit_register is
  generic ( bit_width : integer := 32 );
  port (
    clock, reset : in std_logic;
    load : in std_logic;

    d : in std_logic_vector(bit_width-1 downto 0);
    o : out std_logic_vector(bit_width-1 downto 0)
  );
end nBit_register;

architecture rtl of nBit_register is
component dFF_2 is
	port(
		i_d	: in std_logic;
		i_clock	: in std_logic;
		o_q, o_qbar	: out	std_logic
  );
end component;

signal int_load : std_logic;
signal int_data : std_logic_vector(bit_width-1 downto 0);

begin

  -- there HAS to be a better way to do this
  data: for i in bit_width-1 downto 0 generate
  begin
    int_data(i) <= d(i) and not reset;
  end generate;

  int_load <= load and clock;

  bits: for i in bit_width-1 downto 0 generate
  begin
    b_i : dFF_2
    port map (
      i_d => d(i),
      i_clock => int_load,
      o_q => o(i)
    );
  end generate;

end rtl;
