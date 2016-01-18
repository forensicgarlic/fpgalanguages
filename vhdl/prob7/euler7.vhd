library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler7 is
  
  generic (
    max_count : integer := 10001); 

  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(31 downto 0);
    results_valid : out std_logic);

end euler7;

architecture behavioral of euler7 is

  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic := '0';

  type numbers is array(0 to max_count) of integer range 0 to 200000;

  signal prime_ram               : numbers := (1, 2, 3, 5, 7, 11, others => 2);
  signal ram_address             : integer range 0 to max_count;
  signal next_prime_address      : integer range 0 to max_count;
  signal last_used_prime_address : integer range 0 to max_count;
  signal data_out                : integer range 0 to 200000;
  signal data_in                 : integer range 0 to 200000;

  signal num         : integer range 0 to 200000;
  signal mod_results : integer range 0 to 200000;

  signal num_inc : std_logic;
  signal ram_wr  : std_logic;

begin  -- behavioral


  -----------------------------------------------------------------------------
  -- Block ram
  -----------------------------------------------------------------------------
  -- purpose: prime number ram
  -- type   : sequential
  -- inputs : clk, reset
  -- outputs: prime_ram
  ram : process (clk, reset) is
  begin  -- process ram
    if rising_edge(clk) then            -- rising clock edge
      if ram_wr = '1' then
        prime_ram(ram_address) <= data_in;
      end if;
    end if;
  end process ram;
  data_out <= prime_ram(ram_address);


  -- counter, increment to check numbers for prime status. 
  primes : process (clk, reset) is
  begin  -- process primes
    if reset = '1' then                 -- asynchronous reset (active high)
      num <= 13;                        -- start at largest given prime
    elsif rising_edge(clk) then         -- rising clock edge
      if num_inc = '1' and results_valid_int = '0' then
        num <= num + 2;                 -- count by 2, all evens aren't prime
      end if;
    end if;
  end process primes;

  -- counter, increments and determines primes
  prime_check : process (clk, reset) is
  begin  -- process prime_check
    if reset = '1' then                 -- asynchronous reset (active high)
      next_prime_address      <= 1;  -- address (0) contents of 1 is a useless number to mod against.
      last_used_prime_address <= 5;
      num_inc                 <= '0';
      ram_wr                  <= '0';
      ram_address             <= 1;
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' and results_valid_int = '0' then
        
        if mod_results /= 0 then
          -- still prime candidate
          --if next_prime_address = last_used_prime_address then
          if data_out > num/2 then
            -- all numbers have been checked, number is prime. (don't have to
            -- check against all numbers, only up to dataout>num/2. 
            -- store in ram
            data_in                 <= num;
            ram_wr                  <= '1';
            ram_address             <= last_used_prime_address+1;
            -- increment prime count and end of ram pointer
            last_used_prime_address <= last_used_prime_address+1;
            -- reset next_prime_address
            next_prime_address      <= 1;
            -- check next number. 
            num_inc                 <= '1';
          else
            ram_wr             <= '0';
            -- need to check rest of ram against number.
            num_inc            <= '0';
            next_prime_address <= next_prime_address + 1;
            ram_address        <= next_prime_address;
          end if;
        else
          -- not prime
          ram_wr             <= '0';
          num_inc            <= '1';    -- check next number
          next_prime_address <= 1;      -- reset next prime address
          ram_address        <= 1;      --next_prime_address;
        end if;
      end if;
    end if;
  end process prime_check;

  mod_results <= num mod data_out when data_out /= 0;

  results_valid_int <= '1' when last_used_prime_address = max_count else '0';
  results_valid <= results_valid_int; 
  results       <= to_unsigned(data_in, 32);
  
end architecture behavioral;
