library ieee;
use ieee.std_logic_1164.all;
entity controlLab2 is
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

end controlLab2;

architecture rtl of controlLab2 is
  signal rFormat, lw, sw, beq, bne, jumpSig: std_logic;

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
  bne <= -- BNE is op 9
    not op5 and not op4 and op3 and 
    not op2 and not op1 and op0;
	
  jumpSig <=
	 not op0 and op1 and not op2 and not op3 and not op4 and not op5;
	 
	 
regDst <= rFormat;
aluSrc <= lw or sw;
memToReg <= lw;
regWrite <= rFormat or lw;
memRead <= lw;
memWrite <= sw;
branch <= beq or bne;
branchNEQ <= bne;
aluOP(1) <= rFormat;
aluOP(0) <= beq or bne;
jump <= jumpSig;

end rtl;