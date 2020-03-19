library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Author: Steve Weddell
-- Date: June 25, 2004
-- Purpose: VHDL Module for BCD to 7-segment Decoder
-- Usage: Laboratory 1; Example VHDL file for ENEL353


entity BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 8));		-- Output 7-Seg vector 
end BCD_to_7SEG;

architecture Behavioral of BCD_to_7SEG is

begin
	my_seg_proc: process (bcd_in)		-- Enter this process whenever BCD input changes state
		begin
			case bcd_in is					 -- abcdefg segments
				when "0000"	=> leds_out <= "00000010";	  -- if BCD is "0000" write a zero to display
				when "0001"	=> leds_out <= "10011110";	  -- etc...
				when "0010"	=> leds_out <= "00100100";
				when "0011"	=> leds_out <= "00001100";
				when "0100"	=> leds_out <= "10011000";
				when "0101"	=> leds_out <= "01001000";
				when "0110"	=> leds_out <= "11000000";
				when "0111"	=> leds_out <= "00011110";
				when "1000"	=> leds_out <= "00000000";
				when "1001"	=> leds_out <= "00011000";
				when others => leds_out <= "--------";
			end case;
	end process my_seg_proc;

end Behavioral;
