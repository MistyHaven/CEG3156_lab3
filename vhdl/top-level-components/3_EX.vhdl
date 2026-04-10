library ieee;
use ieee.std_logic_1164.all;
entity EX_block is
port (
  clock : in std_logic;

  i_ExEffectiveAddress : in std_logic_vector(32-1 downto 0);
  i_RegReadData1, i_RegReadData2 : in std_logic_vector(32-1 downto 0);
  i_InstrRt, i_InstrRd : in std_logic_vector(5 downto 0);
  i_InstrAddrExtended : in std_logic_vector(32-1 downto 0); 

  i_CtrlEx_RegDst, i_CtrlEx_AluSrc  : in std_logic;
  i_CtrlEx_AluOp : in std_logic_vector(1 downto 0);
  i_CtrlMem_BranchSel, i_CtrlMem_MemRead, i_CtrlMem_MemWrite : in std_logic;
  i_CtrlWb_RegWrite, i_CtrlWb_MemToReg: in std_logic;
  
  i_forwardASig, i_forwardBSig : in std_logic_vector(1 downto 0); 
  i_MemForwardData : in std_logic_vector(31 downto 0);
  i_WbForwardData : in std_logic_vector(31 downto 0);

  o_MemPcInAddress : out std_logic_vector(32-1 downto 0);
  o_AluOut : out std_logic_vector(32-1 downto 0);
  o_AluZero : out std_logic;
  o_WbRegWriteAddr : out std_logic_vector(5 downto 0)
);
end EX_block;

architecture structural of EX_block is
component alu is
generic (bit_width : integer := 32);
port (
  i_a, i_b : in std_logic_vector(bit_width-1 downto 0);
  i_operation : in std_logic_vector(2 downto 0);
  o_aluZero, o_aluCarryOut : out std_logic;
  o : out std_logic_vector(bit_width-1 downto 0)
);
end component;

component aluControl is
port(
  i_func : in std_logic_vector(5 downto 0);
  i_aluOP : in std_logic_vector(1 downto 0);
  o_operation : out std_logic_vector(2 downto 0)
);
end component;

component addSub_nBit is
  generic ( n : integer := 4 );
  port (
    x , y: in std_logic_vector(n-1 downto 0);
    ci: in std_logic;
    s: out std_logic_vector(n-1 downto 0);
    co: out std_logic
 );
end component;

component shl2 is
generic (bit_width : integer := 32);
port (
  i : in std_logic_vector(bit_width-3 downto 0);
  o_shifted : out std_logic_vector(bit_width-1 downto 0)
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

component mux4_nBit is
generic (bit_width : integer := 8);
port (
  i_1, i_2, i_3, i_4 : in std_logic_vector(bit_width-1 downto 0);
  sel : in std_logic_vector(1 downto 0);
  o : out std_logic_vector(bit_width-1 downto 0)
);
end component;

signal int_AluA, int_AluB : std_logic_vector(31 downto 0);
signal int_AluFunc : std_logic_vector(5 downto 0);
signal int_AluCtrl : std_logic_vector(1 downto 0);
signal int_AddrShifted : std_logic_vector(31 downto 0);
signal zero : std_logic;

begin 

zero <= '0';
int_AluFunc <= i_InstrAddrExtended(5 downto 0);

aluA: mux4_nBit
   generic map( bit_width => 32)
   port map(
    i_1 => i_RegReadData1,
    i_2 => i_WbForwardData,
    i_3 => i_MemForwardData,
    i_4 => i_InstrAddrExtended,
    sel => i_forwardASig,
    o => int_AluA
);

aluB: mux4_nBit
   generic map( bit_width => 32)
   port map(
    i_1 => i_RegReadData1,
    i_2 => i_WbForwardData,
    i_3 => i_MemForwardData,
    i_4 => i_InstrAddrExtended,
    sel => i_forwardBSig,
    o => int_AluB
);

aluControl_inst: aluControl
  port map(
    i_func => int_AluFunc,
    i_aluOP => i_CtrlEx_AluOp,
    o_operation => int_AluCtrl
);

alu_inst: alu
  generic map (bit_width => 32)
  port map (
    i_a => i_RegReadData1,
    i_b => int_AluB,
    i_operation => int_AluCtrl,
    o_aluZero => o_AluZero,
    o => o_AluOut
);

correctOffset: shl2
  generic map (bit_width => 32)
  port map(
    i => i_InstrAddrExtended,
    o_shifted => int_AddrShifted
);

jumpCalc: addSub_nBit
  generic map (n => 32)
  port map (
    x => i_ExEffectiveAddress,
    y => int_AddrShifted,
    ci => zero,
    s => o_MemPcInAddress
);

chooseWriteAddr: mux2_nBit
  generic map ( bit_width => 6 )
  port map(
    i_1 => i_InstrRt,
    i_2 => i_InstrRd,
    sel => i_CtrlEx_RegDst,
    o => o_WbRegWriteAddr
);
end architecture;
