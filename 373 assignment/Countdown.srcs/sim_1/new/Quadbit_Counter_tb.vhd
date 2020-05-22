----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 21:05:06
-- Design Name: 
-- Module Name: Quadbit_Counter_tb - Behavioral
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

entity Quadbit_Counter_tb is
--  Port ( );
end Quadbit_Counter_tb;

architecture Behavioral of Quadbit_Counter_tb is

component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0);
        tmpD : out std_logic);
end component;

signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal out1, out2, out3, out4 : std_logic_vector(3 downto 0);
signal q1, q2, q3, q4 : std_logic;


begin

clk_process: process is
begin
    clk <= '0';
    wait for 10 us;
    clk <= '1';
    wait for 10 us;

end process;

stim_proc: process
begin        
   -- hold reset state for 100 ns.
     reset <= '1';
   wait for 20 us;    
    reset <= '0';
   wait;
end process;

UUT: counter port map(Clock => clk,
    CLR => reset,
    Q => out1,
    tmpD => q1);
 
Bit2: counter port map(Clock => q1,
    CLR => reset,
    Q => out2,
    tmpD => q2);
 
bit3: counter port map(Clock => q2,
    CLR => reset,
    Q => out3,
    tmpD => q3);

bit4: counter port map(Clock => q3,
    CLR => reset,
    Q => out4,
    tmpD => q4);

end Behavioral;

