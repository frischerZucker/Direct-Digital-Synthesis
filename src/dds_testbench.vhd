library ieee;
use ieee.std_logic_1164.all;

entity dds_testbench is
end dds_testbench;

architecture algorithmisch of dds_testbench is

signal T_clk : std_ulogic := '0';
signal T_pwm_out : std_ulogic := '0';
signal T_f_sel : integer range 0 to 1023 := 1;

begin

dut: entity work.dds(algorithmisch) port map(T_clk, T_f_sel, T_pwm_out);

clock_gen: process
begin
	T_clk <= '1';
	wait for 10 ns;
	T_clk <= '0';
	wait for 10 ns;
end process clock_gen;

stop_simulation: process
begin
	wait for 819200000 ns;
	assert (true = false) report "Simulation beendet." severity failure;
end process stop_simulation;

end algorithmisch;
