library ieee;
use ieee.std_logic_1164.all;

entity equalsChecker is
  generic ( n : integer := 4 );
  port (
    x , y: in std_logic_vector(n-1 downto 0);
    o: out std_logic
 );
 end equalsChecker;

architecture structural of equalsChecker is
  component inverter_1bit is 
    port (
      a, s: in std_logic;
      o : out std_logic
    );
	end component;
	
	component isZero is 
    port (
		i : in std_logic_vector(n-1 downto 0);
		o : out std_logic
	 );
	 end component;

  signal i_y : std_logic_vector(n-1 downto 0);
begin

  invert_y: for i in n-1 downto 0 generate
    noty : inverter_1bit
    port map ( y(i), x(i), i_y(i) );
  end generate;
  
  isEqual : isZero 
  port map(i_y, o);

end structural;
