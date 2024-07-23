library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_AGC_mod is
end tb_AGC_mod;

architecture Behavioral of tb_AGC_mod is

    -- Component Declaration for the Unit Under Test (UUT)
    component AGC_mod
        port(
            clk_i : in std_logic;
            rst_i : in std_logic;
            trig_i : in std_logic;
            AGC_set_val_i : in std_logic_vector(7 downto 0);
            AQ_DAC_CS_o : out std_logic;
            AQ_DAC_SCK_o : out std_logic;
            AQ_DAC_SDO_o : out std_logic
        );
    end component;

    -- Inputs
    signal clk_i : std_logic := '0';
    signal rst_i : std_logic := '0';
    signal trig_i : std_logic := '0';
    signal AGC_set_val_i : std_logic_vector(7 downto 0) := (others => '0');

    -- Outputs
    signal AQ_DAC_CS_o : std_logic;
    signal AQ_DAC_SCK_o : std_logic;
    signal AQ_DAC_SDO_o : std_logic;

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: AGC_mod
        port map (
            clk_i => clk_i,
            rst_i => rst_i,
            trig_i => trig_i,
            AGC_set_val_i => AGC_set_val_i,
            AQ_DAC_CS_o => AQ_DAC_CS_o,
            AQ_DAC_SCK_o => AQ_DAC_SCK_o,
            AQ_DAC_SDO_o => AQ_DAC_SDO_o
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk_i <= '0';
        wait for clk_period/2;
        clk_i <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin	
        -- Initialize Inputs
        rst_i <= '1';
        wait for clk_period*2;
        rst_i <= '0';
        wait for clk_period*2;

        -- Apply a trigger
        AGC_set_val_i <= "10101010";
        trig_i <= '1';
        wait for clk_period;
        trig_i <= '0';
        
        -- Wait for the state machine to process
        wait for clk_period*20;
        
        -- Apply another trigger
        AGC_set_val_i <= "11001100";
        trig_i <= '1';
        wait for clk_period;
        trig_i <= '0';
        
        -- Wait for the state machine to process
        wait for clk_period*20;

        -- Final reset
        rst_i <= '1';
        wait for clk_period*2;
        rst_i <= '0';

        wait;
    end process;

end Behavioral;
