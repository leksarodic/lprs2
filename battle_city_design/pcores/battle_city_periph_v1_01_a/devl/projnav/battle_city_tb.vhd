-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

library battle_city_periph_v1_01_a;
	use battle_city_periph_v1_01_a.battle_city;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 


	signal clk          : std_logic;
	signal rst_n        : std_logic;
	signal bus_addr     : std_logic_vector(12 downto 0);  -- Address used to point to registers
	signal bus_data     : std_logic_vector(31 downto 0);  -- Data to be writed to registers
	signal we           : std_logic;
	signal pixel_row    : unsigned(8 downto 0);
	signal pixel_col    : unsigned(9 downto 0);
	signal stage        : unsigned(1 downto 0);

  BEGIN
  -- Component Instantiation
	  clk_gen : process
	  begin
		 clk <= '0';
		 wait for 5 ns;
		 clk <= '1';
		 wait for 5 ns;
	  end process clk_gen;
	  
	 uut: entity battle_city 
	 GENERIC MAP(
				DATA_WIDTH           => 32,
				COLOR_WIDTH          => 24,
				ADDR_WIDTH           => 13,
				REGISTER_OFFSET      => 6224,            -- Pointer to registers in memory map
				C_BASEADDR           => 0,               -- Pointer to local memory in memory map
				REGISTER_NUMBER      => 10,              -- Number of registers used for sprites
				NUM_BITS_FOR_REG_NUM => 4,               -- Number of bits required for number of registers
				MAP_OFFSET           => 1424,            -- Pointer to start of map in memory
				OVERHEAD             => 5,               -- Number of overhead bits
				SPRITE_Z             => 1                -- Z coordinate of sprite
	 )
	 PORT MAP(
				clk_i  => clk,
				rst_n_i => rst_n,
				bus_addr_i => bus_addr, 
				bus_data_i => bus_data,
				we_i => we, 
				pixel_row_i => pixel_row,
				pixel_col_i => pixel_col, 
				stage_i => stage
	 );

  tb : process	begin
		
		rst_n <= '1';
		pixel_row <= "000000000";
		pixel_col <= "0000000000";
		wait for 10 ns;
		
		
		bus_addr <= std_logic_vector(to_unsigned(6224, 13));
		bus_data <= x"babadeda";
		we <= '1';
		stage <= "00";
		wait for 10 ns;
		
		bus_addr <= std_logic_vector(to_unsigned(6224+1, 13));
		bus_data <= x"deadbeef";
		we <= '1';
		stage <= "01";
		wait for 10 ns;
		
		we <= '0';
		
		rst_n <= '0';
		wait; 
	end process tb;
	

  END;
