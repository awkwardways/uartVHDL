library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clockDivider is
  generic(
    inputClockFrequency : positive := 27e6;
    outputClockFrequency : positive := 9600
  );
  port(
    clockIn  : in std_logic;
    clockOut : out std_logic
  );
end entity clockDivider;

architecture rtl of clockDivider is
  constant countLimit : integer := integer(floor(real(inputClockFrequency) / (2.0 * real(outputClockFrequency))));
  signal count : natural := 1;
  signal clkOut : std_logic := '0';
begin 
  divideClock : process(clockIn)
  begin
    if rising_edge(clockIn) then
      if count = countLimit then
        count <= 1;
        clkOut <= not clkOut;
      else
        count <= count + 1;
      end if;
    end if;
    clockOut <= clkOut;
  end process divideClock;
end architecture rtl;