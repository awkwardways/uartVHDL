library ieee;
use ieee.std_logic_1164.all;

entity rx is 
  generic(
    systemClockFrequency : positive := 27e6;
    bauds : integer := 9600
  );
  port(
    systemClockIn : in std_logic;
    rxLine        : in std_logic;
    bytesReceived : out std_logic_vector(7 downto 0);
    error         : out std_logic := '0'
  );
end entity rx;

architecture rtl of rx is
  type receiveState is (idle, startBit, data, stopBit);
  signal currentState : receiveState := idle;
  signal baudIn       : std_logic;
  signal byteBuffer   : std_logic_vector(7 downto 0);
begin

  baudGenerator: entity work.clockDivider(rtl)
  generic map(
    inputClockFrequency => systemClockFrequency,
    outputClockFrequency => bauds
  )
  port map(
    clockIn => systemClockIn,
    clockOut => baudIn
  );


  checkForMessage: process(baudIn)
    variable currentBit : integer := 0;
  begin
    if rising_edge(baudIn) then
      case currentState is
        when idle =>
          if rxLine = '0' then
            currentState <= data;
          end if;
        
        when data => 
          if currentBit = 8 then
            currentState <= stopBit;
            currentBit := 0;
            bytesReceived <= byteBuffer;
          else
            byteBuffer(currentBit) <= rxLine;
            currentBit := currentBit + 1;
          end if;

        when stopBit =>
          currentState <= idle;
          if rxLine = '1' then
            error <= '0';
          else
            error <= '1';
          end if;

      end case;
    end if;
  end process checkForMessage;

end architecture rtl;