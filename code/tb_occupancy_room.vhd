library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_occupency_room is
end tb_occupency_room;

architecture tb_arch of tb_occupency_room is
 -- testbench components
	component occupency_room
	port(
  	  clk: in std_logic;
  	  reset: in std_logic;
  	  inside: in std_logic;
  	  outside: in std_logic;
  	  max_reached: out std_logic;
  	  max_capacity: in unsigned(7 downto 0);
  	  q: out unsigned(7 downto 0)
	);
	end component;

	-- testbench signals
	signal inside_t: std_logic := '0';
	signal outside_t: std_logic := '0';
	signal clk_t: std_logic := '0';
	signal reset_t: std_logic := '1';
	signal max_reached_t: std_logic := '0';    
	signal max_capacity_t: unsigned(7 downto 0) := "00000100";
	signal q_t: unsigned(7 downto 0) := "00000000";

    
	constant CLK_PERIOD : time := 10 ns;
begin
 	-- instantiate the components
   	 uut: occupency_room port map(
      	  inside => inside_t,
      	  outside => outside_t,
      	  max_reached => max_reached_t,
      	  max_capacity => max_capacity_t,
      	  clk => clk_t,
      	  reset => reset_t,
      	  q => q_t
      	  );

	-- Clock generation
	clk_t <= not clk_t after CLK_PERIOD/2;

	-- Test sequence
	process
	begin
    	-- Reset the system
    	reset_t <= '1';
    	wait for 20 ns;
    	reset_t <= '0';
   	 
    	-- Test 1: 3 people enter
    	for i in 1 to 3 loop
        	inside_t <= '1';
        	wait for 10 ns;
        	inside_t <= '0';
        	wait for 10 ns;
    	end loop;
   	 
    	-- Test 2: 1 person exits
    	outside_t <= '1';
    	wait for 10 ns;
    	outside_t <= '0';
    	wait for 10 ns;
   	 
    	-- Test 3: Try to exceed capacity
    	for i in 1 to 3 loop
        	inside_t <= '1';
        	wait for 10 ns;
        	inside_t <= '0';
        	wait for 10 ns;
    	end loop;

    -- Reset the system again
    	reset_t <= '1';
    	wait for 20 ns;
    	reset_t <= '0';

    -- Test 4: 1 person enters
    inside_t <= '1';
    	wait for 10 ns;
    	inside_t <= '0';
    	wait for 10 ns;

    -- Test 5: 1 person exits
    	outside_t <= '1';
    	wait for 10 ns;
    	outside_t <= '0';
    	wait for 10 ns;
   	 
    -- Test 5: 1 person exits if there's 0 person (can't happen irl, but making sure the code handle the    	 exception)
    	outside_t <= '1';
    	wait for 10 ns;
    	outside_t <= '0';
    	wait for 10 ns;
    	wait;
	end process;
end tb_arch;
