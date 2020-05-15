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
           BTND, BTNC : in STD_LOGIC;
           CA, CB, CC, CD, CE, CF, CG, DP: out STD_LOGIC; 
           AN : out std_logic_vector(7 downto 0);
           LED : out std_logic_vector(0 downto 0); 
           CLK100MHZ : in std_logic);
end Top_Level;

architecture Behavioral of Top_Level is
component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 7));	-- Output 7-Seg vector                 
end component;

signal enable_signal : std_logic := '1';
signal clr_signal, lastButtonState : std_logic := '0';
signal wire_2, o1, o2, o3, o4 : std_logic_vector(3 downto 0);
signal q1, q2, q3, q4, wire_1 : std_logic;
signal selector : std_logic_vector(1 downto 0);


component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0);
        tmpD : out std_logic);
end component;

component clock_divider_1hz is
	port(
		in_clock  : in std_logic;
		enable : in std_logic;
		out_clock : out std_logic := '0');
end component;

component disp_div is 
    Port ( Clk_in : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC_VECTOR(1 downto 0));
end component;


begin 
    
    
    
    
    display: BCD_to_7SEG port map(bcd_in => wire_2,
                                  leds_out(1) => CA,
                                  leds_out(2) => CB,
                                  leds_out(3) => CC,
                                  leds_out(4) => CD,
                                  leds_out(5) => CE,
                                  leds_out(6) => CF,
                                  leds_out(7) => CG
                                  );
   --divider: clock_divider_1hz port map(in_clock => CLK100MHZ,
	   --                                out_clock => wire_1);
	--                                   
divider: clock_divider_1hz port map(in_clock => CLK100MHZ,
                            enable => enable_signal,
                            out_clock => wire_1);
bit_counter0: counter port map(Clock => wire_1,
                              CLR => BTND,
                              Q => o1,
                              tmpD => q1);
bit_counter1: counter port map(Clock => q1,
                              CLR => BTND,
                              Q => o2,
                              tmpD => q2);
bit_counter2: counter port map(Clock => q2,
                              CLR => BTND,
                              Q => o3,
                              tmpD => q3);
bit_counter3: counter port map(Clock => q3,
                              CLR => BTND,
                              Q => o4,
                              tmpD => q4);

disp_divider : disp_div port map(CLK_IN=>CLK100MHZ, CLK_OUT=>selector);
   
mux1: process(selector)
         begin
			case selector is					 
				when "00"	=>
				    --DP <= DP_array(0);
				    DP <= '1';
				    wire_2 <= o1;
				    AN <= "11111110";	  
				    
				when "01"	=> 
				    --DP <= DP_array(1);
				    DP <= '1';
					 wire_2 <= o2;
				    AN <= "11111101";
				   
				when "10"	=>
				    --DP <= DP_array(2);
				    DP <= '1';
				    wire_2 <= o3;
				    AN <= "11111011";	
				     
				when "11"	=> 
				    --DP <= DP_array(3);
				    DP <= '0';
					 wire_2 <= o4;
				    AN <= "11110111";
				    
			end case;
		end process mux1;

--stop_go: process(clr_signal, enable_signal)
--            begin
--                if (BTNC <= '1') and (enable_signal <= '0') then
--                    clr_signal <= '1';
--                    enable_signal <= '1';
--                elsif (BTNC <= '1') then
--                    enable_signal <= '0';
--                end if;
--          end process stop_go;

bleshgo: process(CLK100MHZ)
begin
  if(rising_edge(CLK100MHZ)) then
    if(BTNC = '1' and lastButtonState = '0') then      --assuming active-high
      --Rising edge - do some work...
      if(enable_signal = '0' and clr_signal = '0') then
        clr_signal <= '1'; 
      elsif(enable_signal = '1') then
        enable_signal <= '0';
      end if;
    end if;
    lastButtonState <= BTNC;
  end if;
end process;
end Behavioral;
