library ieee;
use ieee.std_logic_1164.all;

entity dds_testbench is
end dds_testbench;

architecture algorithmisch of dds_testbench is

signal T_clk : std_ulogic := '0';
signal T_pwm_out : std_ulogic := '0';
signal T_f_sel : integer range 0 to 1023 := 0;

begin
-- Instanz des zu testenden Modells erzeugen.
dut: entity work.dds(algorithmisch) port map(T_clk, T_f_sel, T_pwm_out);

-- Stellt die jeweiligen Use-Cases ein.
tests : process
begin
    report "Use-Case #1: maximale Frequenz" severity note;
    T_f_sel <= 1023;
    wait for 81920 ns;

    report "Use-Case #2: niedrigere Frequenz" severity note;
    T_f_sel <= 512;
    wait for 163840 ns;

    report "Use-Case #3: niedrigste Frequenz" severity note;
    T_f_sel <= 1;
    wait for 83886080 ns;

    assert (true = false) report "Alle Use-Cases abgeschlossen." severity failure;
end process tests;

end algorithmisch;

architecture rtl of dds_testbench is

signal T_clk : std_ulogic := '0';
signal T_pwm_out : std_ulogic := '0';
signal T_pwm_out_golden_model : std_ulogic := '0';
signal T_f_sel : integer range 0 to 1023 := 0;
signal assert_count : integer := 0;

begin
-- Instanz des zu Golden Models erzeugen.
golden_model: entity work.dds(algorithmisch) port map(T_clk, T_f_sel, T_pwm_out_golden_model);
-- Instanz des zu testenden Modells erzeugen.
dut: entity work.dds(rt) port map(T_clk, T_f_sel, T_pwm_out);

-- Generierung der Clock mit 50 MHz.
clk_gen: process
begin
	T_clk <= '0';
	wait for 10 ns;
	T_clk <= '1';
	wait for 10 ns;
end process clk_gen;

-- Stellt die jeweiligen Use-Cases ein.
use_cases : process
begin
    report "Use-Case #1: maximale Frequenz" severity note;
    T_f_sel <= 1023;
    wait for 81920 ns;

    report "Use-Case #2: niedrigere Frequenz" severity note;
    T_f_sel <= 512;
    wait for 163840 ns;

    report "Use-Case #3: niedrigste Frequenz" severity note;
    T_f_sel <= 1;
    wait for 83886080 ns;

	report "Anzahl Clockzyklen, in denen die Modelle nicht übereingestimmt haben: " & integer'image(assert_count);
    assert (true = false) report "Alle Use-Cases abgeschlossen." severity failure;
end process use_cases;

-- Testet (1x pro Taktzyklus) ob Golden Model und DUT die gleichen Ausgangssignale erzeugen.
tests: process
begin
	if not (T_pwm_out = T_pwm_out_golden_model) then
            assert false report "Modelle stimmen nicht überein!" severity warning;
            assert_count <= assert_count + 1; -- Zählt die Fehler.
    end if;
	wait for 20 ns;
end process tests;

end rtl;
