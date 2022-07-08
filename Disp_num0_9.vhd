----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2022 10:24:09 AM
-- Design Name: 
-- Module Name: Disp_num0_9 - Behavioral
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

entity Disp_num0_9 is
 Port (  rst : in std_logic; 
         clk_148 : in std_logic; -- 148 MHz
        -- R, G, B : in std_logic;
         Data_in : in std_logic_vector(3 downto 0);
         Hsync, Vsync : out std_logic;
         R_out, B_out : out std_logic_vector(4 downto 0);
         G_out : out std_logic_vector(5 downto 0) );
end Disp_num0_9;

architecture Behavioral of Disp_num0_9 is
signal v_count , h_count : integer:= 0;
signal R, G, B : std_logic := '0'; 
--signal Data_reg : std_logic_vector(7 downto 0);
signal h_end, v_end : std_logic:='0';
signal video_on : std_logic:='0';

--signal count : integer range 0 to 4 := 0;
signal i, j, j_reg : integer range 0 to 159 :=0;
type rom_type is array (0 to 159,0 to 9)
        of std_logic;
   -- ROM definition
   constant ROM: rom_type:=(
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110011100", -- 5 **  ***
   "0110111100", -- 6 ** ****
   "0111101100", -- 7 **** **
   "0111001100", -- 8 ***  **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x31
   "0000000000", -- 0
   "0000000000", -- 1
   "0000110000", -- 2
   "0001110000", -- 3
   "0011110000", -- 4    **
   "0000110000", -- 5   ***
   "0000110000", -- 6  ****
   "0000110000", -- 7    **
   "0000110000", -- 8    **
   "0000110000", -- 9    **
   "0000110000", -- a    **
   "0011111100", -- b    **
   "0000000000", -- c    **
   "0000000000", -- d  ******
   "0000000000", -- e
   "0000000000", -- f
   -- code x32
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0000001100", -- 4      **
   "0000011000", -- 5     **
   "0000110000", -- 6    **
   "0001100000", -- 7   **
   "0011000000", -- 8  **
   "0110000000", -- 9 **
   "0110001100", -- a **   **
   "0111111100", -- b *******
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x33
   "0000000000", -- 0
   "0000000000", -- 1
   "0001111100", -- 2  *****
   "0011000110", -- 3 **   **
   "0000000110", -- 4      **
   "0000000110", -- 5      **
   "0000111100", -- 6   ****
   "0000000110", -- 7      **
   "0000000110", -- 8      **
   "0000000110", -- 9      **
   "0011000110", -- a **   **
   "0001111100", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x34
   "0000000000", -- 0
   "0000000000", -- 1
   "0000011000", -- 2     **
   "0000111000", -- 3    ***
   "0001111000", -- 4   ****
   "0011011000", -- 5  ** **
   "0110011000", -- 6 **  **
   "0111111100", -- 7 *******
   "0000011000", -- 8     **
   "0000011000", -- 9     **
   "0000011000", -- a     **
   "0000111100", -- b    ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x35
   "0000000000", -- 0
   "0000000000", -- 1
   "0111111100", -- 2 *******
   "0110000000", -- 3 **
   "0110000000", -- 4 **
   "0110000000", -- 5 **
   "0111111000", -- 6 ******
   "0000001100", -- 7      **
   "0000001100", -- 8      **
   "0000001100", -- 9      **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x36
   "0000000000", -- 0
   "0000000000", -- 1
   "0001110000", -- 2   ***
   "0011000000", -- 3  **
   "0110000000", -- 4 **
   "0110000000", -- 5 **
   "0111111000", -- 6 ******
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x37
   "0000000000", -- 0
   "0000000000", -- 1
   "0111111100", -- 2 *******
   "0110001100", -- 3 **   **
   "0000001100", -- 4      **
   "0000001100", -- 5      **
   "0000011000", -- 6     **
   "0000110000", -- 7    **
   "0001100000", -- 8   **
   "0001100000", -- 9   **
   "0001100000", -- a   **
   "0001100000", -- b   **
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x38
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0011111000", -- 6  *****
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   -- code x39
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0011111100", -- 6  ******
   "0000001100", -- 7      **
   "0000001100", -- 8      **
   "0000001100", -- 9      **
   "0000011000", -- a     **
   "0011110000", -- b  ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000" -- f
   
   ); 
begin
h_end <= '1' when h_count = 2199 else '0';
v_end <= '1' when v_count = 1124 else '0';

process(clk_148, h_end, v_end, v_count)
begin
    if rising_edge(clk_148) and h_end = '1' then
        if v_end = '1' then
            v_count <= 0;    
        else 
            v_count <= v_count + 1;
         end if;
     end if;
end process;

process(clk_148, h_end, h_count)
begin
    if rising_edge(clk_148) then
        if h_end = '1' then
           h_count <= 0;
        else   
           h_count <= h_count + 1;
     
            end if ;
         --end if;
     end if;
end process;

Hsync <= '1' when (H_count > 44) else '0';
Vsync <= '1' when (V_count > 5 ) else '0';

  
process(v_count,h_count,i,j)                                   ---- char display area select
begin
        if V_count < 400 then
            R <= '0';
            G <= '0';
            B <= '0';
        elsif (V_count >= 400 and V_count < 416) and (H_count >= 300 and H_count < 310) then
     
                video_on <= '1';
                    if rom(j,i) = '1' then
                        R <= '1';
                        G <= '0';
                        B <= '0';
                       -- i := i+1;
                    else
                       -- i := i+1;
                         R <= '0';
                         G <= '0';
                         B <= '0';
                end if;
             
           else
                video_on <= '0';
                 R <= '0';
                 G <= '0';
                 B <= '0';
          end if;
 
  end process;
  
  ---input number
  process(Data_in)
  begin
    case(Data_in) is
        when "0000" =>  j_reg <= 0;
        when "0001" =>  j_reg <= 16;
        when "0010" =>  j_reg <= 32;
        when "0011" =>  j_reg <= 48;
        when "0100" =>  j_reg <= 64;
        when "0101" =>  j_reg <= 80;
        when "0110" =>  j_reg <= 96;
        when "0111" =>  j_reg <= 112;
        when "1000" =>  j_reg <= 128;
        when "1001" =>  j_reg <= 144;
        when others =>  null;
        
    end case;
  end process;
  
  --- pixel counter
 process(clk_148,i,j)
   begin
    if rising_edge(clk_148) then
        if V_count = 399 and H_count = 299 then
            j <= j_reg;
        end if;
        if video_on = '1' then
            if j = j_reg + 15 then
                     j <= j_reg;
                  --   i <= 0;
            elsif i = 9 then
                    j <= j+1;
                    i<= 0;
               else
                    i<= i+1;
                end if;
            --   end if;
           else
                i <= 0;
          --      j <= j_reg;
           end if;
          end if;
   end process;
    
R_out <= "11111" when ( R = '1' ) else "00000";
G_out <= "111111" when ( G = '1') else "000000";
B_out <= "11111" when ( B = '1' ) else "00000";

end Behavioral;
