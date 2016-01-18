library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler1 is
  
  generic (
    max_count : integer := 999); 

  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(31 downto 0);
    results_valid : out std_logic);

end euler1;

architecture behavioral_process of euler1 is

  signal mod3              : integer range 1 to 3;
  signal mod5              : integer range 1 to 5;
  signal number            : integer range 1 to max_count;
  signal accumulate3       : std_logic;
  signal accumulate5       : std_logic;
  signal accumulate_en     : std_logic;
  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;
  
  
begin  -- behavioral

  -- purpose: count to 3, provide enables to the accumulator
  -- type   : sequential
  -- inputs : clk, reset, enable
  -- outputs: mod3
  modulus3 : process (clk, reset)
  begin  -- process mod3
    if reset = '1' then                 -- asynchronous reset (active high)
      mod3 <= 1;
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        if mod3 = 3 then
          mod3 <= 1;
        else
          mod3 <= mod3 + 1;
        end if;  -- mod3 if
      end if;  -- enable
    end if;  -- clk
  end process modulus3;

  accumulate3 <= '1' when mod3 = 3 else '0';


-- purpose: count to 5, provide enables to the accumulator
  -- type   : sequential
  -- inputs : clk, reset, enable
  -- outputs: mod3
  modulus5 : process (clk, reset)
  begin  -- process mod3
    if reset = '1' then                 -- asynchronous reset (active high)
      mod5 <= 1;
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        if mod5 = 5 then
          mod5 <= 1;
        else
          mod5 <= mod5 + 1;
        end if;  -- mod5 if
      end if;  -- enable
    end if;  -- clk
  end process modulus5;

  accumulate5 <= '1' when mod5 = 5 else '0';

  accumulate_en <= accumulate5 or accumulate3;

  -- purpose: count from 1 to max_count
  -- type   : sequential
  -- inputs : clk, reset, enable
  -- outputs: number
  number_generator : process (clk, reset)
  begin  -- process number_generator
    if reset = '1' then                 -- asynchronous reset (active high)
      number            <= 1;
      results_valid_int <= '0';
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        if number /= max_count then
          number <= number + 1;
        else
          results_valid_int <= '1';
        end if;
      else
        results_valid_int <= '0';
      end if;
    end if;
  end process number_generator;


  -- purpose: accumulate the numbers divisible by 3 and 5
  -- type   : sequential
  -- inputs : clk, reset, number, accumulate_en
  -- outputs: results
  accumulator : process (clk, reset) is
  begin  -- process accumulator
    if reset = '1' then                 -- asynchronous reset (active high)
      results_int <= (others => '0');
    elsif rising_edge(clk) then         -- rising clock edge
      if accumulate_en = '1' and results_valid_int = '0' then
        results_int <= results_int + number;
      end if;
    end if;
  end process accumulator;
  results <= results_int;
  results_valid <= results_valid_int; 
  
end behavioral_process;

architecture behavioral_compact of euler1 is

  signal mod3              : integer range 1 to 3;
  signal mod5              : integer range 1 to 5;
  signal number            : integer range 1 to max_count;
  signal accumulate3       : std_logic;
  signal accumulate5       : std_logic;
  signal accumulate_en     : std_logic;
  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;
  
begin  -- architecture behavioral_compact

  -- purpose: accumulate 3's and 5's
  -- type   : sequential
  -- inputs : clk, reset, enable
  -- outputs: results
  sequential : process (clk, reset) is
  begin  -- process sequential steps
    if reset = '1' then                 -- asynchronous reset (active high)
      mod5              <= 1;
      mod3              <= 1;
      results_int       <= (others => '0');
      number            <= 1;
      results_valid_int <= '0';
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        if number /= max_count then
          number <= number + 1;
        else
          results_valid_int <= '1';
        end if;
        if mod5 = 5 then
          mod5 <= 1;
        else
          mod5 <= mod5 + 1;
        end if;
        if mod3 = 3 then
          mod3 <= 1;
        else
          mod3 <= mod3 + 1;
        end if;
        if accumulate_en = '1' and results_valid_int = '0' then
          results_int <= results_int + number;
        end if;
      else
        results_valid_int <= '0';
      end if;
    end if;
  end process sequential;

  results       <= results_int;
  results_valid <= results_valid_int;
  accumulate5   <= '1' when mod5 = 5 else '0';
  accumulate_en <= accumulate5 or accumulate3;
  accumulate3   <= '1' when mod3 = 3 else '0';


end architecture behavioral_compact;
