library ieee;
use ieee.std_logic_1164.all;

entity uart is 
  generic(
    systemClockFrequency : positive := 27e6;
    bauds : positive := 9600
  );
  port(
    tx : out std_logic;
    rx : in std_logic;
    dataIn : in std_logic_vector(7 downto 0);
    dataOut : out std_logic_vector(7 downto 0);
    systemClockIn : in std_logic;
    receiveError : out std_logic;
    loadTransmit : in std_logic
  );
end entity uart;

architecture rtl of uart is 
  signal clockDivOut : std_logic;
begin

  clockDivider : entity work.clockDivider(rtl)
  generic map(
    inputClockFrequency => systemClockFrequency,
    outputClockFrequency => bauds
  )
  port map(
    clockIn => systemClockIn,
    clockOut => clockDivOut
  );

  receiver : entity work.rx(rtl)
  port map(
    baudIn => clockDivOut,
    rxLine => rx,
    bytesReceived => dataOut,
    error => receiveError
  );

  transmitter : entity work.tx(rtl)
  port map(
    baudIn => clockDivOut,
    txLine => tx,
    parallelIn => dataIn,
    loadTransmit => loadTransmit
  );
end architecture rtl;