--						Transus Instruments
--
--MODULE FOR WRITING "AGC" VALUES TO DIGITAL POTENTIOMETERS TO SET TRANSIMPEDANCE GAIN.
--
--
--THE MODULE HAS TWO STATES, IDLE AND S_WRITE:
--		-IDLE: DEFAULT STATE, RESETS THE SIGNALS
--		-S_WRITE: WRITES A SINGLE SPI PACKAGE
--
--PLEASE REFER TO DOCUMENTATION: LPM FPGA DESIGN DOC


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--ENTITY
entity AGC_mod is
	port 	(	clk_i: in std_logic;															--INPUTS
				rst_i: in std_logic;
				trig_i: in std_logic;
				AGC_set_val_i: in std_logic_vector(7 downto 0);
			
				AQ_DAC_CS_o: out std_logic;													--OUTPUTS
				AQ_DAC_SCK_o: out std_logic;
				AQ_DAC_SDO_o: out std_logic);
end AGC_mod;



--ARCHITECTURE
architecture Behavioral of AGC_mod is

--SIGNALS AND STATES
type t_state is (IDLE, S_WRITE);
signal state: t_state;
signal AGC_set_val: std_logic_vector(9 downto 0);
signal edge_cnt: std_logic_vector(3 downto 0);

begin

--ASYNC PROCESSES
AQ_DAC_SCK_o <= (NOT clk_i) when state = S_WRITE else '0';
AQ_DAC_CS_o <= '0' when state = S_WRITE else '1';
AQ_DAC_SDO_o <= AGC_set_val(to_integer(unsigned(edge_cnt))) when state = S_WRITE else '0';


FSM: process(clk_i, rst_i) begin
if rst_i = '1' then
	state <= IDLE;		
elsif rising_edge(clk_i) then
	case state is
		
		--IDLE STATE/ RESET VALUE
		when IDLE =>
			edge_cnt <= (x"9");
			if trig_i = '1' then
				state <= S_WRITE;
				AGC_set_val <= ("00" & AGC_set_val_i);
			end if;
			
		--SPI WRITE STATE
		when S_WRITE =>
			if edge_cnt = x"0" then
				state <= IDLE;
			else
				edge_cnt <= edge_cnt - 1;
			end if;
			
		--HANDLE UNKNOWN VALUES
		when others =>
			state <= IDLE;
	end case;
end if;
end process FSM;
	
end Behavioral;