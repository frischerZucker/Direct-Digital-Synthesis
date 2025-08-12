library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.coef_table_package.all;

entity phasenakkumulator is
	port(	f_ref : in std_ulogic;
			f_sel : in integer range 0 to 1023;
			phase_in : in integer range 0 to 4095;
			phase_out : out integer range 0 to 4095);
end phasenakkumulator;

architecture rt of phasenakkumulator is

begin

-- Generierung des Phasenwerts
process(f_ref)
begin
	-- addiert einmal pro Periode von f_ref f_sel zur Phase
	if rising_edge(f_ref) then
		if (phase_in + f_sel < 4096) then
			phase_out <= phase_in + f_sel;
		else
			-- Überlauf wenn Maximum erreicht.
			phase_out <= phase_in + f_sel - 4096;
		end if;
	end if;
end process;

end rt;
