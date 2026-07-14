library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dac_ramp is
    Port (
        clk      : in  std_logic;
        dac_data : out std_logic_vector(13 downto 0)
    );
end dac_ramp;

architecture Behavioral of dac_ramp is

    signal counter : signed(13 downto 0) := to_signed(-8192,14);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if counter = to_signed(8191,14) then
                counter <= to_signed(-8192,14);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    dac_data <= std_logic_vector(counter);

end Behavioral;
