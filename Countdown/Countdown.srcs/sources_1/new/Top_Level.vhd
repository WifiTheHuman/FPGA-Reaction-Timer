library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level is
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           BTND, BTNC : in STD_LOGIC;
           CA, CB, CC, CD, CE, CF, CG, DP: out STD_LOGIC; 
           AN : out std_logic_vector(7 downto 0);
           LED : out std_logic_vector(15 downto 0); 
           CLK100MHZ : in std_logic);
end Top_Level;

architecture Behavioral of Top_Level is

component BCD_to_7SEG is
		   Port ( bcd_in: in std_logic_vector (3 downto 0);	-- Input BCD vector
    			leds_out: out	std_logic_vector (1 to 7));	-- Output 7-Seg vector                 
end component;

component counter is 
    port( Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0);
        tmpD : out std_logic);
end component;

--count stuff
component prompt_clock_divider_1hz is
	port(
		in_clock  : in std_logic;
		enable : in std_logic;
		out_clock : out std_logic := '0');
end component;

--count stuff
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

component DeBounce is
    port(   Clock : in std_logic;
                Reset : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end component;

component prompt_state_count is
    Port ( Clock : in STD_LOGIC;
           Reset : in STD_LOGIC;
           pulse_out : out STD_LOGIC);
end component;

type state_t is (prompting, counting, displaying);
signal current_state : state_t := prompting;
signal next_state : state_t := counting;

signal AN_sig_prompt, AN_sig_count : std_logic_vector(0 to 7):= "11111111";
signal DP_sig_prompt, DP_sig_count : std_logic := '1';

signal BTNC_debounced : std_logic := '0';

--prompt stuff
signal prompt_enable : std_logic;
signal prompt_divider_output : std_logic;
signal prompt_clr_signal : std_logic := '0';
signal nothing : std_logic;
signal prompt_count : std_logic_vector(3 downto 0);
signal prompt_done : std_logic := '0';

signal nothing2: std_logic;

--count stuff
signal q1, q2, q3, q4, count_div_output : std_logic;
signal selector : std_logic_vector(1 downto 0);
signal o1, o2, o3, o4 : std_logic_vector(3 downto 0);
signal count_enable_signal : std_logic := '1';
signal count_clr_signal, lastButtonState : std_logic := '0';
signal wire_2 : std_logic_vector(3 downto 0) := "1111";

signal promptClkReset : std_logic := '0';

signal lastState : std_logic := '0';

begin

AN <= AN_sig_count AND AN_sig_prompt;
DP <= DP_sig_count AND DP_sig_prompt;

display: BCD_to_7SEG port map(bcd_in => wire_2,
                                  leds_out(1) => CA,
                                  leds_out(2) => CB,
                                  leds_out(3) => CC,
                                  leds_out(4) => CD,
                                  leds_out(5) => CE,
                                  leds_out(6) => CF,
                                  leds_out(7) => CG
                                  );

disp_divider : disp_div port map(CLK_IN=>CLK100MHZ, CLK_OUT=>selector);
--prompt stuff
prompt_divider: prompt_clock_divider_1hz port map(in_clock => CLK100MHZ,
                            enable => prompt_enable,
                            out_clock => prompt_divider_output);
                            
PromptCounter: counter port map(Clock => prompt_divider_output,
                              CLR => prompt_clr_signal,
                              Q => prompt_count,
                              tmpD => nothing);

--count stuff
count_divider: clock_divider_1hz port map(in_clock => CLK100MHZ,
                            enable => count_enable_signal,
                            out_clock => count_div_output);
bit_counter0: counter port map(Clock => count_div_output,
                              CLR => count_clr_signal,
                              Q => o1,
                              tmpD => q1);
bit_counter1: counter port map(Clock => q1,
                              CLR => count_clr_signal,
                              Q => o2,
                              tmpD => q2);
bit_counter2: counter port map(Clock => q2,
                              CLR => count_clr_signal,
                              Q => o3,
                              tmpD => q3);
bit_counter3: counter port map(Clock => q3,
                              CLR => count_clr_signal,
                              Q => o4,
                              tmpD => q4);

BTNC_debouncer: DeBounce port map(Clock => CLK100MHZ,
                                      Reset => '0',
                                      button_in => BTNC,
                                      pulse_out => BTNC_debounced);
                                      

prompt_state_counter: prompt_state_count port map(Clock => CLK100MHZ,
                                            Reset => promptClkreset,
                                            pulse_out => prompt_done);

stateCtrl: process(CLK100MHZ)
    begin
        case current_state is
            when prompting => 
                prompt_enable <= '1';
                prompt_clr_signal <= '0';
                promptClkReset <= '0';
                count_clr_signal <= '1';
                count_enable_signal <= '0';
                if prompt_done = '1' then
                    current_state <= next_state;
                end if;
                
            when counting => 
                prompt_enable <= '0';
                count_enable_signal <= '1';
                promptClkReset <= '0';
                count_clr_signal <= '0';
                if BTNC_debounced = '1' then
                    current_state <= next_state;
                end if;
            when displaying => 
                prompt_enable <= '0';
                prompt_clr_signal <= '1';
                promptClkReset <= '1';
                count_enable_signal <= '0';
                count_clr_signal <= '0';
                if BTNC_debounced = '1' then
                    current_state <= next_state;
                    
                end if;
                
        end case;
        lastButtonState <= BTNC_debounced;     
    end process stateCtrl;
    

state_switching: process(CLK100MHZ)
begin
    if current_state = prompting then
        next_state <= counting;
    elsif current_state = counting then
        next_state <= displaying;
    elsif current_state = displaying then 
        LED(8) <= '1';
        next_state <= prompting;
    end if;

end process;

count_controller: process(selector)
         begin
            if current_state = displaying then
            
                case selector is					 
                    when "00"	=>
                        --DP <= DP_array(0);
                        DP_sig_count <= '1';
                        wire_2 <= o1;
                        AN_sig_count <= "11111110";	  
                        
                    when "01"	=> 
                        --DP <= DP_array(1);
                        DP_sig_count <= '1';
                         wire_2 <= o2;
                        AN_sig_count <= "11111101";
                       
                    when "10"	=>
                        --DP <= DP_array(2);
                        DP_sig_count <= '1';
                        wire_2 <= o3;
                        AN_sig_count <= "11111011";	
                         
                    when "11"	=> 
                        --DP <= DP_array(3);
                        DP_sig_count <= '0';
                         wire_2 <= o4;
                        AN_sig_count <= "11110111";
                        
                end case;
                
            else 
                AN_sig_count <= "11111111";
                DP_sig_count <= '1';
                wire_2 <= "1111";
            end if;
		end process count_controller;

promptController: process(prompt_count)
    begin
        if current_state = prompting then
        
            case prompt_count is
                when "0000" =>
                    DP_sig_prompt <= '0';
                    
                    AN_sig_prompt <= "11111000";
                when "0001" =>
                    DP_sig_prompt <= '0';
                    AN_sig_prompt <= "11111100";
                when "0010" =>
                    AN_sig_prompt <= "11111110";
                    DP_sig_prompt <= '0';
                when "0011" =>
                    AN_sig_prompt <= "11111111";
                    --prompt_clr_signal <= '1';
                    --prompt_done <= '1';
                    DP_sig_prompt <= '1';
                    
                when others =>
                    AN_sig_prompt <= "11111111";
                
             end case;
        else
            AN_sig_prompt <= "11111111";
            DP_sig_prompt <= '1';
        end if;
    end process promptController;

end Behavioral;
