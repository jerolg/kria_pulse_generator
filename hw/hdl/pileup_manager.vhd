library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pileup_manager is
    generic (
        DAC_WIDTH    : integer := 14;
        PULSE_SAMPLES: integer := 512 
    );
    port (
        clk           : in  std_logic;
        rst_n         : in  std_logic;

        -- ==========================================
        -- NUEVO: Señal de actualización desde AXI GPIO
        -- ==========================================
        update_trigger: in  std_logic; 

        -- ==========================================
        -- Interfaz de Ruteo de Triggers
        -- ==========================================
        pulse_trig_in : in  std_logic;
        busy_ch1      : in  std_logic;
        busy_ch2      : in  std_logic;
        busy_ch3      : in  std_logic;
        trig_ch1      : out std_logic;
        trig_ch2      : out std_logic;
        trig_ch3      : out std_logic;

        -- ==========================================
        -- Interfaz BRAM 
        -- ==========================================
        bram_clk     : out std_logic;
        bram_rst     : out std_logic;
        bram_addr     : out std_logic_vector(31 downto 0);
        bram_dout     : in  std_logic_vector(31 downto 0);
        bram_en       : out std_logic;
        -- Ya no necesitamos bram_din ni bram_we porque solo vamos a leer
        
        -- ==========================================
        -- Arreglo compartido de solo lectura
        -- ==========================================
        data_out      : out std_logic_vector((DAC_WIDTH*PULSE_SAMPLES)-1 downto 0);
        --shared_data   : out data_array_t;
        data_valid    : out std_logic 
    );
end pileup_manager;

architecture Behavioral of pileup_manager is

    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of bram_en: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT EN";
    ATTRIBUTE X_INTERFACE_INFO of bram_dout: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT DOUT";
    --ATTRIBUTE X_INTERFACE_INFO of bram_din: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT DIN";
    --ATTRIBUTE X_INTERFACE_INFO of <s_we>: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT WE";
    ATTRIBUTE X_INTERFACE_INFO of bram_addr: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT ADDR";
    ATTRIBUTE X_INTERFACE_INFO of bram_clk: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT CLK";
    ATTRIBUTE X_INTERFACE_INFO of bram_rst: SIGNAL is "xilinx.com:interface:bram:1.0 BRAM_PORT RST";

    -- FSM simplificada (ya no hay POLL ni CLEAR_FLAG)
    type state_type is (IDLE, READ_DATA, WAIT_DATA, SAVE_DATA);
    signal state : state_type := IDLE;

    signal data_index     : integer range 0 to PULSE_SAMPLES := 0;
    --signal internal_array : data_array_t := (others => (others => '0'));
    signal data_reg       : std_logic_vector((DAC_WIDTH*PULSE_SAMPLES)-1 downto 0) := (others => '0');

    -- Señales para el detector de flanco de subida
    signal trigger_q : std_logic := '0';
    signal trigger_edge : std_logic;

begin
    
    bram_rst  <= '0';
    bram_clk <= clk; 

    --shared_data <= internal_array;

    -- Detector de flanco de subida: '1' solo durante 1 ciclo de reloj
    trigger_edge <= update_trigger and not trigger_q;
    data_out <= data_reg;

    -- =========================================================
    -- PROCESO 1: Enrutador de Eventos (Dispatcher)
    -- =========================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                trig_ch1 <= '0';
                trig_ch2 <= '0';
                trig_ch3 <= '0';
            else
                -- Por defecto, los triggers duran 1 solo ciclo de reloj
                trig_ch1 <= '0';
                trig_ch2 <= '0';
                trig_ch3 <= '0';

                if pulse_trig_in = '1' then
                    -- Prioridad: Se asigna al primero que esté libre
                    if busy_ch1 = '0' then
                        trig_ch1 <= '1';
                    elsif busy_ch2 = '0' then
                        trig_ch2 <= '1';
                    elsif busy_ch3 = '0' then
                        trig_ch3 <= '1';
                    end if;
                    -- Si ambos están ocupados ('1'), el evento se ignora (se pierde).
                end if;
            end if;
        end if;
    end process;

    -- =========================================================
    -- PROCESO 2: Máquina de Estados de la BRAM (Por Trigger)
    -- =========================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if rst_n = '0' then
                state      <= IDLE;
                bram_en    <= '0';
                bram_addr  <= (others => '0');
                data_valid <= '0';
                trigger_q  <= '0';
                data_reg <= (others => '0');
            else
                -- Actualizamos el registro del detector de flanco
                trigger_q <= update_trigger;

                case state is
                    
                    -- 1. Esperamos dormidos a que llegue el pulso del PS
                    when IDLE =>
                        bram_en <= '0';
                        if trigger_edge = '1' then
                            data_index <= 0;
                            data_valid <= '0'; -- Arreglo en actualización
                            state      <= READ_DATA;
                        end if;

                    -- 2. Pedimos el dato a la BRAM
                    when READ_DATA =>
                        bram_en   <= '1';
                        bram_addr <= std_logic_vector(to_unsigned(data_index * 4, 32));
                        state     <= WAIT_DATA;

                    -- 3. Esperamos 1 ciclo de reloj (Latencia BRAM)
                    when WAIT_DATA =>
                        state <= SAVE_DATA;

                    -- 4. Guardamos en el Array
                    when SAVE_DATA =>
                        data_reg( ((data_index + 1) * DAC_WIDTH) - 1 downto (data_index * DAC_WIDTH) ) <= bram_dout(DAC_WIDTH-1 downto 0);
                        
                        if data_index = PULSE_SAMPLES - 1 then
                            bram_en    <= '0';
                            data_valid <= '1'; -- ¡Arreglo listo!
                            state      <= IDLE;
                        else
                            data_index <= data_index + 1;
                            state      <= READ_DATA;
                        end if;

                end case;
            end if;
        end if;
    end process;

end Behavioral;
