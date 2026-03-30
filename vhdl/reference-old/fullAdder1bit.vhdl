-- ==== FULL ADDER
-- implemented with gates

library ieee;
use ieee.std_logic_1164.all;
entity fullAdder_1bit is
  port (a, b, ci : in std_logic;
  s, co : out std_logic);
end fullAdder_1bit;

architecture rtl of fullAdder_1bit is
begin
  s <= a xor b xor ci;
  co <= (a and b) or (b and ci) or (a and ci);
end rtl;


-- ==== 1-BIT FULL ADDER TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
entity FA_1bit_TB is 
  end FA_1bit_TB;

architecture testbench of FA_1bit_TB is 
  signal clock_tb : std_logic := '0';
  signal a_tb, b_tb, ci_tb: std_logic := '0';
  signal s_tb, co_tb : std_logic := '0';

  signal sim_end : BOOLEAN := false;
  constant CLOCK_PERIOD : time := 20 ns;

  component fullAdder_1bit is
    port (
        a, b, ci : in std_logic;
        s, co : out std_logic
  );
  end component;

begin
  dut: fullAdder_1bit
  port map (
     a => a_tb,
     b => b_tb,
     ci => ci_tb,
     s => s_tb,
     co => co_tb
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

  a_tb <= '1'; b_tb <= '0'; ci_tb <= '0';
  wait for clock_period;
  assert s_tb = '1' and co_tb = '0' report "A=1, B=0, C=0 test failed";
  
  a_tb <= '0'; b_tb <= '1'; ci_tb <= '0';
  wait for clock_period;
  assert s_tb = '1' and co_tb = '0' report "A=0, B=1, C=0 test failed";

  a_tb <= '1'; b_tb <= '1'; ci_tb <= '0';
  wait for clock_period;
  assert s_tb = '0' and co_tb = '1' report "A=1, B=0, C=0 test failed";
  
  a_tb <= '1'; b_tb <= '0'; ci_tb <= '1';
  wait for clock_period;
  assert s_tb = '0' and co_tb = '1' report "A=1, B=0, C=1 test failed";

  a_tb <= '0'; b_tb <= '1'; ci_tb <= '1';
  wait for clock_period;
  assert s_tb = '0' and co_tb = '1' report "A=0, B=1, C=1 test failed";

  a_tb <= '1'; b_tb <= '1'; ci_tb <= '1';
  wait for clock_period;
  assert s_tb = '1' and co_tb = '1' report "A=1, B=1, C=1 test failed";

  sim_end <= true;

end process stimulus;
end testbench;