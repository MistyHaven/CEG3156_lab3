library ieee;
use ieee.std_logic_1164.all;

entity buffer_IdEx is 
  port (
    i_clk: in std_logic;
    i_flush: in std_logic;

    i_regReadData1, i_regReadData2 : in std_logic_vector(32-1 downto 0); -- 64
    i_InstrRt, i_InstrRd : in std_logic_vector(5-1 downto 0); -- 10
    i_InstrAddrExtended : in std_logic_vector(32-1 downto 0); -- 32

    i_CtrlEx_RegDst, i_CtrlEx_AluSrc  : in std_logic; -- 2
    i_CtrlEx_AluOp : in std_logic_vector(1 downto 0); -- 2
    i_CtrlMem_BranchSel, i_CtrlMem_MemRead, i_CtrlMem_MemWrite : in std_logic; -- 3
    i_CtrlWb_RegWrite, i_CtrlWb_MemToReg: in std_logic; --2

    o_regReadData1, o_regReadData2 : out std_logic_vector(32-1 downto 0);
    o_InstrRt, o_InstrRd : out std_logic_vector(5-1 downto 0);
    o_InstrAddrExtended : out std_logic_vector(32-1 downto 0); 

    o_CtrlEx_RegDst, o_CtrlEx_AluSrc  : out std_logic;
    o_CtrlEx_AluOp : out std_logic_vector(1 downto 0);
    o_CtrlMem_BranchSel, o_CtrlMem_MemRead, o_CtrlMem_MemWrite : out std_logic;
    o_CtrlWb_RegWrite, o_CtrlWb_MemToReg: out std_logic
  );
end buffer_IdEx;

architecture rtl of buffer_IdEx is
  component regPIPO_nBit is
    generic ( bit_width : integer := 117 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;
      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;
  signal buffer_in : std_logic_vector(117-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
  signal buffer_out : std_logic_vector(117-1 downto 0); -- DEFINE TOTAL BIT WIDTH HERE
begin
  buf: regPIPO_nBit
  generic map( bit_width => 117 ) -- DEFINE TOTAL BIT WIDTH THERE
  port map (
    clock => i_clk,
    reset => i_flush,
    load => i_clk,
    d => buffer_in,
    o => buffer_out
  );

  buffer_in(31 downto 0) <= i_regReadData1;
  buffer_in(63 downto 32) <= i_regReadData2;
  buffer_in(68 downto 64) <= i_InstrRt;
  buffer_in(74 downto 70) <= i_InstrRd;
  buffer_in(107 downto 76) <= i_InstrAddrExtended;
  buffer_in(108) <= i_CtrlEx_RegDst;
  buffer_in(109) <= i_CtrlEx_AluSrc ;
  buffer_in(111 downto 110) <= i_CtrlEx_AluOp;
  buffer_in(112) <= i_CtrlMem_BranchSel;
  buffer_in(113) <= i_CtrlMem_MemRead;
  buffer_in(114) <= i_CtrlMem_MemWrite;
  buffer_in(115) <= i_CtrlWb_RegWrite;
  buffer_in(116) <= i_CtrlWb_MemToReg;

  o_regReadData1 <= buffer_in(31 downto 0);
  o_regReadData2 <= buffer_in(63 downto 32);
  o_InstrRt <= buffer_in(68 downto 64);
  o_InstrRd <= buffer_in(74 downto 70);
  o_InstrAddrExtended <= buffer_in(107 downto 76);
  o_CtrlEx_RegDst <= buffer_in(108);
  o_CtrlEx_AluSrc  <= buffer_in(109);
  o_CtrlEx_AluOp <= buffer_in(111 downto 110);
  o_CtrlMem_BranchSel <= buffer_in(112);
  o_CtrlMem_MemRead <= buffer_in(113);
  o_CtrlMem_MemWrite <= buffer_in(114);
  o_CtrlWb_RegWrite <= buffer_in(115);
  o_CtrlWb_MemToReg <= buffer_in(116);
end architecture;

