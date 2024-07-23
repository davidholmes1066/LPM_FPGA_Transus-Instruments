--
-- Synopsys
-- Vhdl wrapper for top level design, written on Tue Jul 23 09:46:06 2024
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity wrapper_for_AGC_mod is
   port (
      clk_i : in std_logic;
      rst_i : in std_logic;
      trig_i : in std_logic;
      AGC_set_val_i : in std_logic_vector(7 downto 0);
      AQ_DAC_CS_o : out std_logic;
      AQ_DAC_SCK_o : out std_logic;
      AQ_DAC_SDO_o : out std_logic
   );
end wrapper_for_AGC_mod;

architecture behavioral of wrapper_for_AGC_mod is

component AGC_mod
 port (
   clk_i : in std_logic;
   rst_i : in std_logic;
   trig_i : in std_logic;
   AGC_set_val_i : in std_logic_vector (7 downto 0);
   AQ_DAC_CS_o : out std_logic;
   AQ_DAC_SCK_o : out std_logic;
   AQ_DAC_SDO_o : out std_logic
 );
end component;

signal tmp_clk_i : std_logic;
signal tmp_rst_i : std_logic;
signal tmp_trig_i : std_logic;
signal tmp_AGC_set_val_i : std_logic_vector (7 downto 0);
signal tmp_AQ_DAC_CS_o : std_logic;
signal tmp_AQ_DAC_SCK_o : std_logic;
signal tmp_AQ_DAC_SDO_o : std_logic;

begin

tmp_clk_i <= clk_i;

tmp_rst_i <= rst_i;

tmp_trig_i <= trig_i;

tmp_AGC_set_val_i <= AGC_set_val_i;

AQ_DAC_CS_o <= tmp_AQ_DAC_CS_o;

AQ_DAC_SCK_o <= tmp_AQ_DAC_SCK_o;

AQ_DAC_SDO_o <= tmp_AQ_DAC_SDO_o;



u1:   AGC_mod port map (
		clk_i => tmp_clk_i,
		rst_i => tmp_rst_i,
		trig_i => tmp_trig_i,
		AGC_set_val_i => tmp_AGC_set_val_i,
		AQ_DAC_CS_o => tmp_AQ_DAC_CS_o,
		AQ_DAC_SCK_o => tmp_AQ_DAC_SCK_o,
		AQ_DAC_SDO_o => tmp_AQ_DAC_SDO_o
       );
end behavioral;
