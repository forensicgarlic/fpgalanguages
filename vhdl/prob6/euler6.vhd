library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler6 is
  
  generic (
    max_count : integer := 100); 

  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(31 downto 0);
    results_valid : out std_logic);

end euler6;

architecture behavioral of euler6 is

  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;

  type numbers is array(0 to max_count) of integer range 0 to max_count;
  type squared_numbers is array(0 to max_count) of integer range 0 to max_count*max_count;

  signal my_numbers         : numbers;
  signal my_numbers_squared : squared_numbers;
  signal sum_of_the_squares : integer;
  signal sum                : integer;
  signal square_of_the_sums : integer;
  signal difference         : integer;
  
begin  -- behavioral=

-- first 100 natural numbers
  initialize : for i in 0 to max_count generate
    my_numbers(i)         <= i   when enable = '1' else 0;
    my_numbers_squared(i) <= i*i when enable = '1' else 0;
  end generate initialize;

-- purpose: sum arrays
-- type   : combinational
-- inputs : my_numbers, my_numbers_squared
-- outputs: sum, sum_of_squares
  summing : process (my_numbers, my_numbers_squared) is
    variable temp_sum            : integer := 0;
    variable temp_sum_of_squares : integer := 0;
  begin  -- process summing
    for i in 1 to max_count loop
      temp_sum            := temp_sum + my_numbers(i);
      temp_sum_of_squares := temp_sum_of_squares + my_numbers_squared(i);
    end loop;  -- i
    sum                <= temp_sum;
    sum_of_the_squares <= temp_sum_of_squares;
  end process summing;

  square_of_the_sums <= sum*sum;
  difference         <= square_of_the_sums - sum_of_the_squares;

  -- purpose: register output
  -- type   : sequential
  -- inputs : clk, reset, enable,
  -- outputs : results, results_valid

  output : process (clk, reset) is
  begin  -- process output
    if reset = '1' then                 -- asynchronous reset (active high)
      results_valid <= '0';
      results       <= (others => '0');
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        results       <= to_unsigned(difference,32);
        results_valid <= '1';
      else
        results_valid <= '0';
      end if;
    end if;
  end process output;

end architecture behavioral;
