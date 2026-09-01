----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2026 16:50:57
-- Design Name: 
-- Module Name: pileup_adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pileup_adder is
    generic (
        DAC_WIDTH : integer := 14
    );
    port (
        clk           : in  std_logic;
        rst_n         : in  std_logic;
        
        -- Entradas desde los canales
        ch1_in        : in  std_logic_vector(DAC_WIDTH-1 downto 0);
        ch2_in        : in  std_logic_vector(DAC_WIDTH-1 downto 0);
        ch3_in        : in  std_logic_vector(DAC_WIDTH-1 downto 0);
        
        -- Salida final hacia el DAC físico
        dac_out : out std_logic_vector(DAC_WIDTH-1 downto 0)
    );
end pileup_adder;

architecture Behavioral of pileup_adder is

    -- Usamos 1 bit extra (DAC_WIDTH + 1) para atrapar el desbordamiento sin perder información
    signal sum_result : unsigned(DAC_WIDTH + 1 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                sum_result    <= (others => '0');
                dac_out <= (others => '0');
            else
                -- 1. SUMA (Bit Growth): Redimensionamos a 15 bits antes de sumar
                sum_result <= resize(unsigned(ch1_in), DAC_WIDTH + 2) + 
                              resize(unsigned(ch2_in), DAC_WIDTH + 2) +
                              resize(unsigned(ch3_in), DAC_WIDTH + 2);

                -- 2. SATURACIÓN (Clipping): Evitamos que el DAC dé la vuelta a cero
                -- Si el bit 14 (el bit número 15) es '1', significa que el valor superó 16383
                if sum_result(DAC_WIDTH+1 downto DAC_WIDTH) /= "00" then
                    dac_out <= (others => '1'); -- Clavamos la salida en el máximo (16383)
                else
                    -- Si es seguro, tomamos los 14 bits originales
                    dac_out <= std_logic_vector(sum_result(DAC_WIDTH-1 downto 0));
                end if;
            end if;
        end if;
    end process;

end Behavioral;
