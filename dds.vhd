library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.coef_table_package.all;

entity dds is
	port( 	clk : in std_ulogic;						-- 50 MHz Clock des FPGAs
			f_sel : in std_ulogic_vector(9 downto 0);	-- 10 Bits der Schalter zur Frequenzauswahl
			pwm_out : out std_ulogic);					-- PWM-Ausgangssignal
end dds;


architecture algorithmisch of dds is

signal f_ref : std_ulogic;					-- Referenzfrequenz mit 48.828 kHz -> Takt für Phasenakkumulator
signal phase : integer range 0 to 4095;		-- aktuelle Phase -> Index für Koeffiziententabelle
signal coef_table : coef_table_t;			-- Koeffizienten der Funktion
signal coef : integer range 0 to 1023;		-- Koeffizient der Funktion aus Koeffiziententabelle
signal c : integer range 0 to 1023 := 0;	-- Zähler des Taktteilers für f_ref
signal pwm_counter : integer := 0;			-- zählt wie viel Takte in aktueller Periode vergangen sind

begin
-- Generierung der Referenzfrequenz mit 48.828 kHz
f_ref_generierung: process(clk)
begin
	if rising_edge(clk) then
		-- jeden 1023ten Takt f_ref für einen Takt auf high -> f_ref mit 50 MHz / 1023 = 48.828 kHz
		if (c = 1023) then
			c <= 0;
			f_ref <= '1';
		else
			c <= c + 1;
			f_ref <= '0';
		end if;
	end if;
end process f_ref_generierung;

-- Generierung des Phasenwerts
phasenakkumulator: process(f_ref)
begin
	-- addiert einmal pro Periode von f_ref f_sel zur Phase
	if rising_edge(f_ref) then
		phase <= phase + to_integer(signed(f_sel));
	end if;
end process phasenakkumulator;

-- Generierung des PWM-Signals aus Koeffizienten
pwm_generierung: process(clk)
begin
	if rising_edge(clk) then
		-- neue Periode beginnt wenn f_ref auslöst -> Zähler zurücksetzen
		if rising_edge(f_ref) then
			pwm_counter <= 0;
			coef <= coef_table(phase);
		end if;
		-- die ersten coef Takte ist der PWM-Ausgang auf high, danach auf low
		if (pwm_counter <= coef) then
			pwm_out <= '1';
		else
			pwm_out <= '0';
		end if;
		pwm_counter <= pwm_counter + 1;
	end if;
end process pwm_generierung;

end algorithmisch;
