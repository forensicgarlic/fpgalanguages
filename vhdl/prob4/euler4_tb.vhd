-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler4"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler4_tb.vhd
-- Author     : U-CNO-D-DSTAN2\dstanford
-- Company    : GETCO
-- Created    : 2012-10-25
-- Last update: 2012-12-13
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GETCO
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-10-25  1.0      dstanford	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity euler4_tb is

end entity euler4_tb;

-------------------------------------------------------------------------------

architecture tb of euler4_tb is

  -- component generics
  constant start_count : integer := 100;
  constant end_count   : integer := 999;

  -- component ports
  signal clk           : std_logic:= '0';
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(31 downto 0);
  signal results_valid : std_logic;

  -- clock

begin  -- architecture tb

  -- component instantiation
  DUT: entity work.euler4(fast)
    generic map (
      start_count => start_count,
      end_count   => end_count)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 1.4 ns;            -- altera reported fmax at 365 Mhz

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    reset <= '1';
    enable <= '0';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;
    enable <= '1';
    wait until results_valid = '1';
    wait for 1 us;
    assert (results = x"0000d571") report "unexpected output" severity error;
    assert false report "test is complete" severity failure;
    
  end process WaveGen_Proc;

  

end architecture tb;

-------------------------------------------------------------------------------

configuration euler4_tb_tb_cfg of euler4_tb is
  for tb
  end for;
end euler4_tb_tb_cfg;

-------------------------------------------------------------------------------
