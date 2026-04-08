library ieee;
use ieee.std_logic_1164.all;

entity ID_block is
  port (
    clock : in std_logic;
    i_IfInstruction : in std_logic_vector(32-1 downto 0);
    i_IfEffectiveAddress : in std_logic_vector(32-1 downto 0);
    i_regWriteSig : in std_logic;

    i_WbRegWriteAddr : in std_logic_vector(4 downto 0);
    i_WbRegWriteData : in std_logic_vector(31 downto 0);

    i_regReadData1, i_regReadData2 : out std_logic_vector(32-1 downto 0);
    o_IfInstruction : out std_logic_vector(32-1 downto 0)
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

  component shl2 is
    generic (bit_width : integer := 32);
    port (
      i : in std_logic_vector ( bit_width-3 downto 0);
      o_shifted : out std_logic_vector ( bit_width-1 downto 0)
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
  signal zero : std_logic;
  signal int_InstructionRs, int_InstructionRt, int_InstructionRd : std_logic_vector(4 downto 0);
  signal int_InstructionAddr : std_logic_vector(15 downto 0);
  signal int_InstructionAddrShifted : std_logic_vector(31 downto 0);

  signal int_regReadData1, int_regReadData2 : std_logic_vector(31 downto 0);
begin

zero <= '0';

regFile: registerFile
  generic map ( bit_width => 32 )
  port map (
      clock => clock,
      reset => zero,
      regWrite => i_regWriteSig,
      writeAddr => i_WbRegWriteAddr,
      writeData => i_WbRegWriteData,
      readAddr1 => int_InstructionRs,
      readAddr2 => int_InstructionRt,
      readReg1 => int_regReadData1,
      readReg2 =>  int_regReadData2
  );
  
  

end rtl;
