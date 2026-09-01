library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================================
-- Module: rand_to_channel
--
-- Description:
-- Converts a uniformly distributed random number into a BRAM byte address
-- corresponding to a channel index within a configurable lookup table.
--
-- The scaling operation:
--
--      channel_index = floor((rand_in * addr_lim) / 2^RAND_WIDTH)
--
-- maps the random input range:
--
--      [0, 2^RAND_WIDTH - 1]
--
-- into:
--
--      [0, addr_lim - 1]
--
-- The resulting channel index is then multiplied by 4 (shift left by 2)
-- to generate a byte-addressed BRAM location, assuming each BRAM entry
-- occupies 32 bits (4 bytes).
--
-- This module is useful for random sampling from a lookup table (LUT),
-- such as inverse transform sampling for arbitrary probability distributions.
-- ============================================================================

entity rand_to_channel is
    generic (
        -- Width of the random input and address limit signals
        RAND_WIDTH : integer := 32
    );
    port (
        -- System clock
        clk      : in  std_logic;

        -- Uniform random input value
        rand_in  : in  std_logic_vector(RAND_WIDTH-1 downto 0);

        -- Address limit (typically LUT size or number of valid entries)
        addr_lim : in  std_logic_vector(RAND_WIDTH-1 downto 0);

        -- Event trigger: when asserted, generate a new channel address
        ev_flag  : in  std_logic;

        -- Output BRAM byte address corresponding to selected channel
        chan_out : out std_logic_vector(RAND_WIDTH-1 downto 0);

        -- BRAM enable signal
        bram_en  : out std_logic;
        bram_rst : out std_logic;

        -- BRAM clock output (direct copy of system clock)
        bram_clk : out std_logic
    );
end rand_to_channel;

architecture Behavioral of rand_to_channel is

  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO of bram_en: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT EN";
  --ATTRIBUTE X_INTERFACE_INFO of bram_dout: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT DOUT";
  --ATTRIBUTE X_INTERFACE_INFO of bram_din: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT DIN";
  --ATTRIBUTE X_INTERFACE_INFO of <s_we>: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT WE";
  ATTRIBUTE X_INTERFACE_INFO of chan_out: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT ADDR";
  ATTRIBUTE X_INTERFACE_INFO of bram_clk: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT CLK";
  ATTRIBUTE X_INTERFACE_INFO of bram_rst: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT RST";
    -- Stores the full multiplication result:
    -- RAND_WIDTH bits × RAND_WIDTH bits = 2*RAND_WIDTH bits
    signal mult_result : unsigned((2 * RAND_WIDTH) - 1 downto 0);

begin

    -- Forward system clock directly to BRAM
    bram_clk <= clk;
    bram_rst <= '0';

    process(clk)
    begin
        if rising_edge(clk) then

            -- Generate a new channel only when an event occurs
            if ev_flag = '1' then

                -- Scale the random value to the valid LUT range.
                -- Vivado typically maps this multiplication to DSP hardware.
                mult_result <= unsigned(rand_in) * unsigned(addr_lim);

                -- Take the upper RAND_WIDTH bits of the product.
                -- This is equivalent to dividing by 2^RAND_WIDTH:
                --
                --   floor((rand_in * addr_lim) / 2^RAND_WIDTH)
                --
                -- yielding a uniformly distributed integer in:
                --
                --   [0, addr_lim - 1]
                --
                -- Then shift left by 2 bits (×4) to convert the
                -- channel index into a byte address for 32-bit BRAM entries.
                chan_out <= std_logic_vector(
                                shift_left(mult_result(63 downto 32), 2)
                            );

                -- Enable BRAM access
                bram_en <= '1';

            else
                -- Disable BRAM when no event is present
                bram_en <= '0';

                -- chan_out is intentionally left unchanged to avoid
                -- unnecessary switching activity
            end if;
        end if;
    end process;

end Behavioral;