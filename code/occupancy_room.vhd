library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity occupency_room is
port(
    clk: in std_logic;
    reset: in std_logic;
    inside: in std_logic;
    outside: in std_logic;
    max_reached: out std_logic;
    max_capacity: in unsigned(7 downto 0) := "00000000";
    q: out unsigned(7 downto 0)
);
end occupency_room;

architecture arch of occupency_room is
signal reg_q, next_q: unsigned(7 downto 0) := (others => '0');

begin
    process(clk, reset)
    begin
   	 if reset='1' then
   		 reg_q <= (others => '0');

   	 elsif clk'event and clk='1' then
   		 if reg_q >= max_capacity then
           			 reg_q <= (others => '0');
   		 
   		 else
   			 reg_q <= next_q;
   		 end if;
   	 end if;
    end process;

    process(inside, outside, reg_q)
    variable select_exp: std_logic_vector(1 downto 0);
    begin
   	 select_exp := inside & outside;
   		 case select_exp is
   			 when "01" =>
   				 if reg_q > 0 then
   					 next_q <= reg_q - "00000001";
   				 else
   					 next_q <= reg_q;
   				 end if;
   			 when "10" => next_q <= reg_q + "00000001";
   			 when others => next_q <= reg_q;
   		 end case;
    end process;
     
max_reached <= '1' when reg_q >= max_capacity else '0';
q <= reg_q;
   
end arch;
