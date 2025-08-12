library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.coef_table_package.all;

entity taktteiler is
	port(	clk: in std_ulogic;
			f_ref: out std_ulogic);
end taktteiler;

architecture rt of taktteiler is
signal c: integer range 0 to 1023 := 0;
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

end rt;
