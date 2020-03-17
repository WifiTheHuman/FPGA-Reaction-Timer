----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.03.2020 10:42:13
-- Design Name: 
-- Module Name: lab1Adders - Behavioral
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

entity lab1Adders is
    Port ( SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0));
end lab1Adders;

architecture Behavioral of lab1Adders is

begin
--half adder code--
--LED(0) <= SW(0) XOR SW(1);
--LED(1) <= SW(0) AND SW(1);
--end half adder code--

--full adder code--

--process (SW(0), SW(1), SW(2))
--begin
LED(0) <= SW(0) XOR SW(1) XOR SW(2);
LED(1) <= (SW(0) AND SW(1)) or (SW(2) and SW(0)) or (SW(2) and SW(1));
--end process;
--end full adder code--

end Behavioral;
