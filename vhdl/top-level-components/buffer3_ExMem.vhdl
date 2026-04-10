library ieee;
use ieee.std_logic_1164.all;

entity buffer_ExMem is 
  port (
    i_clk: in std_logic;
    i_flush: in std_logic;

    i_MemPcInAddress : in std_logic_vector(32-1 downto 0);
    i_AluOut : in std_logic_vector(32-1 downto 0);
    i_AluZero : in std_logic;
    i_WbRegWriteAddr : in std_logic_vector(5 downto 0);

    i_CtrlMem_BranchSel, i_CtrlMem_MemRead, i_CtrlMem_MemWrite : in std_logic;
    i_CtrlWb_RegWrite, i_CtrlWb_MemToReg: in std_logic;

    o_MemPcInAddress : out std_logic_vector(32-1 downto 0);
    o_AluOut : out std_logic_vector(32-1 downto 0);
    o_AluZero : out std_logic;
    o_WbRegWriteAddr : out std_logic_vector(5 downto 0);

    o_CtrlMem_BranchSel, o_CtrlMem_MemRead, o_CtrlMem_MemWrite : out std_logic;
    o_CtrlWb_RegWrite, o_CtrlWb_MemToReg: out std_logic
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
  signal buffer_in : std_logic_vector(76-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
  signal buffer_out : std_logic_vector(76-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
begin


buffer_in(31 downto 0) <= i_MemPcInAddress;
buffer_in(63 downto 32) <= i_AluOut;
buffer_in(64) <= i_AluZero;
buffer_in(70 downto 65) <= i_WbRegWriteAddr;
buffer_in(71) <= i_CtrlMem_BranchSel;
buffer_in(72) <= i_CtrlMem_MemRead;
buffer_in(73) <= i_CtrlMem_MemWrite;
buffer_in(74) <= i_CtrlWb_RegWrite;
buffer_in(75) <= i_CtrlWb_MemToReg;

o_MemPcInAddress <= buffer_out(31 downto 0);
o_AluOut <= buffer_out(63 downto 32);
o_AluZero <= buffer_out(64);
o_WbRegWriteAddr <= buffer_out(70 downto 65);
o_CtrlMem_BranchSel <= buffer_out(71);
o_CtrlMem_MemRead <= buffer_out(72);
o_CtrlMem_MemWrite <= buffer_out(73);
o_CtrlWb_RegWrite <= buffer_out(74);
o_CtrlWb_MemToReg <= buffer_out(75);

  buf: regPIPO_nBit
  generic map( bit_width => 76) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => i_clk,
    reset => i_flush,
    load => i_clk,
    d => buffer_in,
    o => buffer_out
  );
end architecture;

