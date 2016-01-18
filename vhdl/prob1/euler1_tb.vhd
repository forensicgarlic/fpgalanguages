-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler1"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler1_tb.vhd
-- Author     :   <dstanford@CNO-D-DSTAN2>
-- Company    : 
-- Created    : 2012-12-05
-- Last update: 2012-12-07
-- Platform   : 
-- Standard   : VHDL'87
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

entity euler1_tb is

end euler1_tb;

-------------------------------------------------------------------------------

architecture tb of euler1_tb is

  -- component generics
  constant max_count : integer := 999;

  -- component ports
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(31 downto 0);
  signal results_valid : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- tb

  -- component instantiation
  DUT: entity work.euler1(behavioral_compact)
    generic map (
      max_count => 999)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 0.7 ns; --1.4 ns period. fmax = 717.36 Mhz. 

  -- waveform generation
  WaveGen_Proc: process
  begin
    enable<= '0';
    reset<= '1';
    wait for 10 ns;
    reset<= '0';
    wait for 10 ns;
    enable<='1';
    wait until results_valid = '1';
    wait for 10 ns;
    assert (results = x"00038ed0") report "unexpected output" severity error;
    assert (false) report "test complete" severity failure;
  end process WaveGen_Proc;

end tb;

-------------------------------------------------------------------------------

configuration euler1_tb_tb_cfg of euler1_tb is
  for tb
  end for;
end euler1_tb_tb_cfg;

-------------------------------------------------------------------------------
