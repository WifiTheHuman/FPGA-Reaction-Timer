----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2020 18:37:15
-- Design Name: 
-- Module Name: Top_Level - Behavioral
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

component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0);
        tmpD : out std_logic);
end component;

component prompt_clock_divider_1hz is
	port(
		in_clock  : in std_logic;
		enable : in std_logic;
		out_clock : out std_logic := '0');
end component;

signal prompt_enable : std_logic := '1';
signal divider_output : std_logic;
signal clr_signal : std_logic := '0';
signal nothing : std_logic;
signal prompt_count : std_logic_vector(3 downto 0);

begin

divider: prompt_clock_divider_1hz port map(in_clock => CLK100MHZ,
                            enable => '1',
                            out_clock => divider_output);
                            
PromptCounter: counter port map(Clock => divider_output,
                              CLR => clr_signal,
                              Q => prompt_count,
                              tmpD => nothing);

CountdownController: process(prompt_count)
    begin
    
    if (prompt_enable <= '1') then
        DP <= '0';
        case prompt_count is
            when "0000" =>
                clr_signal <= '0';
                AN <= "11111000";
            when "0001" =>
                AN <= "11111100";
            when "0010" =>
                AN <= "11111110";
            when "0011" =>
                AN <= "11111111";
                clr_signal <= '1';
            when others =>
                AN <= "11111111";
                
        end case;
        
    end if;
    end process CountdownController;

end Behavioral;
