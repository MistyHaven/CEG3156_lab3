library ieee;
use ieee.std_logic_1164.all;

entity registerFile is
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
end registerFile;

architecture rtl of registerFile is
  -- deps:
  -- nBit_register, dFF_2
  component regPIPO_nBit 
    generic ( bit_width : integer := 32 );
    port (
      clock, reset : in std_logic;
      load : in std_logic;
      d : in std_logic_vector(bit_width-1 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;


  component mux32_nBit is
    generic (bit_width : integer := 8);
    port (
      i_1, i_2, i_3, i_4,
      i_5, i_6, i_7, i_8,
      i_9, i_10, i_11, i_12,
      i_13, i_14, i_15, i_16,
      i_17, i_18, i_19, i_20,
      i_21, i_22, i_23, i_24,
      i_25, i_26, i_27, i_28,
      i_29, i_30, i_31, i_32 : in std_logic_vector(bit_width-1 downto 0);
      sel : in std_logic_vector(5 downto 0);
      o : out std_logic_vector(bit_width-1 downto 0)
    );
  end component;
  
  -- doing the scuffed huge vector thing again
  signal int_bus : std_logic_vector(bit_width * 32-1 downto 0);
  
  signal int_read1, int_read2 : std_logic_vector(5 downto 0);

  alias r1 : std_logic_vector(bit_width-1 downto 0) is int_bus(31 downto 0);
  alias r2 : std_logic_vector(bit_width-1 downto 0) is int_bus(63 downto 32);
  alias r3 : std_logic_vector(bit_width-1 downto 0) is int_bus(95 downto 64);
  alias r4 : std_logic_vector(bit_width-1 downto 0) is int_bus(127 downto 96);
  alias r5 : std_logic_vector(bit_width-1 downto 0) is int_bus(159 downto 128);
  alias r6 : std_logic_vector(bit_width-1 downto 0) is int_bus(191 downto 160);
  alias r7 : std_logic_vector(bit_width-1 downto 0) is int_bus(223 downto 192);
  alias r8 : std_logic_vector(bit_width-1 downto 0) is int_bus(255 downto 224);

  alias r9 : std_logic_vector(bit_width-1 downto 0) is int_bus(287 downto 256);
  alias r10 : std_logic_vector(bit_width-1 downto 0) is int_bus(319 downto 288);
  alias r11 : std_logic_vector(bit_width-1 downto 0) is int_bus(351 downto 320);
  alias r12 : std_logic_vector(bit_width-1 downto 0) is int_bus(383 downto 352);
  alias r13 : std_logic_vector(bit_width-1 downto 0) is int_bus(415 downto 384);
  alias r14 : std_logic_vector(bit_width-1 downto 0) is int_bus(447 downto 416);
  alias r15 : std_logic_vector(bit_width-1 downto 0) is int_bus(479 downto 448);
  alias r16 : std_logic_vector(bit_width-1 downto 0) is int_bus(511 downto 480);

  alias r17 : std_logic_vector(bit_width-1 downto 0) is int_bus(543 downto 512);
  alias r18 : std_logic_vector(bit_width-1 downto 0) is int_bus(575 downto 544);
  alias r19 : std_logic_vector(bit_width-1 downto 0) is int_bus(607 downto 576);
  alias r20 : std_logic_vector(bit_width-1 downto 0) is int_bus(639 downto 608);
  alias r21 : std_logic_vector(bit_width-1 downto 0) is int_bus(671 downto 640);
  alias r22 : std_logic_vector(bit_width-1 downto 0) is int_bus(703 downto 672);
  alias r23 : std_logic_vector(bit_width-1 downto 0) is int_bus(735 downto 704);
  alias r24 : std_logic_vector(bit_width-1 downto 0) is int_bus(767 downto 736);

  alias r25 : std_logic_vector(bit_width-1 downto 0) is int_bus(799 downto 768);
  alias r26 : std_logic_vector(bit_width-1 downto 0) is int_bus(831 downto 800);
  alias r27 : std_logic_vector(bit_width-1 downto 0) is int_bus(863 downto 832);
  alias r28 : std_logic_vector(bit_width-1 downto 0) is int_bus(895 downto 864);
  alias r29 : std_logic_vector(bit_width-1 downto 0) is int_bus(927 downto 896);
  alias r30 : std_logic_vector(bit_width-1 downto 0) is int_bus(959 downto 928);
  alias r31 : std_logic_vector(bit_width-1 downto 0) is int_bus(991 downto 960);
  alias r32 : std_logic_vector(bit_width-1 downto 0) is int_bus(1023 downto 992);
begin

  registers: for i in 31 downto 0 generate
  begin
  reg_i : regPIPO_nBit
  generic map ( bit_width => bit_width )
  port map (
    clock => clock,
    reset => reset,
    load => regWrite,
    d => writeData,
    o => int_bus(bit_width * (i+1) - 1 downto bit_width * i)
  );
  end generate;
  
  int_read1 <= '0' & readAddr1;
  int_read2 <= '0' & readAddr2;

  read1: mux32_nBit
   generic map ( bit_width => bit_width )
   port map(
      i_1 => r1, i_2 => r2, i_3 => r3, i_4 => r4,
      i_5 => r5, i_6 => r6, i_7 => r7, i_8 => r8,
      i_9 => r9, i_10 => r10, i_11 => r11, i_12 => r12,
      i_13 => r13, i_14 => r14, i_15 => r15, i_16 => r16,
      i_17 => r17, i_18 => r18, i_19 => r19, i_20 => r20,
      i_21 => r21, i_22 => r22, i_23 => r23, i_24 => r24,
      i_25 => r25, i_26 => r26, i_27 => r27, i_28 => r28,
      i_29 => r29, i_30 => r30, i_31 => r31, i_32 => r32,
      sel => int_read1,
      o => readReg1
  );

  read2: mux32_nBit
   generic map ( bit_width => bit_width )
   port map(
      i_1 => r1, i_2 => r2, i_3 => r3, i_4 => r4,
      i_5 => r5, i_6 => r6, i_7 => r7, i_8 => r8,
      i_9 => r9, i_10 => r10, i_11 => r11, i_12 => r12,
      i_13 => r13, i_14 => r14, i_15 => r15, i_16 => r16,
      i_17 => r17, i_18 => r18, i_19 => r19, i_20 => r20,
      i_21 => r21, i_22 => r22, i_23 => r23, i_24 => r24,
      i_25 => r25, i_26 => r26, i_27 => r27, i_28 => r28,
      i_29 => r29, i_30 => r30, i_31 => r31, i_32 => r32,
      sel => int_read2,
      o => readReg2
  );
end rtl;