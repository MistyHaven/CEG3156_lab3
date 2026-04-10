library ieee;
use ieee.std_logic_1164.all;

entity ID_block is
  port (
    clock : in std_logic;
    i_IfInstruction : in std_logic_vector(32-1 downto 0);
    i_ExEffectiveAddress : in std_logic_vector(32-1 downto 0);
    i_CtrlWb_RegWrite : in std_logic;
    i_WbRegWriteAddr : in std_logic_vector(4 downto 0);
    i_WbRegWriteData : in std_logic_vector(31 downto 0);

    o_regReadData1, o_regReadData2 : out std_logic_vector(32-1 downto 0);

    o_InstrRt, o_InstrRd : out std_logic_vector(5 downto 0);
    o_InstrAddrExtended : out std_logic_vector(32-1 downto 0);
    
    -- EX stage control signals
    o_CtrlEx_RegDst, o_CtrlEx_AluSrc  : out std_logic;
    o_CtrlEx_AluOp : out std_logic_vector(1 downto 0);
    -- MEM stage control signals
    o_CtrlMem_BranchSel, o_CtrlMem_MemRead, o_CtrlMem_MemWrite : out std_logic;
    -- WB stage control signals
    o_CtrlWb_RegWrite, o_CtrlWb_MemToReg: out std_logic
  );
end ID_block;

architecture rtl of ID_block is
  component addSub_nBit is
    generic ( n : integer := 32);
    port (
      x , y: in std_logic_vector(n-1 downto 0);
      ci: in std_logic;
      s: out std_logic_vector(n-1 downto 0);
      co: out std_logic
   );
  end component;

  component signExtend is
    port (
      i_16 : in std_logic_vector(15 downto 0);
      o_32 : out std_logic_vector(31 downto 0)
    );
  end component;

  component registerFile is
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;

      regWrite : in std_logic;

      writeAddr : in std_logic_vector(5-1 downto 0);
      writeData : in std_logic_vector(bit_width-1 downto 0);
      readAddr1 : in std_logic_vector(5-1 downto 0);
      readAddr2 : in std_logic_vector(5-1 downto 0);
      readReg1 : out std_logic_vector(bit_width-1 downto 0);
      readReg2 : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;

  component controlUnitLab3 is
  port(
    branch,
    memRead, memToReg, memWrite,
    regDst, regWrite,
    aluSrc : out std_logic;

    i_op : std_logic_vector(5 downto 0);
    aluOP : out std_logic_vector(1 downto 0)
  );
  end component;

  signal zero : std_logic;
  signal int_InstructionRs, int_InstructionRt, int_InstructionRd : std_logic_vector(4 downto 0);
  signal int_InstructionAddr : std_logic_vector(15 downto 0);
  signal int_InstructionAddrShifted : std_logic_vector(31 downto 0);
  signal int_opcode : std_logic_vector(5 downto 0);

begin

  zero <= '0';
  
  int_opcode <= i_IfInstruction(31 downto 26);
  int_InstructionRs <= i_IfInstruction(25 downto 21);
  int_InstructionRt <= i_IfInstruction(20 downto 16);
  int_InstructionRd <= i_IfInstruction(15 downto 11);
  int_InstructionAddr <= i_IfInstruction(15 downto 0);

  o_InstrRt <= int_InstructionRt;
  o_InstrRd <= int_InstructionRd;

  regFile: registerFile
    generic map ( bit_width => 32 )
    port map (
        clock => clock,
        reset => zero,
        regWrite => i_CtrlWb_RegWrite,
        writeAddr => i_WbRegWriteAddr,
        writeData => i_WbRegWriteData,
        readAddr1 => int_InstructionRs,
        readAddr2 => int_InstructionRt,
        readReg1 => o_regReadData1,
        readReg2 =>  o_regReadData2
  );

  ext: signExtend
    port map (
      i_16 => int_InstructionAddr,
      o_32 => o_InstrAddrExtended
  );
  
  -- int_opcode <= 
  ctrl: controlUnitLab3
    port map (
      regDst => o_CtrlEx_RegDst,
      aluOP => o_CtrlEx_AluOp,
      aluSrc => o_CtrlEx_AluSrc,

      branch => o_CtrlMem_BranchSel,
      memRead => o_CtrlMem_MemRead,
      memWrite => o_CtrlMem_MemWrite,
      memToReg => o_CtrlWb_MemToReg,
      regWrite => o_CtrlWb_RegWrite,
      i_op => int_opcode
  );
end rtl;
