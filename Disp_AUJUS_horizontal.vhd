----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/25/2022 12:13:02 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP1 is
 Port ( clk, rst : in std_logic; -- 125 MHz
         clk_148 : in std_logic; -- 148 MHz
        -- R, G, B : in std_logic;
        -- pixel_clk : inout std_logic;
        -- Data_in : in std_logic_vector(7 downto 0);
         Hsync, Vsync : out std_logic;
         R_out, B_out : out std_logic_vector(4 downto 0);
         G_out : out std_logic_vector(5 downto 0) );
end TOP1;

architecture Behavioral of TOP1 is
signal v_count , h_count : integer:= 0;
--signal v_en : std_logic:= '0';
signal R, G, B : std_logic := '0'; 
--signal Data_reg : std_logic_vector(7 downto 0);
signal h_end, v_end : std_logic:='0';
signal video_on : std_logic:='0';

signal count : integer range 0 to 4 := 0;
signal i, j,j_reg : integer range 0 to 79 :=0;
type rom_type is array (0 to 79,0 to 9)
        of std_logic;
   -- ROM definition
   constant ROM: rom_type:=(
   "0000000000", -- 0
   "0000000000", -- 1
   "0000100000", -- 2    *
   "0001110000", -- 3   ***
   "0011011000", -- 4  ** **
   "0110001100", -- 5 **   **
   "0110001100", -- 6 **   **
   "0111111100", -- 7 *******
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0110001100", -- b **   **
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000",
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0110001100", -- 2 **   **
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0110001100", -- 6 **   **
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0000111100", -- 2    ****
   "0000011000", -- 3     **
   "0000011000", -- 4     **
   "0000011000", -- 5     **
   "0000011000", -- 6     **
   "0000011000", -- 7     **
   "0110011000", -- 8 **  **
   "0110011000", -- 9 **  **
   "0110011000", -- a **  **
   "0011110000", -- b  ****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0110001100", -- 2 **   **
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0110001100", -- 5 **   **
   "0110001100", -- 6 **   **
   "0110001100", -- 7 **   **
   "0110001100", -- 8 **   **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
   "0000000000", -- c
   "0000000000", -- d
   "0000000000", -- e
   "0000000000", -- f
   
   "0000000000", -- 0
   "0000000000", -- 1
   "0011111000", -- 2  *****
   "0110001100", -- 3 **   **
   "0110001100", -- 4 **   **
   "0011000000", -- 5  **
   "0001110000", -- 6   ***
   "0000011000", -- 7     **
   "0000001100", -- 8      **
   "0110001100", -- 9 **   **
   "0110001100", -- a **   **
   "0011111000", -- b  *****
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

--process(clk_148)                              --- red box display
-- variable i : integer range 0 to 7 := 0;
--begin
--    if rising_edge(clk_148) then
--        if V_count < 135 then
--            R <= '0';
--            G <= '0';
--            B <= '0';
--        elsif V_count >= 135 and V_count < 414 then
--            if H_count >= 324 and H_count < 604 then
--                R <= '1';
--                G <= '0';
--                B <= '0';
--            else 
--                R <= '0';
--                G <= '0';
--                B <= '0';
--           end if;
--        else
--            R <= '0';
--            G <= '0';
--            B <= '0';    
--        end if;
--     end if;
--  end process;
  
  process(v_count,h_count,i,j)                                   ---- char display
-- variable i : integer range 0 to 7 := 0;  -- column
-- variable j : integer range 0 to 15 := 0; -- row
begin
   -- if rising_edge(clk_148) then
        if V_count < 400 then
            R <= '0';
            G <= '0';
            B <= '0';
        elsif (V_count >= 400 and V_count < 416) and (H_count >= 300 and H_count < 350) then
           -- if H_count >= 300 and H_count < 310 then
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
                
--           end if;
--           end if;
--        else
--            R <= '0';
--            G <= '0';
--            B <= '0';    
--       end if;
  --   end if;
  end process;
  
 process(clk_148,video_on ,i,j)
   begin    
    if rising_edge(clk_148) then
        if video_on = '1' then
           if j = 79 then
                     j <= 0;
            elsif i = 9 then
                    j <= j+16;
                    i<= 0;
                    if count = 4 then
                        j <= j -63 ;
                        count <= 0;
                    else
                        count<= count + 1;
                    end if;
            else
                    i<= i+1;
          --          j_reg <= j;
                end if;
            --   end if;
           else
                i <= 0;
                count <= 0;
          --      j <= j- 63;
           end if;
          end if;
       end process;
    
R_out <= "11111" when ( R = '1' ) else "00000";
G_out <= "111111" when ( G = '1') else "000000";
B_out <= "11111" when ( B = '1' ) else "00000";


end Behavioral;
