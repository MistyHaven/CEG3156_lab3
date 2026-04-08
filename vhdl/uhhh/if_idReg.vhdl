library ieee;
use ieee.std_logic_1164.all;

entity if_idReg is
	generic (bit_width : integer := 32);
	port(
		clk: in std_logic;
		reset: in std_logic;
		instr : in std_logic_vector(bit_width-1 downto 0);
		if_id_write: in std_logic;
		if_id_flush: in std_logic;
		instr_out : out std_logic_vector(bit_width-1 downto 0) 
	);
end if_idReg;

architecture rtl of if_idReg is
	signal zeros: std_logic_vector(bit_width-1 downto 0);
	signal cur_val: std_logic_vector(bit_width-1 downto 0);
	signal next_val: std_logic_vector(bit_width-1 downto 0);
	
	component mux4_nBit is
	generic (bit_width : integer := bit_width);
		port(
			i_1, i_2, i_3, i_4 : in std_logic_vector(bit_width-1 downto 0);
			sel : in std_logic_vector(1 downto 0);
			o : out std_logic_vector(bit_width-1 downto 0)
		);
	end component;

begin 
	mux1 : mux4_nBit
			port map(
				i_1 => cur_val, -- write is off, flush is off. Feedback 
				i_2 => instr, -- write is on, flush is off
				i_3 => zeros, -- write is off, flush is on
				i_4 => zeros,-- write is on, flush is on
				sel => if_id_flush & if_id_write,
				o => next_val
			);
	 
			zeros <= (others => '0');


	process(clk,reset)
	begin 
		if reset='1' then
			cur_val <= zeros;
		elsif rising_edge(clk) then 
			cur_val <= next_val; -- takes output and feeds back to mux.
		end if;
	end process;
	instr_out  <= cur_val;
end rtl;
