library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity signal_send is
    generic (
        DAC_WIDTH    : integer := 14;
        PULSE_SAMPLES: integer := 512
    );
    port (
        clk          : in  std_logic;
        aresetn      : in  std_logic;
        
        -- ==========================================
        -- Interfaz con el Pile-Up Manager
        -- ==========================================
        trigger      : in  std_logic;  -- Conectar a trig_ch1 o trig_ch2
        busy         : out std_logic;  -- Conectar a busy_ch1 o busy_ch2
        data_in      : in std_logic_vector((DAC_WIDTH*PULSE_SAMPLES)-1 downto 0); -- Conectar a data_out
        data_valid   : in  std_logic;  -- Para saber si la BRAM se está actualizando (opcional)
        
        -- ==========================================
        -- Control de Amplitud (Energía del evento)
        -- ==========================================
        amplitude    : in  std_logic_vector(31 downto 0);
        
        -- ==========================================
        -- Salida (Va hacia el Sumador de Pile-Up)
        -- ==========================================
        data_out      : out std_logic_vector(DAC_WIDTH-1 downto 0)
    );
end signal_send;

architecture Behavioral of signal_send is

    signal sample_cnt  : integer range 0 to PULSE_SAMPLES := 0;
    signal is_sending  : std_logic := '0';
    
    -- Señal intermedia para ver el dato extraído claramente
    --signal current_sample : unsigned(DAC_WIDTH-1 downto 0);

    -- Pipeline de latencia
    signal valid_q1    : std_logic := '0';
    --signal valid_q2    : std_logic := '0';
    signal mult_result : unsigned((2*DAC_WIDTH)-1 downto 0) := (others => '0');

begin

    -- La señal busy indica al Manager que no nos envíe más triggers
    busy <= is_sending;

    process(clk)
    begin
        if rising_edge(clk) then
            if aresetn = '0' then
                sample_cnt <= 0;
                is_sending <= '0';
                valid_q1   <= '0';
                --valid_q2   <= '0';
                data_out    <= (others => '0');
                mult_result <= (others => '0');
            else
                -- Desplazamiento del pipeline de validez
                --valid_q1 <= is_sending;
                --valid_q2 <= valid_q1;

                -- =========================================================
                -- 1. Control del Envío (Lógica de Disparo y Contador)
                -- =========================================================
                -- Solo aceptamos un trigger si no estamos enviando nada
                -- y si el Manager nos dice que los datos son válidos (no se están actualizando)
                if trigger = '1' and is_sending = '0' and data_valid = '1' then
                    is_sending <= '1';
                    sample_cnt <= 0;
                elsif is_sending = '1' then
                
                    if sample_cnt < PULSE_SAMPLES - 1 then
                        sample_cnt <= sample_cnt + 1;
                    else
                        is_sending <= '0'; -- Terminamos de enviar el pulso
                    end if;
                    
                end if;

                valid_q1 <= is_sending;
                -- =========================================================
                -- 2. ETAPA 1 DEL PIPELINE: Extracción y Multiplicación
                -- =========================================================
                if is_sending = '1' then
                    -- EXTRACCIÓN (Slicing): Hacemos la matemática inversa del Manager
                    --current_sample <= unsigned(data_in( ((sample_cnt + 1) * DAC_WIDTH) - 1 downto (sample_cnt * DAC_WIDTH) ));
                    
                    -- MULTIPLICACIÓN
                    --mult_result <= current_sample * unsigned(amplitude(DAC_WIDTH-1 downto 0));
                    
                    mult_result <= unsigned(data_in( ((sample_cnt + 1) * DAC_WIDTH) - 1 downto (sample_cnt * DAC_WIDTH) )) 
                                 * unsigned(amplitude(DAC_WIDTH-1 downto 0));
                                 
                --else
                    --mult_result <= (others => '0');
                end if;

                -- =========================================================
                -- 3. ETAPA 2 DEL PIPELINE: Truncamiento / Atenuación
                -- =========================================================
                if valid_q1 = '1' then
                    -- Tomamos los 14 bits superiores (Atenuador fraccionario) como tenías originalmente
                    data_out <= std_logic_vector(mult_result((2*DAC_WIDTH)-1 downto DAC_WIDTH));
                else
                    data_out <= (others => '0');
                end if;

            end if;
        end if;
    end process;

end Behavioral;