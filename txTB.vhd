library ieee;
use ieee.std_logic_1164.all;

entity txTB is
end entity txTB;

architecture sim of txTB is
  constant tb_systemClockFrequency : integer := 50e6;
  constant tb_bauds : positive := 9600;
  signal tb_systemClock : std_logic := '0';
  signal tb_txLine : std_logic;
  signal tb_parallelIn : std_logic_vector(7 downto 0);
  signal tb_loadTransmit : std_logic;
begin

  UUT : entity work.tx(rtl)
  generic map(
    systemClockFrequency => tb_systemClockFrequency,
    bauds => tb_bauds
  )
  port map(
    systemClockIn => tb_systemClock,
    txLine => tb_txLine,
    parallelIn => tb_parallelIn,
    loadTransmit => tb_loadTransmit
  );

  tb_systemClock <= not tb_systemClock after (500 ms / tb_systemClockFrequency);

  stimulus: process 
  begin
    tb_parallelIn <= x"a7";
    tb_loadTransmit <= '0';
    wait for (500 ms / tb_systemClockFrequency);
    tb_loadTransmit <= '1';
    wait for (104201 ns);
    tb_loadTransmit <= '0';
    wait;
  end process;

end architecture;