-- 1-indexed because i forgor
library ieee;
use ieee.std_logic_1164.all;
entity alu is
generic (bit_width : integer := 32);
port (
  i_a, i_b : in std_logic_vector(bit_width-1 downto 0);
  i_operation : in std_logic_vector(2 downto 0);
  o_aluZero, o_aluCarryOut : out std_logic;
  o : out std_logic_vector(bit_width-1 downto 0)
);
end alu;

architecture rtl of alu is


  component addSub_nBit is
    generic ( n : integer := bit_width );
    port (
      x , y: in std_logic_vector(n-1 downto 0);
      ci: in std_logic;
      s: out std_logic_vector(n-1 downto 0);
      co: out std_logic
   );
  end component;

  component mux8_nBit is
  generic (bit_width : integer := bit_width);
  port (
    i_1, i_2, i_3, i_4,
    i_5, i_6, i_7, i_8 : in std_logic_vector(bit_width-1 downto 0);
    sel : in std_logic_vector(2 downto 0);
    o : out std_logic_vector(bit_width-1 downto 0)
  );

  end component;

  signal int_and, int_or, int_addSub: std_logic_vector(bit_width-1 downto 0); 
  signal int_isSub : std_logic;
  signal zero : std_logic_vector(bit_width-1 downto 0) := (others => '0'); 
begin

  
  -- could be more elegant
  -- sub if aluOp == 110
  int_isSub <=  i_operation(2) and 
                i_operation(1) and 
                not i_operation(0);

  int_and <= i_a and i_b; 
  int_or <= i_a or i_b; 

  addSub: addSub_nBit 
    generic map ( n => bit_width )
    port map (
      x => i_a,
      y => i_b,
      ci => int_isSub, 
      s => int_addSub,
      co => o_aluCarryOut
   );
	
  muxOut: mux8_nBit
  -- 000 and
  -- 001 or
  -- 010 add
  -- 110 sub
    generic map (bit_width =>  bit_width)
    port map (
      sel => i_operation,
      i_1 => int_and, --000
      i_2 => int_or, --001
      i_3 => int_addSub, --010
      i_4 => zero, --011
      i_5 => zero, --100
      i_6 => zero, --101
      i_7 =>  int_addSub, --110
      i_8 => zero, --111
		o => o
    );
	 
	o_aluZero <=not (int_addSub(31) and int_addSub(30) and int_addSub(29) and int_addSub(28) and int_addSub(27) and int_addSub(26) and int_addSub(25) and int_addSub(24) and
						int_addSub(23) and int_addSub(22) and int_addSub(21) and int_addSub(20) and int_addSub(19) and int_addSub(18) and int_addSub(17) and int_addSub(16) and
						int_addSub(15) and int_addSub(14) and int_addSub(13) and int_addSub(12) and int_addSub(11) and int_addSub(10) and int_addSub(9) and int_addSub(8) and
						int_addSub(7) and int_addSub(6) and int_addSub(5) and int_addSub(4) and int_addSub(3) and int_addSub(2) and int_addSub(1) and int_addSub(0)
						);
end rtl;