----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2022 01:04:03 PM
-- Design Name: 
-- Module Name: Disp_multi_num - Behavioral
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

entity Disp_multi_num is
 Port (  rst : in std_logic; 
         clk_148 : in std_logic; -- 148 MHz
        -- R, G, B : in std_logic;
         Data_in1, Data_in2, Data_in3, Data_in4 : in std_logic_vector(3 downto 0);
         Hsync, Vsync : out std_logic;
         R_out, B_out : out std_logic_vector(4 downto 0);
         G_out : out std_logic_vector(5 downto 0) );
end Disp_multi_num;

architecture Behavioral of Disp_multi_num is
signal v_count , h_count : integer:= 0;
signal R, G, B : std_logic := '0'; 
--signal Data_reg : std_logic_vector(7 downto 0);
signal h_end, v_end : std_logic:='0';
signal video_on1, video_on2, video_on3, video_on4 : std_logic:='0';

--signal count : integer range 0 to 4 := 0;
signal i1, j1, j_reg1 : integer range 0 to 159 :=0;
signal i2, j2, j_reg2 : integer range 0 to 159 :=0;
signal i3, j3, j_reg3 : integer range 0 to 159 :=0;
signal i4, j4, j_reg4 : integer range 0 to 159 :=0;
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

  
process(v_count,h_count,i1,i2,i3,i4,j1,j2,j3,j4)                                   ---- char display area select
begin
        if V_count < 400 then
            R <= '0';
            G <= '0';
            B <= '0';
        end if;
        -- 1st area select   
        if (V_count >= 400 and V_count < 416) and (H_count >= 300 and H_count < 310) then
     
                video_on1 <= '1';
                    if rom(j1,i1) = '1' then
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
                video_on1 <= '0';
               
              end if;
           -- 2nd area select 
           if (V_count >= 400 and V_count < 416) and (H_count >= 310 and H_count < 320) then
     
                video_on2 <= '1';
                    if rom(j2,i2) = '1' then
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
                video_on2 <= '0';
                
              end if;
           -- 3rd area select 
           if (V_count >= 400 and V_count < 416) and (H_count >= 320 and H_count < 330) then
     
                video_on3 <= '1';
                    if rom(j3,i3) = '1' then
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
                video_on3 <= '0';
                
                end if;
              -- 4th area select 
              if (V_count >= 400 and V_count < 416) and (H_count >= 330 and H_count < 340) then
     
                video_on4 <= '1';
                    if rom(j4,i4) = '1' then
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
                video_on4 <= '0';
               end if; 
 
  end process;
  
  ---input number
  process(Data_in1)
  begin
    case(Data_in1) is
        when "0000" =>  j_reg1 <= 0;
        when "0001" =>  j_reg1 <= 16;
        when "0010" =>  j_reg1 <= 32;
        when "0011" =>  j_reg1 <= 48;
        when "0100" =>  j_reg1 <= 64;
        when "0101" =>  j_reg1 <= 80;
        when "0110" =>  j_reg1 <= 96;
        when "0111" =>  j_reg1 <= 112;
        when "1000" =>  j_reg1 <= 128;
        when "1001" =>  j_reg1 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in2)
  begin
    case(Data_in2) is
        when "0000" =>  j_reg2 <= 0;
        when "0001" =>  j_reg2 <= 16;
        when "0010" =>  j_reg2 <= 32;
        when "0011" =>  j_reg2 <= 48;
        when "0100" =>  j_reg2 <= 64;
        when "0101" =>  j_reg2 <= 80;
        when "0110" =>  j_reg2 <= 96;
        when "0111" =>  j_reg2 <= 112;
        when "1000" =>  j_reg2 <= 128;
        when "1001" =>  j_reg2 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in3)
  begin
    case(Data_in3) is
        when "0000" =>  j_reg3 <= 0;
        when "0001" =>  j_reg3 <= 16;
        when "0010" =>  j_reg3 <= 32;
        when "0011" =>  j_reg3 <= 48;
        when "0100" =>  j_reg3 <= 64;
        when "0101" =>  j_reg3 <= 80;
        when "0110" =>  j_reg3 <= 96;
        when "0111" =>  j_reg3 <= 112;
        when "1000" =>  j_reg3 <= 128;
        when "1001" =>  j_reg3 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
    ---input number
  process(Data_in4)
  begin
    case(Data_in4) is
        when "0000" =>  j_reg4 <= 0;
        when "0001" =>  j_reg4 <= 16;
        when "0010" =>  j_reg4 <= 32;
        when "0011" =>  j_reg4 <= 48;
        when "0100" =>  j_reg4 <= 64;
        when "0101" =>  j_reg4 <= 80;
        when "0110" =>  j_reg4 <= 96;
        when "0111" =>  j_reg4 <= 112;
        when "1000" =>  j_reg4 <= 128;
        when "1001" =>  j_reg4 <= 144;
        when others =>  null;
        
    end case;
  end process;
  
  --- pixel counter
 process(clk_148,i1,j1)
   begin
    if rising_edge(clk_148) then
        if V_count = 400 and H_count = 299 then
            j1 <= j_reg1;
        end if;
        if video_on1 = '1' then
            if j1 = j_reg1 + 15 then
                     j1 <= j_reg1;
                  --   i <= 0;
            elsif i1 = 9 then
                    j1 <= j1+1;
                    i1<= 0;
               else
                    i1<= i1+1;
                end if;
            --   end if;
           else
                i1 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i2,j2)
   begin
    if rising_edge(clk_148) then
        if V_count = 400 and H_count = 299 then
            j2 <= j_reg2;
        end if;
        if video_on2 = '1' then
            if j2 = j_reg2 + 15 then
                     j2 <= j_reg2;
                  --   i <= 0;
            elsif i2 = 9 then
                    j2 <= j2+1;
                    i2<= 0;
               else
                    i2<= i2+1;
                end if;
            --   end if;
           else
                i2 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i3,j3)
   begin
    if rising_edge(clk_148) then
        if V_count = 400 and H_count = 299 then
            j3 <= j_reg3;
        end if;
        if video_on3 = '1' then
            if j3 = j_reg3 + 15 then
                     j3 <= j_reg3;
                  --   i <= 0;
            elsif i3 = 9 then
                    j3 <= j3+1;
                    i3<= 0;
               else
                    i3<= i3+1;
                end if;
            --   end if;
           else
                i3 <= 0;
           end if;
          end if;
   end process;
   
    --- pixel counter
 process(clk_148,i4,j4)
   begin
    if rising_edge(clk_148) then
        if V_count = 400 and H_count = 299 then
            j4 <= j_reg4;
        end if;
        if video_on4 = '1' then
            if j4 = j_reg4 + 15 then
                     j4 <= j_reg4;
                  --   i <= 0;
            elsif i4 = 9 then
                    j4 <= j4+1;
                    i4<= 0;
               else
                    i4<= i4+1;
                end if;
            --   end if;
           else
                i4 <= 0;
           end if;
          end if;
   end process;
   
   
    
R_out <= "11111" when ( R = '1' ) else "00000";
G_out <= "111111" when ( G = '1') else "000000";
B_out <= "11111" when ( B = '1' ) else "00000";


end Behavioral;
