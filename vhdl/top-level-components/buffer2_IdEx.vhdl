library ieee;
use ieee.std_logic_1164.all;

entity buffer_IdEx is 
  port (
    clk: in std_logic;
    flush: in std_logic;

    i_IdEffectiveAddress : in std_logic_vector(32-1 downto 0); --32 

    i_regReadData1, i_regReadData2 : in std_logic_vector(32-1 downto 0); -- 64

    i_InstrRt, i_InstrRd : in std_logic_vector(5 downto 0); -- 12
    i_InstrAddrExtended : in std_logic_vector(32-1 downto 0); -- 32

    i_CtrlEx_RegDst, i_CtrlEx_AluSrc  : in std_logic; -- 2
    i_CtrlEx_AluOp : in std_logic_vector(1 downto 0); -- 2
    i_CtrlMem_BranchSel, i_CtrlMem_MemRead, i_CtrlMem_MemWrite : in std_logic; -- 3
    i_CtrlWb_RegWrite, i_CtrlWb_MemToReg: in std_logic; --2

    o_ExEffectiveAddress : out std_logic_vector(32-1 downto 0);
    o_regReadData1, o_regReadData2 : out std_logic_vector(32-1 downto 0);
    o_InstrRt, o_InstrRd : out std_logic_vector(5 downto 0);
    o_InstrAddrExtended : out std_logic_vector(32-1 downto 0); 

    o_CtrlEx_RegDst, o_CtrlEx_AluSrc  : out std_logic;
    o_CtrlEx_AluOp : out std_logic_vector(1 downto 0);
    o_CtrlMem_BranchSel, o_CtrlMem_MemRead, o_CtrlMem_MemWrite : out std_logic;
    o_CtrlWb_RegWrite, o_CtrlWb_MemToReg: out std_logic
  );
end buffer_IdEx;

architecture rtl of buffer_IdEx is
  component regPIPO_nBit is
    generic ( bit_width : integer := 149 );
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
  buffer_in(31 downto 0) <= i_IdEffectiveAddress;
  buffer_in(63 downto 32) <= i_regReadData1;
  buffer_in(95 downto 64) <= i_regReadData2;
  buffer_in(101 downto 96) <= i_InstrRt;
  buffer_in(107 downto 102) <= i_InstrRd;
  buffer_in(139 downto 108) <= i_InstrAddrExtended;
  buffer_in(140) <= i_CtrlEx_RegDst;
  buffer_in(141) <= i_CtrlEx_AluSrc ;
  buffer_in(143 downto 142) <= i_CtrlEx_AluOp;
  buffer_in(144) <= i_CtrlMem_BranchSel;
  buffer_in(145) <= i_CtrlMem_MemRead;
  buffer_in(146) <= i_CtrlMem_MemWrite;
  buffer_in(147) <= i_CtrlWb_RegWrite;
  buffer_in(148) <= i_CtrlWb_MemToReg;


  buffer_out(31 downto 0) <= o_ExEffectiveAddress;
  buffer_out(63 downto 32) <= o_regReadData1;
  buffer_out(95 downto 64) <= o_regReadData2;
  buffer_out(101 downto 96) <= o_InstrRt;
  buffer_out(107 downto 102) <= o_InstrRd;
  buffer_out(139 downto 108) <= o_InstrAddrExtended;
  buffer_out(140) <= o_CtrlEx_RegDst;
  buffer_out(141) <= o_CtrlEx_AluSrc ;
  buffer_out(143 downto 142) <= o_CtrlEx_AluOp;
  buffer_out(144) <= o_CtrlMem_BranchSel;
  buffer_out(145) <= o_CtrlMem_MemRead;
  buffer_out(146) <= o_CtrlMem_MemWrite;
  buffer_out(147) <= o_CtrlWb_RegWrite;
  buffer_out(148) <= o_CtrlWb_MemToReg;

  buf: regPIPO_nBit
  generic map( bit_width => 32) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => clk,
    reset => flush,
    load => clk,
    d => buffer_in,
    o => buffer_out
  );
end architecture;

