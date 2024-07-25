library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_TX_mod is
end tb_TX_mod;

architecture testbench of tb_TX_mod is

    -- Component Declaration
    component TX_mod is
        port (
            adc_clk_i: in std_logic;
            rst_i: in std_logic;
            Ordr_i: in std_logic_vector(3 downto 0);
            Mask_i: in std_logic_vector(15 downto 0);
            Seed_i: in std_logic_vector(15 downto 0);
            trig_i: in std_logic;
            TX_p_o: out std_logic;
            TX_n_o: out std_logic;
			reg_o: out std_logic_vector(15 downto 0)
        );
    end component;

    -- Signals
    signal adc_clk_i: std_logic := '0';
    signal rst_i: std_logic := '0';
    signal Ordr_i: std_logic_vector(3 downto 0) := (others => '0');
    signal Mask_i: std_logic_vector(15 downto 0) := (others => '0');
    signal Seed_i: std_logic_vector(15 downto 0) := (others => '0');
    signal trig_i: std_logic := '0';
    signal TX_p_o: std_logic;
    signal TX_n_o: std_logic;
	signal reg_o: std_logic_vector(15 downto 0);

    -- Clock period definition
    constant clk_period: time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: TX_mod
        port map (
            adc_clk_i => adc_clk_i,
            rst_i => rst_i,
            Ordr_i => Ordr_i,
            Mask_i => Mask_i,
            Seed_i => Seed_i,
            trig_i => trig_i,
            TX_p_o => TX_p_o,
            TX_n_o => TX_n_o,
			reg_o => reg_o
        );

    -- Clock process definitions
    clk_process :process
    begin
        while True loop
            adc_clk_i <= '0';
            wait for clk_period/2;
            adc_clk_i <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        rst_i <= '1';
        Ordr_i <= x"4"; 	-- Order of the LFSR
        Mask_i <= x"000C"; -- Mask input
        Seed_i <= x"000F"; -- Seed input
        trig_i <= '0';
        wait for 20 ns;
        
        -- Release reset
        rst_i <= '1';
		wait for 20ns;
		rst_i <= '0';
        wait for 200 ns;
        
        -- Apply trigger
        trig_i <= '1';
        wait for 10 ns;
        trig_i <= '0';
		
        -- Stop the simulation
        wait;
    end process;

end testbench;