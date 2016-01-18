-------------------------------------------------------------------------------
-- Title      : Testbench for design "euler7"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : euler7_tb.vhd
-- Author     : U-CNO-D-DSTAN2\dstanford
-- Company    : GETCO
-- Created    : 2012-10-25
-- Last update: 2012-12-10
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

entity euler7_tb is

end entity euler7_tb;

-------------------------------------------------------------------------------

architecture tb of euler7_tb is

  -- component generics
  constant max_count : integer := 10001;

  -- component ports
  signal clk           : std_logic:='0';
  signal reset         : std_logic;
  signal enable        : std_logic;
  signal results       : unsigned(31 downto 0);
  signal results_valid : std_logic;


begin  -- architecture tb

  -- component instantiation
  DUT: entity work.euler7
    generic map (
      max_count => max_count)
    port map (
      clk           => clk,
      reset         => reset,
      enable        => enable,
      results       => results,
      results_valid => results_valid);

  -- clock generation
  Clk <= not Clk after 18 ns; --28.36 Mhz

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    reset <= '1';
    enable <= '0';
    wait for 1 us;
    reset <= '0';
    wait for 1 us;
    enable <= '1';
    wait until results_valid = '1';
    wait for 1 us;
    assert (results = x"017ff976") report "unexpected output" severity error;
    assert false report "test is complete" severity failure;
    
  end process WaveGen_Proc;

  

end architecture tb;

-------------------------------------------------------------------------------

configuration euler7_tb_tb_cfg of euler7_tb is
  for tb
  end for;
end euler7_tb_tb_cfg;

-------------------------------------------------------------------------------
