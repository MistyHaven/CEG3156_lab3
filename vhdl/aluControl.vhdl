library ieee;
use ieee.std_logic_1164.all;
entity aluControl is
port(
  i_func : in std_logic_vector(5 downto 0);
  i_aluOP : in std_logic_vector(1 downto 0);
  
  o_operation : out std_logic_vector(2 downto 0)
);
end aluControl;

architecture rtl of aluControl is
  alias f0 : std_logic is i_func(0);
  alias f1 : std_logic is i_func(1);
  alias f2 : std_logic is i_func(2);
  alias f3 : std_logic is i_func(3);
  alias f4 : std_logic is i_func(4);
  alias f5 : std_logic is i_func(5);

  alias op0 : std_logic is i_aluOP(0);
  alias op1 : std_logic is i_aluOP(1);

begin
  o_operation(2) <= (f1 and op1) or op0;
  o_operation(1) <= (not op1) or (not f2);
  o_operation(0) <= (f3 or f0) and op1;

end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity aluControlTB is 
  end aluControlTB;

architecture testbench of aluControlTB is 
  signal clock_tb : std_logic := '0';
  signal sim_end : BOOLEAN := false;

  signal func_TB : std_logic_vector(5 downto 0);
  signal aluOP_TB : std_logic_vector(1 downto 0); 
  signal op_TB : std_logic_vector(2 downto 0);

  constant CLOCK_PERIOD : time := 20 ns;

  component aluControl is
  port(
    i_aluOP : in std_logic_vector(1 downto 0);
    i_func : in std_logic_vector(5 downto 0);
    
    o_operation : out std_logic_vector(2 downto 0)
  );
  end component;

begin
  dut: aluControl
  port map (
    i_func =>  func_TB,
    i_aluOP =>  aluOP_TB,
    o_operation => op_TB
  );

  clock_process:
  process begin
    while (not sim_end) loop
      clock_tb <= '1';
      wait for clock_period / 2;
      clock_tb <= '0';
      wait for clock_period / 2;
    end loop;
    wait;
  end process clock_process;

  stimulus: 
process begin 
  wait for clock_period;

  aluOP_TB <= "00"; func_TB <= "000000";
  wait for clock_period;
  assert op_TB = "010" report "test 1 should be 010";

  aluOP_TB <= "01"; func_TB <= "000000";
  wait for clock_period;
  assert op_TB = "110" report "test 2 should be 110";

  aluOP_TB <= "10"; func_TB <= "000000";
  wait for clock_period;
  assert op_TB = "010" report "test 3 should be 010";

  aluOP_TB <= "10"; func_TB <= "000010";
  wait for clock_period;
  assert op_TB = "110" report "test 4 should be 110";

  aluOP_TB <= "10"; func_TB <= "000100";
  wait for clock_period;
  assert op_TB = "000" report "test 5 should be 000";

  aluOP_TB <= "10"; func_TB <= "000101";
  wait for clock_period;
  assert op_TB = "001" report "test 6 should be 001";

  aluOP_TB <= "10"; func_TB <= "001010";
  wait for clock_period;
  assert op_TB = "111" report "test 7 should be 001";

  sim_end <= true;

end process stimulus;
end testbench;