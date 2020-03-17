----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2020 11:51:47
-- Design Name: 
-- Module Name: Top_level - Behavioral
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

entity Top_level is
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           CA, CB, CC, CD, CE, CF, CG: out STD_logic);
end Top_level;

architecture Behavioral of Top_level is

component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 7));	-- Output 7-Seg vector                 
end component;

--signal SW : std_logic_vector(3 downto 0);
begin
display: BCD_to_7SEG port map (bcd_in => SW, 
leds_out(1) => CA,
leds_out(2) => CB,
leds_out(3) => CC,
leds_out(4) => CD,
leds_out(5) => CE,
leds_out(6) => CF,
leds_out(7) => CG);

end Behavioral;
