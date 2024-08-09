 library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--ENTITY
entity TX_mod is
			--INPUTS
	port (	adc_clk_i: in std_logic;
			rst_i: in std_logic;
			Code_L_i: std_logic_vector(15 downto 0);
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
signal Code_L: std_logic_vector(15 downto 0);
signal Code_CNT: std_logic_vector(15 downto 0);

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
		Mask <= Mask_i;
		Seed <= Seed_i;
		Code_L <= Code_L_i;
	elsif rising_edge(adc_clk_i) then
		case state is
			
			--RESET/ IDLE CONDITION
			when S_IDLE =>
				LFSR_reg <= Seed;
				Code_CNT <= (others => '0');
				if trig_i = '1' then
					state <= S_TX;
				end if;
			
			
			when S_TX =>
				if Code_CNT = Code_L then
					state <= S_WAIT;
				else
					Code_CNT <= Code_CNT + 1;	--INCREMENT COUNT BY ONE
					--HANDLE (GALOIS) LFSR
					for i in 0 to 14 loop
						LFSR_reg(i) <= lFSR_reg(i + 1) xor (Mask(i) and LFSR_reg(0));
					end loop;
						LFSR_reg(15) <= mask(15) and LFSR_reg(0);
				end if;
			
			--WAIT FOR TRIG TO RESET
			when S_WAIT =>
				if trig_i = '0' then
					state <= S_IDLE;
				end if;
			
			--HANDLE UNKNOWN VALUE
			when others =>
				state <= S_IDLE;
		end case;
	end if;
end process P_LFSR;


end Behavioral;
