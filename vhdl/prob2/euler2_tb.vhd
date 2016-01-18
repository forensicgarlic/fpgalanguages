-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler2"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler2_tb.vhd
-- Author     :   <dstanford@CNO-D-DSTAN2>
-- Company    : 
-- Created    : 2012-12-05
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
-- 2012-12-05  1.0      dstanford	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity euler2_tb is

end entity euler2_tb;

-------------------------------------------------------------------------------

architecture tb of euler2_tb is

  -- component generics
  constant max_count : integer := 3999999;

  -- component ports
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(31 downto 0);
  signal results_valid : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture tb

  -- component instantiation
  DUT: entity work.euler2
    generic map (
      max_count => max_count)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 1.5 ns; --330.8 mhz

  -- waveform generation
  WaveGen_Proc: process
  begin
    enable <= '0';
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;
    enable <= '1';
    wait until results_valid = '1';
    wait for 10 ns;
    assert (results = x"00466664") report "unexpected results" severity error;
    assert false report "test complete" severity failure;
  end process WaveGen_Proc;

  

end architecture tb;

-------------------------------------------------------------------------------

configuration euler2_tb_tb_cfg of euler2_tb is
  for tb
  end for;
end euler2_tb_tb_cfg;

-------------------------------------------------------------------------------
