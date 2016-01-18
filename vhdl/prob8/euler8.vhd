library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity euler8 is
  
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    enable        : in  std_logic;
    results       : out unsigned(19 downto 0);
    results_valid : out std_logic);

end euler8;

architecture behavioral of euler8 is

  signal results_int       : unsigned(19 downto 0);
  
  type number_string is array(0 to 999) of unsigned(3 downto 0);
  signal my_number_string : number_string := (x"7", x"3", x"1", x"6", x"7", x"1", x"7", x"6", x"5", x"3", x"1", x"3", x"3", x"0", x"6", x"2", x"4", x"9", x"1", x"9", x"2", x"2", x"5", x"1", x"1", x"9", x"6", x"7", x"4", x"4", x"2", x"6", x"5", x"7", x"4", x"7", x"4", x"2", x"3", x"5", x"5", x"3", x"4", x"9", x"1", x"9", x"4", x"9", x"3", x"4",
                                              x"9", x"6", x"9", x"8", x"3", x"5", x"2", x"0", x"3", x"1", x"2", x"7", x"7", x"4", x"5", x"0", x"6", x"3", x"2", x"6", x"2", x"3", x"9", x"5", x"7", x"8", x"3", x"1", x"8", x"0", x"1", x"6", x"9", x"8", x"4", x"8", x"0", x"1", x"8", x"6", x"9", x"4", x"7", x"8", x"8", x"5", x"1", x"8", x"4", x"3",
                                              x"8", x"5", x"8", x"6", x"1", x"5", x"6", x"0", x"7", x"8", x"9", x"1", x"1", x"2", x"9", x"4", x"9", x"4", x"9", x"5", x"4", x"5", x"9", x"5", x"0", x"1", x"7", x"3", x"7", x"9", x"5", x"8", x"3", x"3", x"1", x"9", x"5", x"2", x"8", x"5", x"3", x"2", x"0", x"8", x"8", x"0", x"5", x"5", x"1", x"1",
                                              x"1", x"2", x"5", x"4", x"0", x"6", x"9", x"8", x"7", x"4", x"7", x"1", x"5", x"8", x"5", x"2", x"3", x"8", x"6", x"3", x"0", x"5", x"0", x"7", x"1", x"5", x"6", x"9", x"3", x"2", x"9", x"0", x"9", x"6", x"3", x"2", x"9", x"5", x"2", x"2", x"7", x"4", x"4", x"3", x"0", x"4", x"3", x"5", x"5", x"7",
                                              x"6", x"6", x"8", x"9", x"6", x"6", x"4", x"8", x"9", x"5", x"0", x"4", x"4", x"5", x"2", x"4", x"4", x"5", x"2", x"3", x"1", x"6", x"1", x"7", x"3", x"1", x"8", x"5", x"6", x"4", x"0", x"3", x"0", x"9", x"8", x"7", x"1", x"1", x"1", x"2", x"1", x"7", x"2", x"2", x"3", x"8", x"3", x"1", x"1", x"3",
                                              x"6", x"2", x"2", x"2", x"9", x"8", x"9", x"3", x"4", x"2", x"3", x"3", x"8", x"0", x"3", x"0", x"8", x"1", x"3", x"5", x"3", x"3", x"6", x"2", x"7", x"6", x"6", x"1", x"4", x"2", x"8", x"2", x"8", x"0", x"6", x"4", x"4", x"4", x"4", x"8", x"6", x"6", x"4", x"5", x"2", x"3", x"8", x"7", x"4", x"9",
                                              x"3", x"0", x"3", x"5", x"8", x"9", x"0", x"7", x"2", x"9", x"6", x"2", x"9", x"0", x"4", x"9", x"1", x"5", x"6", x"0", x"4", x"4", x"0", x"7", x"7", x"2", x"3", x"9", x"0", x"7", x"1", x"3", x"8", x"1", x"0", x"5", x"1", x"5", x"8", x"5", x"9", x"3", x"0", x"7", x"9", x"6", x"0", x"8", x"6", x"6",
                                              x"7", x"0", x"1", x"7", x"2", x"4", x"2", x"7", x"1", x"2", x"1", x"8", x"8", x"3", x"9", x"9", x"8", x"7", x"9", x"7", x"9", x"0", x"8", x"7", x"9", x"2", x"2", x"7", x"4", x"9", x"2", x"1", x"9", x"0", x"1", x"6", x"9", x"9", x"7", x"2", x"0", x"8", x"8", x"8", x"0", x"9", x"3", x"7", x"7", x"6",
                                              x"6", x"5", x"7", x"2", x"7", x"3", x"3", x"3", x"0", x"0", x"1", x"0", x"5", x"3", x"3", x"6", x"7", x"8", x"8", x"1", x"2", x"2", x"0", x"2", x"3", x"5", x"4", x"2", x"1", x"8", x"0", x"9", x"7", x"5", x"1", x"2", x"5", x"4", x"5", x"4", x"0", x"5", x"9", x"4", x"7", x"5", x"2", x"2", x"4", x"3",
                                              x"5", x"2", x"5", x"8", x"4", x"9", x"0", x"7", x"7", x"1", x"1", x"6", x"7", x"0", x"5", x"5", x"6", x"0", x"1", x"3", x"6", x"0", x"4", x"8", x"3", x"9", x"5", x"8", x"6", x"4", x"4", x"6", x"7", x"0", x"6", x"3", x"2", x"4", x"4", x"1", x"5", x"7", x"2", x"2", x"1", x"5", x"5", x"3", x"9", x"7",
                                              x"5", x"3", x"6", x"9", x"7", x"8", x"1", x"7", x"9", x"7", x"7", x"8", x"4", x"6", x"1", x"7", x"4", x"0", x"6", x"4", x"9", x"5", x"5", x"1", x"4", x"9", x"2", x"9", x"0", x"8", x"6", x"2", x"5", x"6", x"9", x"3", x"2", x"1", x"9", x"7", x"8", x"4", x"6", x"8", x"6", x"2", x"2", x"4", x"8", x"2",
                                              x"8", x"3", x"9", x"7", x"2", x"2", x"4", x"1", x"3", x"7", x"5", x"6", x"5", x"7", x"0", x"5", x"6", x"0", x"5", x"7", x"4", x"9", x"0", x"2", x"6", x"1", x"4", x"0", x"7", x"9", x"7", x"2", x"9", x"6", x"8", x"6", x"5", x"2", x"4", x"1", x"4", x"5", x"3", x"5", x"1", x"0", x"0", x"4", x"7", x"4",
                                              x"8", x"2", x"1", x"6", x"6", x"3", x"7", x"0", x"4", x"8", x"4", x"4", x"0", x"3", x"1", x"9", x"9", x"8", x"9", x"0", x"0", x"0", x"8", x"8", x"9", x"5", x"2", x"4", x"3", x"4", x"5", x"0", x"6", x"5", x"8", x"5", x"4", x"1", x"2", x"2", x"7", x"5", x"8", x"8", x"6", x"6", x"6", x"8", x"8", x"1",
                                              x"1", x"6", x"4", x"2", x"7", x"1", x"7", x"1", x"4", x"7", x"9", x"9", x"2", x"4", x"4", x"4", x"2", x"9", x"2", x"8", x"2", x"3", x"0", x"8", x"6", x"3", x"4", x"6", x"5", x"6", x"7", x"4", x"8", x"1", x"3", x"9", x"1", x"9", x"1", x"2", x"3", x"1", x"6", x"2", x"8", x"2", x"4", x"5", x"8", x"6",
                                              x"1", x"7", x"8", x"6", x"6", x"4", x"5", x"8", x"3", x"5", x"9", x"1", x"2", x"4", x"5", x"6", x"6", x"5", x"2", x"9", x"4", x"7", x"6", x"5", x"4", x"5", x"6", x"8", x"2", x"8", x"4", x"8", x"9", x"1", x"2", x"8", x"8", x"3", x"1", x"4", x"2", x"6", x"0", x"7", x"6", x"9", x"0", x"0", x"4", x"2",
                                              x"2", x"4", x"2", x"1", x"9", x"0", x"2", x"2", x"6", x"7", x"1", x"0", x"5", x"5", x"6", x"2", x"6", x"3", x"2", x"1", x"1", x"1", x"1", x"1", x"0", x"9", x"3", x"7", x"0", x"5", x"4", x"4", x"2", x"1", x"7", x"5", x"0", x"6", x"9", x"4", x"1", x"6", x"5", x"8", x"9", x"6", x"0", x"4", x"0", x"8",
                                              x"0", x"7", x"1", x"9", x"8", x"4", x"0", x"3", x"8", x"5", x"0", x"9", x"6", x"2", x"4", x"5", x"5", x"4", x"4", x"4", x"3", x"6", x"2", x"9", x"8", x"1", x"2", x"3", x"0", x"9", x"8", x"7", x"8", x"7", x"9", x"9", x"2", x"7", x"2", x"4", x"4", x"2", x"8", x"4", x"9", x"0", x"9", x"1", x"8", x"8",
                                              x"8", x"4", x"5", x"8", x"0", x"1", x"5", x"6", x"1", x"6", x"6", x"0", x"9", x"7", x"9", x"1", x"9", x"1", x"3", x"3", x"8", x"7", x"5", x"4", x"9", x"9", x"2", x"0", x"0", x"5", x"2", x"4", x"0", x"6", x"3", x"6", x"8", x"9", x"9", x"1", x"2", x"5", x"6", x"0", x"7", x"1", x"7", x"6", x"0", x"6",
                                              x"0", x"5", x"8", x"8", x"6", x"1", x"1", x"6", x"4", x"6", x"7", x"1", x"0", x"9", x"4", x"0", x"5", x"0", x"7", x"7", x"5", x"4", x"1", x"0", x"0", x"2", x"2", x"5", x"6", x"9", x"8", x"3", x"1", x"5", x"5", x"2", x"0", x"0", x"0", x"5", x"5", x"9", x"3", x"5", x"7", x"2", x"9", x"7", x"2", x"5",
                                              x"7", x"1", x"6", x"3", x"6", x"2", x"6", x"9", x"5", x"6", x"1", x"8", x"8", x"2", x"6", x"7", x"0", x"4", x"2", x"8", x"2", x"5", x"2", x"4", x"8", x"3", x"6", x"0", x"0", x"8", x"2", x"3", x"2", x"5", x"7", x"5", x"3", x"0", x"4", x"2", x"0", x"7", x"5", x"2", x"9", x"6", x"3", x"4", x"5", x"0");

  signal a, b, c, d, e : unsigned(3 downto 0);
  signal product1      : unsigned(7 downto 0);
  signal product2      : unsigned(7 downto 0);
  signal product3      : unsigned(15 downto 0);
  signal product4      : unsigned(19 downto 0);
  signal i             : integer := 0;
  signal results_valid_int : std_logic;
  signal results_valid_int1 : std_logic;
  
begin  -- behavioral


-- purpose: count from 0 to 994
-- type   : sequential
-- inputs : clk, reset
-- outputs: i
  loop_counter : process (clk, reset) is
  begin  -- process loop_counter
    if reset = '1' then                 -- asynchronous reset (active high)
      i <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        if i < 995 then
          i <= i + 1;
        end if;
      end if;
    end if;
  end process loop_counter;


-- purpose: find the largest string
-- type   : sequential
-- inputs : clk, reset, number_string
-- outputs: results, results_valid
  find_large_string : process (clk, reset) is
  begin  -- process find_large_string
    if reset = '1' then                 -- asynchronous reset (active high)
      a             <= (others => '0');
      b             <= (others => '0');
      c             <= (others => '0');
      d             <= (others => '0');
      e             <= (others => '0');
      results_int   <= (others => '0');
      results_valid <= '0';
      product1      <= (others => '0');
      product2      <= (others => '0');
      product3      <= (others => '0');
      product4      <= (others => '0');
      results_valid_int <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        a <= unsigned(my_number_string(i));
        b <= unsigned(my_number_string(i+1));
        c <= unsigned(my_number_string(i+2));
        d <= unsigned(my_number_string(i+3));
        e <= unsigned(my_number_string(i+4));

        product1 <= a * b;
        product2 <= c * d;
        product3 <= product1 * product2;  -- next clk cycle
        product4 <= product3 * e;         -- next, next clk cycle

        results_valid_int1 <= results_valid_int; -- next clk cycle
        results_valid <= results_valid_int1; -- next, next clk cycle
        if product4 > results_int then
          results_int <= product4;
        end if;
        if i = 994 then
          results_valid_int <= '1';
        end if;  -- if 994
      end if;  -- if enabled
    end if;  -- register
  end process find_large_string;

  results <= results_int;


  
end architecture behavioral;



architecture bad_code of euler8 is
  signal results_int       : unsigned(19 downto 0);
  signal results_valid_int : std_logic;

  type number_string is array(0 to 999) of unsigned(3 downto 0);
  signal my_number_string : number_string := (x"7", x"3", x"1", x"6", x"7", x"1", x"7", x"6", x"5", x"3", x"1", x"3", x"3", x"0", x"6", x"2", x"4", x"9", x"1", x"9", x"2", x"2", x"5", x"1", x"1", x"9", x"6", x"7", x"4", x"4", x"2", x"6", x"5", x"7", x"4", x"7", x"4", x"2", x"3", x"5", x"5", x"3", x"4", x"9", x"1", x"9", x"4", x"9", x"3", x"4",
                                              x"9", x"6", x"9", x"8", x"3", x"5", x"2", x"0", x"3", x"1", x"2", x"7", x"7", x"4", x"5", x"0", x"6", x"3", x"2", x"6", x"2", x"3", x"9", x"5", x"7", x"8", x"3", x"1", x"8", x"0", x"1", x"6", x"9", x"8", x"4", x"8", x"0", x"1", x"8", x"6", x"9", x"4", x"7", x"8", x"8", x"5", x"1", x"8", x"4", x"3",
                                              x"8", x"5", x"8", x"6", x"1", x"5", x"6", x"0", x"7", x"8", x"9", x"1", x"1", x"2", x"9", x"4", x"9", x"4", x"9", x"5", x"4", x"5", x"9", x"5", x"0", x"1", x"7", x"3", x"7", x"9", x"5", x"8", x"3", x"3", x"1", x"9", x"5", x"2", x"8", x"5", x"3", x"2", x"0", x"8", x"8", x"0", x"5", x"5", x"1", x"1",
                                              x"1", x"2", x"5", x"4", x"0", x"6", x"9", x"8", x"7", x"4", x"7", x"1", x"5", x"8", x"5", x"2", x"3", x"8", x"6", x"3", x"0", x"5", x"0", x"7", x"1", x"5", x"6", x"9", x"3", x"2", x"9", x"0", x"9", x"6", x"3", x"2", x"9", x"5", x"2", x"2", x"7", x"4", x"4", x"3", x"0", x"4", x"3", x"5", x"5", x"7",
                                              x"6", x"6", x"8", x"9", x"6", x"6", x"4", x"8", x"9", x"5", x"0", x"4", x"4", x"5", x"2", x"4", x"4", x"5", x"2", x"3", x"1", x"6", x"1", x"7", x"3", x"1", x"8", x"5", x"6", x"4", x"0", x"3", x"0", x"9", x"8", x"7", x"1", x"1", x"1", x"2", x"1", x"7", x"2", x"2", x"3", x"8", x"3", x"1", x"1", x"3",
                                              x"6", x"2", x"2", x"2", x"9", x"8", x"9", x"3", x"4", x"2", x"3", x"3", x"8", x"0", x"3", x"0", x"8", x"1", x"3", x"5", x"3", x"3", x"6", x"2", x"7", x"6", x"6", x"1", x"4", x"2", x"8", x"2", x"8", x"0", x"6", x"4", x"4", x"4", x"4", x"8", x"6", x"6", x"4", x"5", x"2", x"3", x"8", x"7", x"4", x"9",
                                              x"3", x"0", x"3", x"5", x"8", x"9", x"0", x"7", x"2", x"9", x"6", x"2", x"9", x"0", x"4", x"9", x"1", x"5", x"6", x"0", x"4", x"4", x"0", x"7", x"7", x"2", x"3", x"9", x"0", x"7", x"1", x"3", x"8", x"1", x"0", x"5", x"1", x"5", x"8", x"5", x"9", x"3", x"0", x"7", x"9", x"6", x"0", x"8", x"6", x"6",
                                              x"7", x"0", x"1", x"7", x"2", x"4", x"2", x"7", x"1", x"2", x"1", x"8", x"8", x"3", x"9", x"9", x"8", x"7", x"9", x"7", x"9", x"0", x"8", x"7", x"9", x"2", x"2", x"7", x"4", x"9", x"2", x"1", x"9", x"0", x"1", x"6", x"9", x"9", x"7", x"2", x"0", x"8", x"8", x"8", x"0", x"9", x"3", x"7", x"7", x"6",
                                              x"6", x"5", x"7", x"2", x"7", x"3", x"3", x"3", x"0", x"0", x"1", x"0", x"5", x"3", x"3", x"6", x"7", x"8", x"8", x"1", x"2", x"2", x"0", x"2", x"3", x"5", x"4", x"2", x"1", x"8", x"0", x"9", x"7", x"5", x"1", x"2", x"5", x"4", x"5", x"4", x"0", x"5", x"9", x"4", x"7", x"5", x"2", x"2", x"4", x"3",
                                              x"5", x"2", x"5", x"8", x"4", x"9", x"0", x"7", x"7", x"1", x"1", x"6", x"7", x"0", x"5", x"5", x"6", x"0", x"1", x"3", x"6", x"0", x"4", x"8", x"3", x"9", x"5", x"8", x"6", x"4", x"4", x"6", x"7", x"0", x"6", x"3", x"2", x"4", x"4", x"1", x"5", x"7", x"2", x"2", x"1", x"5", x"5", x"3", x"9", x"7",
                                              x"5", x"3", x"6", x"9", x"7", x"8", x"1", x"7", x"9", x"7", x"7", x"8", x"4", x"6", x"1", x"7", x"4", x"0", x"6", x"4", x"9", x"5", x"5", x"1", x"4", x"9", x"2", x"9", x"0", x"8", x"6", x"2", x"5", x"6", x"9", x"3", x"2", x"1", x"9", x"7", x"8", x"4", x"6", x"8", x"6", x"2", x"2", x"4", x"8", x"2",
                                              x"8", x"3", x"9", x"7", x"2", x"2", x"4", x"1", x"3", x"7", x"5", x"6", x"5", x"7", x"0", x"5", x"6", x"0", x"5", x"7", x"4", x"9", x"0", x"2", x"6", x"1", x"4", x"0", x"7", x"9", x"7", x"2", x"9", x"6", x"8", x"6", x"5", x"2", x"4", x"1", x"4", x"5", x"3", x"5", x"1", x"0", x"0", x"4", x"7", x"4",
                                              x"8", x"2", x"1", x"6", x"6", x"3", x"7", x"0", x"4", x"8", x"4", x"4", x"0", x"3", x"1", x"9", x"9", x"8", x"9", x"0", x"0", x"0", x"8", x"8", x"9", x"5", x"2", x"4", x"3", x"4", x"5", x"0", x"6", x"5", x"8", x"5", x"4", x"1", x"2", x"2", x"7", x"5", x"8", x"8", x"6", x"6", x"6", x"8", x"8", x"1",
                                              x"1", x"6", x"4", x"2", x"7", x"1", x"7", x"1", x"4", x"7", x"9", x"9", x"2", x"4", x"4", x"4", x"2", x"9", x"2", x"8", x"2", x"3", x"0", x"8", x"6", x"3", x"4", x"6", x"5", x"6", x"7", x"4", x"8", x"1", x"3", x"9", x"1", x"9", x"1", x"2", x"3", x"1", x"6", x"2", x"8", x"2", x"4", x"5", x"8", x"6",
                                              x"1", x"7", x"8", x"6", x"6", x"4", x"5", x"8", x"3", x"5", x"9", x"1", x"2", x"4", x"5", x"6", x"6", x"5", x"2", x"9", x"4", x"7", x"6", x"5", x"4", x"5", x"6", x"8", x"2", x"8", x"4", x"8", x"9", x"1", x"2", x"8", x"8", x"3", x"1", x"4", x"2", x"6", x"0", x"7", x"6", x"9", x"0", x"0", x"4", x"2",
                                              x"2", x"4", x"2", x"1", x"9", x"0", x"2", x"2", x"6", x"7", x"1", x"0", x"5", x"5", x"6", x"2", x"6", x"3", x"2", x"1", x"1", x"1", x"1", x"1", x"0", x"9", x"3", x"7", x"0", x"5", x"4", x"4", x"2", x"1", x"7", x"5", x"0", x"6", x"9", x"4", x"1", x"6", x"5", x"8", x"9", x"6", x"0", x"4", x"0", x"8",
                                              x"0", x"7", x"1", x"9", x"8", x"4", x"0", x"3", x"8", x"5", x"0", x"9", x"6", x"2", x"4", x"5", x"5", x"4", x"4", x"4", x"3", x"6", x"2", x"9", x"8", x"1", x"2", x"3", x"0", x"9", x"8", x"7", x"8", x"7", x"9", x"9", x"2", x"7", x"2", x"4", x"4", x"2", x"8", x"4", x"9", x"0", x"9", x"1", x"8", x"8",
                                              x"8", x"4", x"5", x"8", x"0", x"1", x"5", x"6", x"1", x"6", x"6", x"0", x"9", x"7", x"9", x"1", x"9", x"1", x"3", x"3", x"8", x"7", x"5", x"4", x"9", x"9", x"2", x"0", x"0", x"5", x"2", x"4", x"0", x"6", x"3", x"6", x"8", x"9", x"9", x"1", x"2", x"5", x"6", x"0", x"7", x"1", x"7", x"6", x"0", x"6",
                                              x"0", x"5", x"8", x"8", x"6", x"1", x"1", x"6", x"4", x"6", x"7", x"1", x"0", x"9", x"4", x"0", x"5", x"0", x"7", x"7", x"5", x"4", x"1", x"0", x"0", x"2", x"2", x"5", x"6", x"9", x"8", x"3", x"1", x"5", x"5", x"2", x"0", x"0", x"0", x"5", x"5", x"9", x"3", x"5", x"7", x"2", x"9", x"7", x"2", x"5",
                                              x"7", x"1", x"6", x"3", x"6", x"2", x"6", x"9", x"5", x"6", x"1", x"8", x"8", x"2", x"6", x"7", x"0", x"4", x"2", x"8", x"2", x"5", x"2", x"4", x"8", x"3", x"6", x"0", x"0", x"8", x"2", x"3", x"2", x"5", x"7", x"5", x"3", x"0", x"4", x"2", x"0", x"7", x"5", x"2", x"9", x"6", x"3", x"4", x"5", x"0");

  signal a, b, c, d, e : unsigned(3 downto 0);
  signal product1      : unsigned(7 downto 0);
  signal product2      : unsigned(7 downto 0);
  signal product3      : unsigned(15 downto 0);
  signal product4      : unsigned(19 downto 0);

begin  -- architecture bad_code

 purpose: find the largest string
 type   : sequential
 inputs : clk, reset, number_string
 outputs: results, results_valid
  find_large_string : process (clk, reset) is
  begin  -- process find_large_string
    if reset = '1' then                 -- asynchronous reset (active high)
      a             <= (others => '0');
      b             <= (others => '0');
      c             <= (others => '0');
      d             <= (others => '0');
      e             <= (others => '0');
      results_int   <= (others => '0');
      results_valid <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if enable = '1' then
        for i in 0 to 994 loop
          a <= unsigned(my_number_string(i));
          b <= unsigned(my_number_string(i+1));
          c <= unsigned(my_number_string(i+2));
          d <= unsigned(my_number_string(i+3));
          e <= unsigned(my_number_string(i+4));

          if product4 > results_int then
            results_int <= product4;
          end if;
          if i = 994 then
            results_valid <= '1';
          end if;  -- if 994
        end loop;  -- i
        
      end if;  -- if enabled
    end if;  -- register
  end process find_large_string;

  product1 <= a * b;
  product2 <= c * d;
  product3 <= product1 * product2;
  product4 <= product3 * e;

  results <= results_int;

  

end architecture bad_code;
