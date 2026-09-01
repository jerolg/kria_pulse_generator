-- #########################################################################
-- #########################################################################
-- ###                                                                   ###
-- ###   Use of this code, whether in its current form or modified,      ###
-- ###   implies that you consent to the terms and conditions, namely:   ###
-- ###    - You acknowledge my contribution                              ###
-- ###    - This copyright notification remains intact                   ###
-- ###                                                                   ###
-- ###   Many thanks,                                                    ###
-- ###     Dr. Andrew W. Rose, Imperial College London, 2021-2022        ###
-- ###                                                                   ###
-- #########################################################################
-- #########################################################################

-- =================================================================================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.PkgPRNG32.ALL;

ENTITY Xoshiro32bit IS
  GENERIC( Debugging : BOOLEAN := FALSE );
  
  PORT( Clk  : IN STD_LOGIC ;
        Data : OUT STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        Pull : IN STD_LOGIC := '1';
        aresetn : IN STD_LOGIC := '0';
        ResetVal : IN STD_LOGIC_VECTOR( 127 DOWNTO 0 )
        );
END Xoshiro32bit;

ARCHITECTURE rtl OF Xoshiro32bit IS

  CONSTANT Seed : tArray( 0 TO 3 ) := (
                                         x"89ABCDEF",
                                         x"76543210",
                                         x"B4A59687",
                                         x"3C2D1E0F");  
    
  SIGNAL s : tArray( 0 TO 3 ) := Seed;
  SIGNAL t : tArray( 0 TO 2 ) := ( OTHERS => (OTHERS => '0') );
  
  SIGNAL ResetVal_int : tArray( 0 TO 3 );
  CONSTANT ZERO128 : STD_LOGIC_VECTOR(127 DOWNTO 0) := (OTHERS => '0');
  
BEGIN
    
    ResetVal_int(0) <= SIGNED(ResetVal(127 DOWNTO 96));
    ResetVal_int(1) <= SIGNED(ResetVal(95 DOWNTO 64));
    ResetVal_int(2) <= SIGNED(ResetVal(63 DOWNTO 32));
    ResetVal_int(3) <= SIGNED(ResetVal(31 DOWNTO 0));
  
    PROCESS( Clk ) BEGIN
      IF RISING_EDGE( Clk ) THEN
        IF aresetn = '0' THEN
          IF ResetVal = ZERO128 THEN
              s <= Seed;
          ELSE
              s <= ResetVal_int;
          END IF;
          t <= ( OTHERS => (OTHERS => '0') );
        ELSIF Pull = '1' THEN
          Xoshiro( s );
          StarStarScrambler( s( 1 ) , t );
          Debug( Debugging , t( 2 ) );
        END IF;
      END IF;
    END PROCESS;    
    Data <= STD_LOGIC_VECTOR( t(2) );
END ARCHITECTURE rtl;
-- =================================================================================================================================