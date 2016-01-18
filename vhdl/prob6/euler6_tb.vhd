-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler6"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler6_tb.vhd
-- Author     :   <dstanford@CNO-D-DSTAN2>
-- Company    : 
-- Created    : 2012-12-07
-- Last update: 2012-12-10
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

entity euler6_tb is

end entity euler6_tb;

-------------------------------------------------------------------------------

architecture tb of euler6_tb is

  -- component generics
  constant max_count : integer := 100;

  -- component ports
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(31 downto 0);
  signal results_valid : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture tb

  -- component instantiation
  DUT: entity work.euler6
    generic map (
      max_count => max_count)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 0.7 ns; -- 717.36 mhz

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    reset <= '1';
    enable <= '0';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;
    wait until rising_edge(clk);
    enable <= '1';
    wait until results_valid = '1';
    wait for 1 us;
    assert (results = x"017ff976") report "unexpected output" severity error;
    assert false report "test is complete" severity failure;

  end process WaveGen_Proc;

  

end architecture tb;

-------------------------------------------------------------------------------

configuration euler6_tb_tb_cfg of euler6_tb is
  for tb
  end for;
end euler6_tb_tb_cfg;

-------------------------------------------------------------------------------
