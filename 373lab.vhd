----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2020 09:15:55
-- Design Name: 
-- Module Name: Counter - Behavioral
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

entity Top_Level is
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           CA, CB, CC, CD, CE, CF, CG : out STD_LOGIC; 
           AN : out std_logic_vector(7 downto 0) := "11111110";
           LED : out std_logic_vector(0 downto 0); 
           CLK100MHZ : in std_logic);
end Top_Level;

architecture Behavioral of Top_Level is
component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 7));	-- Output 7-Seg vector                 
end component;


signal wire_1 : std_logic;
signal wire_2 : std_logic_vector(3 downto 0);


component my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0));
end component;


begin 
    display: BCD_to_7SEG port map(bcd_in => wire_2,
                                  leds_out(1) => CA,
                                  leds_out(2) => CB,
                                  leds_out(3) => CC,
                                  leds_out(4) => CD,
                                  leds_out(5) => CE,
                                  leds_out(6) => CF,
                                  leds_out(7) => CG);
   divider: my_divider port map(Clk_in => CLK100MHZ,
                                Clk_out => wire_1);
   bit_counter: counter port map(Clock => wire_1,
                                    CLR => SW(3),
                                    Q => wire_2);
--begin
--CG <= not(SW(0)) and not(SW(1)) and not(SW(2)) and not(SW(3));
--CD <=    (SW(0)) and not(SW(1)) and not(SW(2)) and not(SW(3));
--CC <= not(SW(0)) and     SW(1)  and not(SW(2)) and not(SW(3));
--CD <=    (SW(0)) and     SW(1)  and not(SW(2)) and not(SW(3));
--CE <= not(SW(0)) and not(SW(1)) and    (SW(2)) and not(SW(3));
--CF <=    (SW(0)) and not(SW(1)) and    (SW(2)) and not(SW(3));
--CG <= not(SW(0)) and     SW(1)  and not(SW(2)) and not(SW(3));

end Behavioral;
