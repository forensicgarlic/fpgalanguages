library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler4 is
  
  generic (
    start_count : integer := 100;
    end_count   : integer := 999); 

  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(31 downto 0);
    results_valid : out std_logic);

end euler4;

architecture behavioral of euler4 is

  constant n : integer := 20;           -- number of bits in number
  constant q : integer := 6;            -- number of digits in BCD


  signal mult_a             : integer range start_count to end_count;
  signal mult_b             : integer range start_count to end_count;
  signal multiplier         : integer range start_count*start_count to end_count*end_count;
  signal multiplier_q       : integer range start_count*start_count to end_count*end_count;
  signal largest_palindrome : integer range start_count*start_count to end_count*end_count;
  signal bcd_num            : unsigned(4*q-1 downto 0);


  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;


  -- found at http://vhdlguru.blogspot.com/2010/04/8-bit-binary-to-bcd-converter-double.html?showComment=1290145483089#c4480641742434744293
  function generic_to_bcd (bin : unsigned((n-1) downto 0)) return unsigned is
    variable i    : integer                      := 0;
    variable j    : integer                      := 1;
    variable bcd  : unsigned(((4*q)-1) downto 0) := (others => '0');
    variable bint : unsigned((n-1) downto 0)     := bin;

  begin
    input_loop : for i in 0 to n-1 loop  -- repeating n times.
      bcd(((4*q)-1) downto 1) := bcd(((4*q)-2) downto 0);  --shifting the bits.
      bcd(0)                  := bint(n-1);
      bint((n-1) downto 1)    := bint((n-2) downto 0);
      bint(0)                 := '0';

      check_bcd_to_increment : for j in 1 to q loop
        if(i < n-1 and bcd(((4*j)-1) downto ((4*j)-4)) > "0100") then  --add 3 if BCD digit is greater than 4.
          bcd(((4*j)-1) downto ((4*j)-4)) := bcd(((4*j)-1) downto ((4*j)-4)) + "0011";
        end if;
      end loop check_bcd_to_increment;
    end loop input_loop;
    return bcd;
  end generic_to_bcd;

  -- purpose: determines if passed in binary coded decimal number is a palindrome
  function is_palindrome (
    bcd_num : unsigned((4*q)-1 downto 0))
    return std_logic is
    variable palindrome    : std_logic;
    variable largest_digit : integer;
  begin  -- function is_palindrome
    -- while largest number is q characters, leading zeros should be ignored.
    -- (assuming base 10, human readable palindrome standard)

    -- 1) find largest digit

    largest_digit := 0;
    for i in 1 to q loop
      if bcd_num((4*i)-1 downto (4*i)-4) /= 0 and i > largest_digit then
        largest_digit := i;
      end if;
    end loop;  -- i

    -- 2) compare N to 0, and -1 to +1 til they meet.
    palindrome := '1';
    if largest_digit > 0 then
      
      for i in 1 to largest_digit-1 loop
        if (bcd_num((4*i)-1 downto (4*i)-4) /= bcd_num((4*(largest_digit-i+1))-1 downto (4*(largest_digit-i+1))-4)) then
          palindrome := '0';
        end if;
      end loop;  -- i
    end if;

    return palindrome;
  end function is_palindrome;
  
begin  -- behavioral

  -- Mult A input 100 - 999, incremented every generic_to_bcd update cycle. On max, rollover to 100, and count B
  -- Mult B input 100 - 999, incremented on A rollover. On max, end.
  -- purpose: loop through 3 digit number
  -- type   : sequential
  -- inputs : clk, reset, enable
  -- outputs: mult_a, mult_b
  
  number_loops : process (clk, reset) is
  begin  -- process number_loops
    if reset = '1' then                 -- asynchronous reset (active high)
      mult_a             <= start_count;
      mult_b             <= start_count;
      results_valid_int  <= '0';
      largest_palindrome <= 10000;  -- smallest multiple of two 3 digit numbers. 
    elsif rising_edge(clk) then         -- rising clock edge
      if enable = '1' then
        if mult_a = end_count then
          mult_a <= start_count;
          if mult_b = end_count then
            results_valid_int <= '1';
          else
            mult_b <= mult_b + 1;
          end if;  -- mult b
        else
          mult_a <= mult_a + 1;
        end if;  -- mult a
        multiplier   <= mult_a * mult_b;
        bcd_num      <= generic_to_bcd(to_unsigned(multiplier, n));
        multiplier_q <= multiplier;
        -- compare palindrome output to last palindrome. If greater, enable register.
        if is_palindrome(bcd_num) = '1' and multiplier_q > largest_palindrome then
          largest_palindrome <= multiplier_q;
        end if;
      end if;  -- enable
    end if;
  end process number_loops;

  results_valid <= results_valid_int;
  results       <= to_unsigned(largest_palindrome, 32);

end behavioral;

architecture fast of euler4 is

  constant n : integer := 20;           -- number of bits in number
  constant q : integer := 6;            -- number of digits in BCD


  signal mult_a             : integer range start_count to end_count;
  signal mult_b             : integer range start_count to end_count;
  signal multiplier         : integer range start_count*start_count to end_count*end_count;
  signal multiplier_q       : integer range start_count*start_count to end_count*end_count;
  signal largest_palindrome : integer range start_count*start_count to end_count*end_count;
  signal bcd_num            : unsigned(4*q-1 downto 0);
  type numbers is array (0 to (end_count-start_count)*(end_count-start_count)) of integer range start_count*start_count to end_count*end_count;
  signal my_numbers : numbers;
  signal my_numbers_bcd : numbers;
  signal my_numbers_is_palindrome : std_logic_vector(0 to (end_count-start_count)*(end_count-start_count));

  signal results_int       : unsigned(31 downto 0);
  signal results_valid_int : std_logic;


  -- found at http://vhdlguru.blogspot.com/2010/04/8-bit-binary-to-bcd-converter-double.html?showComment=1290145483089#c4480641742434744293
  function generic_to_bcd (bin : unsigned((n-1) downto 0)) return unsigned is
    variable i    : integer                      := 0;
    variable j    : integer                      := 1;
    variable bcd  : unsigned(((4*q)-1) downto 0) := (others => '0');
    variable bint : unsigned((n-1) downto 0)     := bin;

  begin
    input_loop : for i in 0 to n-1 loop  -- repeating n times.
      bcd(((4*q)-1) downto 1) := bcd(((4*q)-2) downto 0);  --shifting the bits.
      bcd(0)                  := bint(n-1);
      bint((n-1) downto 1)    := bint((n-2) downto 0);
      bint(0)                 := '0';

      check_bcd_to_increment : for j in 1 to q loop
        if(i < n-1 and bcd(((4*j)-1) downto ((4*j)-4)) > "0100") then  --add 3 if BCD digit is greater than 4.
          bcd(((4*j)-1) downto ((4*j)-4)) := bcd(((4*j)-1) downto ((4*j)-4)) + "0011";
        end if;
      end loop check_bcd_to_increment;
    end loop input_loop;
    return bcd;
  end generic_to_bcd;

  -- purpose: determines if passed in binary coded decimal number is a palindrome
  function is_palindrome (
    bcd_num : unsigned((4*q)-1 downto 0))
    return std_logic is
    variable palindrome    : std_logic;
    variable largest_digit : integer;
  begin  -- function is_palindrome
    -- while largest number is q characters, leading zeros should be ignored.
    -- (assuming base 10, human readable palindrome standard)

    -- 1) find largest digit

    largest_digit := 0;
    for i in 1 to q loop
      if bcd_num((4*i)-1 downto (4*i)-4) /= 0 and i > largest_digit then
        largest_digit := i;
      end if;
    end loop;  -- i

    -- 2) compare N to 0, and -1 to +1 til they meet.
    palindrome := '1';
    if largest_digit > 0 then
      
      for i in 1 to largest_digit-1 loop
        if (bcd_num((4*i)-1 downto (4*i)-4) /= bcd_num((4*(largest_digit-i+1))-1 downto (4*(largest_digit-i+1))-4)) then
          palindrome := '0';
        end if;
      end loop;  -- i
    end if;

    return palindrome;
  end function is_palindrome;
  
begin  -- fast

  -- potential solutions
  outer_loop: for i in start_count to end_count generate
    inner_loop: for j in start_count to end_count generate
      my_numbers((i-start_count)*(j-start_count) + (j-start_count)) <= i*j when enable = '1' else 0;
    end generate inner_loop;
  end generate outer_loop;

  -- converted to bcd
  all_numbers_to_bcd: for i in 0 to (end_count-start_count)*(end_count-start_count) generate
      my_numbers_bcd <= generic_to_bcd((to_unsigned(my_numbers(i), n))) when enable = '1' else 0;
  end generate all_numbers;

  -- check palindromes
  all_numbers_is_palindrome: for i in 0 to (end_count-start_count)*(end_count-start_count) generate
    my_numbers_is_palindrome <= is_palindrome(my_numbers_bcd(i)) when enable = '1' else '0';
  end generate all_numbers_is_palindrome;

  -- compare all results
  all_numbers_compare: process (my_numbers_is_palindrome, my_numbers_bcd) is
    variable temp_result : integer := 0;
  begin  -- process all_numbers_compare
    for i in 0 to (end_count-start_count)*(end_count-start_count) loop
      if my_numbers_bcd(i) > temp_result and my_numbers_is_palindrome(i) then
        temp_result := my_numbers_bcd(i);
      end if;
    end loop;  -- i
    results <= temp_result when enable = '1' else 0; 
  end process all_numbers_compare;


end fast;
