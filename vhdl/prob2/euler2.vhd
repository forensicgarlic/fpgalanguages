library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler2 is
  
  generic (
    max_count : integer := 3999999); 

  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(31 downto 0);
    results_valid : out std_logic);

end euler2;

architecture behavioral of euler2 is

  signal even              : std_logic;
  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;
  signal fib_r1            : unsigned(31 downto 0);
  signal fib_r2            : unsigned (31 downto 0);
  signal sum               : unsigned (31 downto 0);
  
begin  -- behavioral

  -- fibonacci registers and accumulator for fibonacci evens
  fib_reg : process (clk, reset) is
  begin  -- process R1
    if reset = '1' then                 
      fib_r1      <= x"00000001";
      fib_r2      <= (others => '0');
      results_int <= (others => '0');
    elsif rising_edge(clk) then         
        if enable = '1' then
          fib_r1 <= sum;
          fib_r2 <= fib_r1;
          if even = '1' and results_valid_int = '0' then
            results_int <= results_int + sum;
          end if;
        end if;
      end if;
  end process fib_reg;
  sum <= fib_r1 + fib_r2;

  even              <= '1' when sum(0) = '0' else '0';
  results_valid_int <= '1' when sum >= max_count else '0';
  results_valid <= results_valid_int;
  results <= results_int; 

end behavioral;

