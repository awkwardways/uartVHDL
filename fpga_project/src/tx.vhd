library ieee;
use ieee.std_logic_1164.all;

entity tx is 
  generic(
    systemClockFrequency : positive := 50e6;
    bauds : positive := 9600
  );
  port(
    systemClockIn : in std_logic;
    txLine        : out std_logic := '1';
    parallelIn    : in std_logic_vector(7 downto 0);
    baudOut       : out std_logic;
    loadTransmit  : in std_logic
  );
end entity tx;

architecture rtl of tx is 
  type transmissionState is (idle, startBit, stopBit, data);
  signal currentState : transmissionState := idle;
  signal baudIn       : std_logic;
  signal byteBuffer   : std_logic_vector(7 downto 0);
begin

  baudGenerator: entity work.clockDivider(rtl)
  generic map(
    inputClockFrequency  => systemClockFrequency,
    outputClockFrequency => bauds
  )
  port map(
    clockIn => systemClockIn,
    clockOut => baudIn
  );

  loadByte: process(systemClockIn)
  begin
    if rising_edge(systemClockIn) then
      if loadTransmit = '0' then
        byteBuffer <= parallelIn;
      end if;
    end if;
  end process loadByte;
  
  baudOut <= baudIn;

  transmitByte: process(baudIn)
    variable isTransmitting : std_logic := '0';
    variable currentBit : natural := 0; 
  begin
    if rising_edge(baudIn) then

      if loadTransmit = '1' then
        isTransmitting := '1';
      end if;

      case currentState is
        when idle =>
          txLine <= not isTransmitting;
          currentState <= startBit;
          if isTransmitting = '0' then
            currentState <= idle;
          end if;
        
        when startBit =>
          currentState <= data;
          txLine <= byteBuffer(currentBit);
          currentBit := currentBit + 1;
        
        when data =>
          if currentBit = 8 then
            currentState <= stopBit;
            currentBit := 0;
          end if;
          txLine <= byteBuffer(currentBit);
          currentBit := currentBit + 1;
        
        when stopBit =>
          txLine <= '1';
          currentState <= idle;
          isTransmitting := '0';
      end case;
    end if;
  end process;

end architecture;