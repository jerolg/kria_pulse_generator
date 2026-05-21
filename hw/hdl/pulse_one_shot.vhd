----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2026 14:01:18
-- Design Name: 
-- Module Name: pulse_one_shot - Behavioral
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

entity pulse_one_shot is
    Port (
        clk       : in  std_logic;
        aresetn   : in  std_logic;
        signal_in : in  std_logic;
        pulse_out : out std_logic
    );
end pulse_one_shot;

architecture Behavioral of pulse_one_shot is
    signal signal_d : std_logic := '0';
begin

process(clk)
begin
    if rising_edge(clk) then
        if aresetn = '0' then
            signal_d <= '0';
            pulse_out <= '0';
        else
            pulse_out <= signal_in and not signal_d;
            signal_d <= signal_in;
        end if;
    end if;
end process;

end Behavioral;