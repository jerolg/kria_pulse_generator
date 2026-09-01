----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2026 17:52:46
-- Design Name: 
-- Module Name: bernoulli_trial - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- DSSS
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bernoulli_trial is
    port(
        clk           : in  std_logic;
        aresetn       : in  std_logic; -- Reset activo en bajo (reinicia el contador)
        en            : in  std_logic; -- Habilitador (opcional, para pausar/reanudar)
        
        rnd           : in  unsigned(31 downto 0);
        prob_thr      : in  unsigned(31 downto 0);
        target_events : in  unsigned(31 downto 0); -- Cantidad 'X' de eventos deseados
        
        ev_flag       : out std_logic;
        done          : out std_logic  -- Se pone en '1' cuando se alcanzan los X eventos
    );
end entity;

architecture rtl of bernoulli_trial is

    -- Contador interno para llevar el registro de eventos generados
    signal event_count : unsigned(31 downto 0) := (others => '0');

begin

process(clk)
begin
     if rising_edge(clk) then
        if aresetn = '0' then
            -- Reiniciar todo
            event_count <= (others => '0');
            ev_flag     <= '0';
            done        <= '0';
        else
            -- Por defecto, la bandera de evento baja en el siguiente ciclo
            ev_flag <= '0'; 
            
            if en = '1' then
                -- Si aún no hemos llegado a la meta de eventos...
                if event_count < target_events then
                    done <= '0';
                    
                    -- Hacemos la prueba de Bernoulli
                    if rnd < prob_thr then
                        ev_flag     <= '1';
                        event_count <= event_count + 1; -- Incrementamos la cuenta
                    end if;
                else
                    -- Ya se produjeron exactamente X eventos
                    done <= '1';
                end if;
                
            else
                event_count <= (others => '0');
                ev_flag     <= '0';
                done        <= '0';
                
                
            end if;
        end if;
     end if;
end process;

end rtl;