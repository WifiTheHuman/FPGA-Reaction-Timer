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
           AN : out std_logic_vector(7 downto 0);
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
signal selector : std_logic;

component my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0));
end component;

component clock_divider_1hz is
	port(
		in_clock  : in std_logic;
		
		out_clock : out std_logic := '0');
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
   nd_counter: clock_divider_1hz port map(in_clock => CLK100MHZ,
	                                      out_clock => selector);
   
   mux1: process(selector)
         begin
			case selector is					 
				when '0'	=> AN <= "11111110";	  
				when '1'	=> AN <= "11111101";
			end case;
		end process mux1;
	


end Behavioral;
