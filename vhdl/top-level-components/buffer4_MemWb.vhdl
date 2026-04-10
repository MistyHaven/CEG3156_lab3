library ieee;
use ieee.std_logic_1164.all;

entity buffer_MemWb is 
  port (
    i_clk: in std_logic;
    i_flush: in std_logic;
  
    i_RegReadData1 : in std_logic_vector(32-1 downto 0);
    i_MemAddress : in std_logic_vector(32-1 downto 0);
    i_CtrlWb_RegWrite, i_CtrlWb_MemToReg: in std_logic; --2

    o_RegReadData1 : out std_logic_vector(32-1 downto 0);
    o_MemAddress : out std_logic_vector(32-1 downto 0);
    o_CtrlWb_RegWrite, o_CtrlWb_MemToReg: out std_logic
  );
end buffer_MemWb; 

architecture rtl of buffer_MemWb is
  component regPIPO_nBit is
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;
      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;
  signal buffer_in : std_logic_vector(66-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
  signal buffer_out : std_logic_vector(66-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
begin
  buf: regPIPO_nBit
  generic map( bit_width => 66) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => i_clk,
    reset => i_flush,
    load => i_clk,
    d => buffer_in,
    o => buffer_out
  );
  
buffer_in(31 downto 0) <= i_RegReadData1;
buffer_in(63 downto 32) <= i_MemAddress;
buffer_in(64) <= i_CtrlWb_RegWrite;
buffer_in(65) <= i_CtrlWb_MemToReg;

o_RegReadData1 <= buffer_out(31 downto 0); 
o_MemAddress <= buffer_out(63 downto 32); 
o_CtrlWb_RegWrite <= buffer_out(64); 
o_CtrlWb_MemToReg <= buffer_out(65);

end architecture;

