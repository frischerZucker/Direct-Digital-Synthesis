library ieee;
use ieee.standard.all
use ieee.std_logic_1164.all;

entity dds is
	port( 	clk : in std_ulogic;						-- 50 MHz Clock des FPGAs
			f_sel : in std_ulogic_vector(9 downto 0);	-- 10 Bits der Schalter zur Frequenzauswahl
			pwm_out : out std_ulogic);					-- PWM-Ausgangssignal
end dds;

