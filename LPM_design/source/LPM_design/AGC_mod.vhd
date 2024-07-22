--						Transus Instruments
--
--Module for writing AGC values through a spi interface to the digital potentiometer varies 
--the gain of the variable (input) amplifier.
--
--More information in documentation.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity AGC_mod is
	port 	(	clk_i: in std_logic;									--INPUTS
				rst_i: in std_logic;
				trig_i: in std_logic;
				AGC_set_val_i: in std_logic_vector(7 downto 0);
			
				AQ_DAC_CS_o: out std_logic;							--OUTPUTS
				AQ_DAC_SCK_o: out std_logic;
				AQ_DAC_SDO_o: out std_logic);
end AGC_mod;



architecture Behavioral of AGC_mod is
type t_state is (IDLE, S_WRITE);										--DECLARARION OF SIGNALS AND STATES
signal state: t_state;
signal AGC_set_val: std_logic_vector(7 downto 0);

begin

--INSERT ASYNC LOGIC

FSM: process(clk_i, rst_i) begin
if rst_i = '1' then
	state <= IDLE;
elsif rising_edge(clk_i) then
	case state is
		when IDLE =>													--HANDLE IDLE CONDITION
			AQ_DAC_SCK_o <= '0';
			AQ_DAC_SDO_o <= '0';
			if trig_i = '1' then
				state <= S_WRITE;
			end if;
		when S_WRITE =>													--WRITE SPI DATA
			--INSERT THE LOGIC FOR SENDING DATA
		when others =>
			state <= IDLE;
	end case;
end if;
end process FSM;
	
end Behavioral;