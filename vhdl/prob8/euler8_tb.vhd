-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler8"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler8_tb.vhd
-- Author     :   <dstanford@CNO-D-DSTAN2>
-- Company    : 
-- Created    : 2012-12-07
-- Last update: 2012-12-09
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-12-07  1.0      dstanford	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity euler8_tb is

end entity euler8_tb;

-------------------------------------------------------------------------------

architecture tb of euler8_tb is

  -- component ports
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(19 downto 0);
  signal results_valid : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture tb

  -- component instantiation
  DUT: entity work.euler8(behavioral)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 1.4 ns; --125.44 mhz with unpipelined multiply, 356.76
                             --with pipeline

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    enable <= '0';
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;
    enable <= '1';
    wait until results_valid = '1';
    wait for 100 ns;
    assert (results = x"09f78") report "unexpected results" severity error;
    assert false report "test complete" severity failure;
  

  end process WaveGen_Proc;


end architecture tb;

-------------------------------------------------------------------------------
