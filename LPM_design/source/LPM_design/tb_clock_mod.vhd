library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_clk_mod is
end tb_clk_mod;

architecture Behavioral of tb_clk_mod is

    -- Component Declaration
    component clk_mod
        port(
            hf_clk_i: in std_logic;
            rst_i: in std_logic;
            set_per_ADC_i: in std_logic_vector(7 downto 0);
            set_per_AGC_i: in std_logic_vector(7 downto 0);
            hf_clk_o: out std_logic;
            ADC_clk_o: out std_logic;
            AGC_clk_o: out std_logic;
            XCORR_clk_o: out std_logic
        );
    end component;

    -- Testbench signals
    signal hf_clk_i: std_logic := '0';
    signal rst_i: std_logic := '0';
    signal set_per_ADC_i: std_logic_vector(7 downto 0) := (others => '0');
    signal set_per_AGC_i: std_logic_vector(7 downto 0) := (others => '0');
    signal hf_clk_o: std_logic;
    signal ADC_clk_o: std_logic;
    signal AGC_clk_o: std_logic;
    signal XCORR_clk_o: std_logic;

    -- Clock period definitions
    constant hf_clk_period: time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: clk_mod
        port map (
            hf_clk_i => hf_clk_i,
            rst_i => rst_i,
            set_per_ADC_i => set_per_ADC_i,
            set_per_AGC_i => set_per_AGC_i,
            hf_clk_o => hf_clk_o,
            ADC_clk_o => ADC_clk_o,
            AGC_clk_o => AGC_clk_o,
            XCORR_clk_o => XCORR_clk_o
        );

    -- Clock generation process
    hf_clk_process :process
    begin
        hf_clk_i <= '0';
        wait for hf_clk_period / 2;
        hf_clk_i <= '1';
        wait for hf_clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin

        -- Apply test vectors
        set_per_ADC_i <= "00010000"; -- Set ADC clock period
        set_per_AGC_i <= "00000100"; -- Set AGC clock period
		
		-- reset the system
        rst_i <= '1';
        wait for 20 ns;
        rst_i <= '0';

        -- Wait for some time to observe the outputs
        wait for 200 ns;

        -- Finish the simulation
        wait;
    end process;

end Behavioral;