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
           CA, CB, CC, CD, CE, CF, CG, DP: out STD_LOGIC; 
           AN : out std_logic_vector(7 downto 0);
           LED : out std_logic_vector(0 downto 0); 
           CLK100MHZ : in std_logic);
end Top_Level;

architecture Behavioral of Top_Level is
component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 8));	-- Output 7-Seg vector                 
end component;

signal wire_1 : std_logic;
signal wire_2, o1, o2, o3, o4, o5, o6, o7, o8 : std_logic_vector(3 downto 0);
signal q1, q2, q3, q4, q5, q6, q7, q8 : std_logic;
signal selector : std_logic_vector(2 downto 0);


component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0);
        tmpD : out std_logic);
end component;

component clock_divider_1hz is
	port(
		in_clock  : in std_logic;
		
		out_clock : out std_logic := '0');
end component;

component disp_div is 
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC_VECTOR(2 downto 0));
end component;

component my_divider is
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
end component;

begin 
    display: BCD_to_7SEG port map(bcd_in => wire_2,
                                  leds_out(1) => CA,
                                  leds_out(2) => CB,
                                  leds_out(3) => CC,
                                  leds_out(4) => CD,
                                  leds_out(5) => CE,
                                  leds_out(6) => CF,
                                  leds_out(7) => CG,
                                  leds_out(8) => DP);
   --divider: clock_divider_1hz port map(in_clock => CLK100MHZ,
	   --                                out_clock => wire_1);
	--                                   
divider: my_divider port map(Clk_in => CLK100MHZ,
                            Clk_out => wire_1);
bit_counter0: counter port map(Clock => wire_1,
                              CLR => SW(3),
                              Q => o1,
                              tmpD => q1);
bit_counter1: counter port map(Clock => q1,
                              CLR => SW(3),
                              Q => o2,
                              tmpD => q2);
bit_counter2: counter port map(Clock => q2,
                              CLR => SW(3),
                              Q => o3,
                              tmpD => q3);
bit_counter3: counter port map(Clock => q3,
                              CLR => SW(3),
                              Q => o4,
                              tmpD => q4);
bit_counter4: counter port map(Clock => q4,
                              CLR => SW(3),
                              Q => o5,
                              tmpD => q5);
bit_counter5: counter port map(Clock => q5,
                              CLR => SW(3),
                              Q => o6,
                              tmpD => q6);
bit_counter6: counter port map(Clock => q6,
                              CLR => SW(3),
                              Q => o7,
                              tmpD => q7);
bit_counter7: counter port map(Clock => q7,
                              CLR => SW(3),
                              Q => o8,
                              tmpD => q8);
disp_divider : disp_div port map(CLK_IN=>CLK100MHZ, CLK_OUT=>selector);
   
mux1: process(selector)
         begin
			case selector is					 
				when "000"	=>
				    --DP <= DP_array(0);
				    wire_2 <= o1;
				    AN <= "11111110";	  
				when "001"	=> 
				    --DP <= DP_array(1);
					 wire_2 <= o2;
				    AN <= "11111101";
				when "010"	=>
				    --DP <= DP_array(2);
				    wire_2 <= o3;
				    AN <= "11111011";	  
				when "011"	=> 
				    --DP <= DP_array(3);
					 wire_2 <= o4;
				    AN <= "11110111";
				when "100"	=>
				    --DP <= DP_array(4);
				    wire_2 <= o5;
				    AN <= "11101111";	  
				when "101"	=>
				    --DP <= DP_array(5); 
					 wire_2 <= o6;
				    AN <= "11011111";
				when "110"	=>
				    --DP <= DP_array(6);
				    wire_2 <= o7;
				    AN <= "10111111";	  
				when "111"	=> 
				    --DP <= DP_array(7);
					 wire_2 <= o8;
				    AN <= "01111111";
			end case;
		end process mux1;
	


end Behavioral;
