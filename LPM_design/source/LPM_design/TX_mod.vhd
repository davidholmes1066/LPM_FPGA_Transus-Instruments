library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--ENTITY
entity TX_mod is
			--INPUTS
	port (	adc_clk_i: in std_logic;
			rst_i: in std_logic;
			Ordr_i: std_logic_vector(3 downto 0);
			Mask_i: in std_logic_vector(15 downto 0);
			Seed_i: in std_logic_vector(15 downto 0);
			trig_i: in std_logic;
			
			--OUTPUTS
			TX_p_o: out std_logic;
			TX_n_o: out std_logic;
			reg_o: out std_logic_vector(15 downto 0));
end;


--ARCHITECTURE
architecture Behavioral of TX_mod is

--SIGNALS AND STATES
signal LFSR_reg: std_logic_vector(15 downto 0);
signal Mask: std_logic_vector(15 downto 0);
signal Seed: std_logic_vector(15 downto 0);
signal Ordr: integer;

type t_state is (S_IDLE, S_TX, S_WAIT);
signal state: t_state;

begin

--ASYNC
TX_p_o <= '1' when LFSR_reg(0) = '1' else '0';
TX_n_o <= '0' when LFSR_reg(0) = '1' else '1';
reg_o <= LFSR_reg;

P_LFSR: process(rst_i, adc_clk_i) begin
	if rst_i = '1' then
		--RESET
		state <= S_IDLE;
		--LATCH IN INPUTS
		Mask <= ("0" & Mask_i(15 downto 1));
		Seed <= Seed_i;
		Ordr <= to_integer(unsigned(Ordr_i));
	elsif rising_edge(adc_clk_i) then
		case state is
			
			--RESET/ IDLE CONDITION
			when S_IDLE =>
				LFSR_reg <= Seed;
				if trig_i = '1' then
					state <= S_TX;
				end if;
			
			--HANDLE LFSR
			when S_TX =>
				if LFSR_reg(0) = '1' then
					LFSR_reg((Ordr - 1) downto 0) <= (LFSR_reg(0) & LFSR_reg((ordr - 1) downto 1)) xor Mask(Ordr - 1 downto 0);
				else
					LFSR_reg((Ordr - 1) downto 0) <= (LFSR_reg(0) & LFSR_reg((ordr - 1) downto 1));
				end if;
			
			--WAIT FOR TRIG TO RESET
			when S_WAIT =>
				state <= S_IDLE; --DEBUG
			
			--HANDLE UNKNOWN VALUE
			when others =>
				state <= S_IDLE;
		end case;
	end if;
end process P_LFSR;


end Behavioral;
