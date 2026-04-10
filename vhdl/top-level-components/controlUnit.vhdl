library ieee;
use ieee.std_logic_1164.all;
entity controlUnitLab3 is
  port(
    jump, 
    branch, branchNEQ,
    memRead, memToReg, memWrite,
    regDst, regWrite,
    aluSrc : out std_logic;

    i_op : std_logic_vector(5 downto 0);
    aluOP : out std_logic_vector(1 downto 0)
  );
begin

end controlUnitLab3;

architecture rtl of controlUnitLab3 is
  signal rFormat, lw, sw, beq: std_logic;

  alias op0 : std_logic is i_op(0);
  alias op1 : std_logic is i_op(1);
  alias op2 : std_logic is i_op(2);
  alias op3 : std_logic is i_op(3);
  alias op4 : std_logic is i_op(4);
  alias op5 : std_logic is i_op(5);

begin
  rFormat <= 
    not op5 and not op4 and not op3 and 
    not op2 and not op1 and not op0;
  lw <= 
    op5 and not op4 and not op3 and 
    not op2 and op1 and op0;
  sw <=
    op5 and not op4 and op3 and 
    not op2 and op1 and op0;
  beq <=
    not op5 and not op4 and not op3 and 
    op2 and not op1 and not op0;
	
	 
regDst <= rFormat;
aluSrc <= lw or sw;
memToReg <= lw;
regWrite <= rFormat or lw;
memRead <= lw;
memWrite <= sw;
branch <= beq;
aluOP(1) <= rFormat;
aluOP(0) <= beq;

end rtl;
