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
signal ADC_CNT_MAX: std_logic_vector(7 downto 0);
signal ADC_clk: std_logic;
signal AGC_CNT: std_logic_vector(7 downto 0);
signal AGC_CNT_MAX: std_logic_vector(7 downto 0);
signal AGC_clk: std_logic;
signal XCORR_CNT: std_logic_vector(2 downto 0);
constant XCORR_CNT_MAX: std_logic_vector(2 downto 0) := "111";
type t_state is (S_IDLE, S_RUN, S_WAIT);
signal state: t_state;

begin

--ASYNC
hf_clk_o <= hf_clk_i;
ADC_clk_o <= ADC_clk;
AGC_clk_o <= AGC_clk;
XCORR_clk_o <= hf_clk_i when state = S_RUN else '0';

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
		--DIV BY TWO
		ADC_CNT_MAX <= ("0" & set_per_ADC_i(7 downto 1) - 1);
		ADC_clk <= '0';
	elsif rising_edge(hf_clk_i) then
		--GENERATE CLOCK
		if ADC_CNT = ADC_CNT_MAX then
			ADC_clk <= not ADC_clk;
			ADC_CNT <= (others => '0');
		else
			ADC_CNT <= ADC_CNT + 1;
		end if;
	end if;
end process P_ADC_CLK;

--XCORR CLOCK
P_XCORR_CLK: process(rst_i, hf_clk_i) begin
	if rst_i = '1' then
		state <= S_IDLE;
	elsif rising_edge(hf_clk_i) then
		case state is
			
			--RESET/ IDLE STATE
			when S_IDLE =>
				XCORR_CNT <= (others => '0');
				if ADC_clk = '1' then
					state <= S_RUN;
				end if;
				
			--FREE RUN MODE FOR 8 CYCLES
			when S_RUN =>
				if XCORR_CNT = XCORR_CNT_MAX then
					state <= S_WAIT;
				else
					XCORR_CNT <= XCORR_CNT + 1;
				end if;
				
			--PREVENT A SECOND TRIGGER IN SAME ADC CYLCE
			when S_WAIT =>
				if ADC_clk = '0' then
					state <= S_IDLE;
				end if;
			when others =>
				
		end case;
	end if;
end process P_XCORR_CLK;

end Behavioral;


