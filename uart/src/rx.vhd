library ieee;
use ieee.std_logic_1164.all;

entity rx is 
  port(
    rxLine        : in std_logic;
    bytesReceived : out std_logic_vector(7 downto 0);
    baudIn        : in std_logic
  );
end entity rx;

architecture rtl of rx is
  type receiveState is (idle, startBit, data, stopBit);
  signal currentState : receiveState := idle;
  signal byteBuffer   : std_logic_vector(7 downto 0);
begin

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
          if rxLine = '0' then 
            currentState <= data;
          end if;

      end case;
    end if;
  end process checkForMessage;

end architecture rtl;