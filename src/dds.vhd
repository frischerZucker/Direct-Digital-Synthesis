library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.coef_table_package.all;

entity dds is
	port( 	clk : in std_ulogic;				-- 50 MHz Clock des FPGAs
			f_sel : in integer range 0 to 1023;	-- 10 Bits der Schalter zur Frequenzauswahl
			pwm_out : out std_ulogic);			-- PWM-Ausgangssignal
end dds;

-- Register-Transfer-Ebense --------------------------------------------------------------------------------

architecture rt of dds is

signal f_ref : std_ulogic;					-- Referenzfrequenz mit 48.828 kHz -> Takt f�r Phasenakkumulator
signal phase : integer range 0 to 4095;		-- aktuelle Phase -> Index f�r Koeffiziententabelle

component taktteiler
	port(	clk: in std_ulogic;		-- clk mit 50 MHz
			f_ref: out std_ulogic);	-- Referenzfrequenz mit 48.828 KHz (^= 50 MHz / 1023)
end component;

component phasenakkumulator
	port(	f_ref : in std_ulogic;						-- Referenzfrequenz mit 48.828 kHz
			f_sel : in integer range 0 to 1023;			-- Frequenzauswahl
			phase_in : in integer range 0 to 4095;		-- Phaseneingang (alte Phase)
			phase_out : out integer range 0 to 4095);	-- Phasenausgang -> phase_in + f_sel (neue Phase)
end component;

component pwm_generator
	port( 	clk : in std_ulogic;					-- 50 MHz Clock des FPGAs
			phase : in integer range 0 to 4095;		-- aktuelle Phase -> Index f�r Koeffiziententabelle
			pwm_out : out std_ulogic);				-- PWM-Ausgangssignal
end component;

begin
-- Erzeugt f_ref aus clk.
taktt : taktteiler port map(clk, f_ref);
-- Berechnet die Phase in jedem Taktschritt von f_ref.
phaseakk : phasenakkumulator port map(f_ref, f_sel, phase, phase);
-- Generiert PWM-Signal, das den Sinus ergibt.
pwm : pwm_generator port map(clk, phase, pwm_out);

end rt;