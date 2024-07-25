library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity clk_mod is
			--INPUTS
	port (	hf_clk_i: in std_logic;
			rst_i: in std_logic;
			set_per_ADC_i: in std_logic_vector(7 downto 0);
			set_per_AGC_i: in std_logic_vector(7 downto 0);
			
			--OUTPUTS
			hf_clk_o: out std_logic;
			ADC_clk_o: out std_logic;
			AGC_clk_o: out std_logic;
			XCORR_clk_o: out std_logic);
end;


--ACHITECTURE
architecture Behavioral of clk_mod is

--SIGNALS AND STATES
signal ADC_CNT: std_logic_vector(7 downto 0);
signal ADC_HALF_CNT_MAX: std_logic_vector(7 downto 0);
signal ADC_FULL_CNT_MAX: std_logic_vector(7 downto 0);
signal ADC_clk: std_logic;
signal AGC_CNT: std_logic_vector(7 downto 0);
signal AGC_CNT_MAX: std_logic_vector(7 downto 0);
signal AGC_clk: std_logic;
signal XCORR_CLK_ACTIVE: std_logic;
type t_state is (S_IDLE, S_RUN, S_WAIT);
signal state: t_state;

begin

--ASYNC
hf_clk_o <= hf_clk_i;
ADC_clk_o <= ADC_clk;
AGC_clk_o <= AGC_clk;
XCORR_clk_o <= hf_clk_i and XCORR_CLK_ACTIVE;

--AGC CLOCK
P_AGC_CLK: process(rst_i, hf_clk_i) begin
	if rst_i = '1' then
		AGC_CNT <= (others => '0');
		--DIV BY TWO
		AGC_CNT_MAX <= ("0" & set_per_AGC_i(7 downto 1) - 1);
		AGC_clk <= '0';
	elsif rising_edge(hf_clk_i) then
		--GENERATE CLOCK
		if AGC_CNT = AGC_CNT_MAX then
			AGC_clk <= NOT AGC_clk;
			AGC_CNT <= (others => '0');
		else
			AGC_CNT <= AGC_CNT + 1;
		end if;
	end if;
end process P_AGC_CLK;

--ADC CLOCK
P_ADC_CLK: process(rst_i, hf_clk_i) begin
	if rst_i = '1' then
		ADC_CNT <= (others => '0');
		ADC_clk <= '0';
		ADC_HALF_CNT_MAX <= ("0" & set_per_ADC_i(7 downto 1) - 1);
		ADC_FULL_CNT_MAX <= set_per_ADC_i-1;
	elsif rising_edge(hf_clk_i) then
		--GENERATE CLOCK
		ADC_CNT <=ADC_CNT +1;
		
		if ADC_CNT >=0 and  ADC_CNT<= ADC_HALF_CNT_MAX then
			ADC_clk <= '1';
		end if;
		
		if ADC_CNT > ADC_HALF_CNT_MAX and  ADC_CNT< ADC_FULL_CNT_MAX then
			ADC_clk <= '0';
		end if;
		
		if ADC_CNT=ADC_FULL_CNT_MAX then
			ADC_CNT <= (others => '0');
			ADC_clk <= '0';
		end if;

	end if;
end process P_ADC_CLK;

--XCORR CLOCK
P_XCORR_CLK: process(rst_i, hf_clk_i) begin
	if rst_i = '1' then
		XCORR_CLK_ACTIVE <= '0';
	elsif falling_edge(hf_clk_i) then

		if ADC_CNT >=0 and  ADC_CNT<=7  then
			XCORR_CLK_ACTIVE <= '1';
		else
			XCORR_CLK_ACTIVE <= '0';
		end if;
		
	end if;
end process P_XCORR_CLK;



end Behavioral;


