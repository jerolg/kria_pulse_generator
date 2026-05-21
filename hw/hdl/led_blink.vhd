library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity  led_blink is
    Port (
        clk : in  std_logic;
        led : out std_logic
    );
end led_blink;

architecture Behavioral of led_blink is

    -- 50 MHz ? 50,000,000 ciclos por segundo
    -- Para medio segundo:
    -- 50,000,000 / 2 = 25,000,000
    constant MAX_COUNT : unsigned(24 downto 0) := to_unsigned(24999999,25);

    signal counter : unsigned(24 downto 0) := (others => '0');
    signal led_reg : std_logic := '0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if counter = MAX_COUNT then
                counter <= (others => '0');
                led_reg <= not led_reg;  -- Toggle
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    led <= led_reg;

end Behavioral;
