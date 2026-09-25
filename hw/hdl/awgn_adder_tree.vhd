library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- ============================================================================
-- Módulo: awgn_adder_tree
-- Descripción: 
-- Implementa un generador de ruido AWGN basado en la distribución de Irwin-Hall.
-- Toma 8 variables uniformes de 8 bits (64 bits en total), las suma mediante
-- un árbol segmentado (pipeline) y resta la media teórica para entregar una
-- señal de ruido gaussiano centrada en cero.
-- ============================================================================

entity awgn_adder_tree is
    port(
        unif_in : in STD_LOGIC_VECTOR(63 downto 0);
        awgn_out: out SIGNED(15 downto 0)
        );
 end awgn_adder_tree;

architecture Behavioral of awgn_adder_tree is
    
    -- Sum of 8 bytes: 0 ... 2040
    signal byte_sum : unsigned(10 downto 0);

    -- Centered sum: -1020 ... +1020
    signal centered : signed(11 downto 0);

    -- Intermediate multiplication
    signal scaled : signed(23 downto 0);


begin

    ------------------------------------------------------------
    -- Sum eight 8-bit uniform variables
    ------------------------------------------------------------

    byte_sum <=
        resize(unsigned(unif_in( 7 downto  0)), 11) +
        resize(unsigned(unif_in(15 downto  8)), 11) +
        resize(unsigned(unif_in(23 downto 16)), 11) +
        resize(unsigned(unif_in(31 downto 24)), 11) +
        resize(unsigned(unif_in(39 downto 32)), 11) +
        resize(unsigned(unif_in(47 downto 40)), 11) +
        resize(unsigned(unif_in(55 downto 48)), 11) +
        resize(unsigned(unif_in(63 downto 56)), 11);
        
    ------------------------------------------------------------
    -- Center around zero
    --
    -- centered = S - 1020
    ------------------------------------------------------------
     
     centered <= signed(resize(byte_sum, 12)) - 1020;
     
      ------------------------------------------------------------
    -- Normalize
    --
    -- Z = centered / sigma
    --
    -- sigma ≈ 208.72
    --
    -- Q4.12:
    --
    -- Z_Q = Z * 4096
    --
    -- approximately:
    --
    -- Z_Q = centered * 20
    --
    ------------------------------------------------------------

    scaled <= centered * 20;
    
    ------------------------------------------------------------
    -- Convert to Q4.12
    --
    -- Divide by 4096 = arithmetic right shift 12
    ------------------------------------------------------------

    awgn_out <= resize(shift_right(scaled, 12),16);
    
end architecture;