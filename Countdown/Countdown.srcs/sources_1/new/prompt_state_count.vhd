----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 05:40:10
-- Design Name: 
-- Module Name: prompt_state_count - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity prompt_state_count is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           pulse_out : out STD_LOGIC);
end prompt_state_count;

architecture Behavioral of prompt_state_count is

SIGNAL COUNT : INTEGER := 0;
constant COUNT_MAX : integer := 300000000;

begin
    
    process(Reset, Clock)
        begin
            if Reset = '1' then
                COUNT <= 0;
                
            elsif(rising_edge(Clock)) then
                
                if COUNT = COUNT_MAX then
                    COUNT <= 0;
                    pulse_out <= '1';
                
                else
                    COUNT <= COUNT + 1;
                    pulse_out <= '0';
                end if;
                
            end if;
    end process;
    
        

end Behavioral;
