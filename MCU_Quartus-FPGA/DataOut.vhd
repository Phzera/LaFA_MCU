LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DataOut IS
	PORT
	(
		A				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		B				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		C				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		D				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		E	     		:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		F 				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		G				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		H				:IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		clk				:IN		STD_LOGIC;
		data_trigger	:IN		STD_LOGIC;
		UART_TXD		:OUT	STD_LOGIC
	);
	
END DataOut;

ARCHITECTURE Behavior OF DataOut IS

SIGNAL index: STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL Output: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_select: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

	PROCESS( clk, index )
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF index = "111111" AND data_trigger = '1' THEN
				index <= "000000";
				UART_TXD <= '1'; -- a throw away bit
				OUTPUT <= A;
				data_select <= "000";

			ELSIF index = "000000" THEN
				index <= "000001";
				UART_TXD <= '0'; -- the first start bit
				
			ELSIF index = "000001" THEN
				index <= "000010";
				UART_TXD <= Output(0);
			
			ELSIF index = "000010" THEN
				index <= "000011";
				UART_TXD <= Output(1);
			
			ELSIF index = "000011" THEN
				index <= "000100";
				UART_TXD <= Output(2);
			
			ELSIF index = "000100" THEN
				index <= "000101";
				UART_TXD <= Output(3);
			
			ELSIF index = "000101" THEN
				index <= "000110";
				UART_TXD <= Output(4);
			
			ELSIF index = "000110" THEN
				index <= "000111";
				UART_TXD <= Output(5);
	
			ELSIF index = "000111" THEN
				index <= "001000";
				UART_TXD <= Output(6);
			
			ELSIF index = "001000" THEN
				index <= "001001";
				UART_TXD <= '0'; -- the termination bit
			
			ELSIF index = "001001" THEN
				index <= "001010";
				UART_TXD <= '1'; -- the first stop bit
			
			ELSIF index = "001010" THEN
				index <= "001011";
				UART_TXD <= '0'; -- the second start bit
			
			ELSIF index = "001011" THEN
				index <= "001100";
				UART_TXD <= Output(7);
			
			ELSIF index = "001100" THEN
				index <= "001101";
				UART_TXD <= Output(8);
			
			ELSIF index = "001101" THEN
				index <= "001110";
				UART_TXD <= Output(9);
			
			ELSIF index = "001110" THEN
				index <= "001111";
				UART_TXD <= Output(10);
			
			ELSIF index = "001111" THEN
				index <= "010000";
				UART_TXD <= Output(11);
			
			ELSIF index = "010000" THEN
				index <= "010001";
				UART_TXD <= Output(12);
			
			ELSIF index = "010001" THEN
				index <= "010010";
				UART_TXD <= Output(13);
			
			ELSIF index = "010010" THEN
				index <= "010011";
				UART_TXD <= '0'; -- the termination bit
			
			ELSIF index = "010011" THEN
				index <= "010100";
				UART_TXD <= '1'; -- the second stop bit
			
			ELSIF index = "010100" THEN
				index <= "010101";
				UART_TXD <= '0'; -- the third start bit
			
			ELSIF index = "010101" THEN
				index <= "010110";
				UART_TXD <= Output(14);
			
			ELSIF index = "010110" THEN
				index <= "010111";
				UART_TXD <= Output(15);
			
			ELSIF index = "010111" THEN
				index <= "011000";
				UART_TXD <= Output(16);
			
			ELSIF index = "011000" THEN
				index <= "011001";
				UART_TXD <= Output(17);
			
			ELSIF index = "011001" THEN
				index <= "011010";
				UART_TXD <= Output(18);
			
			ELSIF index = "011010" THEN
				index <= "011011";
				UART_TXD <= Output(19);
			
			ELSIF index = "011011" THEN
				index <= "011100";
				UART_TXD <= Output(20);
			
			ELSIF index = "011100" THEN
				index <= "011101";
				UART_TXD <= '0'; -- the termination bit
			
			ELSIF index = "011101" THEN
				index <= "011110";
				UART_TXD <= '1'; -- the third stop bit
			
			ELSIF index = "011110" THEN
				index <= "011111";
				UART_TXD <= '0'; -- the fourth start bit
			
			ELSIF index = "011111" THEN
				index <= "100000";
				UART_TXD <= Output(21);
			
			ELSIF index = "100000" THEN
				index <= "100001";
				UART_TXD <= Output(22);
			
			ELSIF index = "100001" THEN
				index <= "100010";
				UART_TXD <= Output(23);
			
			ELSIF index = "100010" THEN
				index <= "100011";
				UART_TXD <= Output(24);
			
			ELSIF index = "100011" THEN
				index <= "100100";
				UART_TXD <= Output(25);
			
			ELSIF index = "100100" THEN
				index <= "100101";
				UART_TXD <= Output(26);
			
			ELSIF index = "100101" THEN
				index <= "100110";
				UART_TXD <= Output(27);
			
			ELSIF index = "100110" THEN
				index <= "100111";
				UART_TXD <= '0'; -- the termination bit			
				
			ELSIF index = "100111" THEN
				index <= "101000";
				UART_TXD <= '1'; -- the fourth stop bit
			
			ELSIF index = "101000" THEN
				index <= "101001";
				UART_TXD <= '0'; -- the fifth start bit
			
			ELSIF index = "101001" THEN
				index <= "101010";
				UART_TXD <= Output(28);
			
			ELSIF index = "101010" THEN
				index <= "101011";
				UART_TXD <= Output(29);
			
			ELSIF index = "101011" THEN
				index <= "101100";
				UART_TXD <= Output(30);
			
			ELSIF index = "101100" THEN
				index <= "101101";
				UART_TXD <= Output(31);
			
			ELSIF index = "101101" THEN
				index <= "101110";
				UART_TXD <= '0';
			
			ELSIF index = "101110" THEN
				index <= "101111";
				UART_TXD <= '0';
			
			ELSIF index = "101111" THEN
				index <= "110000";
				UART_TXD <= '0';
			
			ELSIF index = "110000" THEN
				index <= "110001";
				UART_TXD <= '0';							
			
			ELSIF index = "110001" AND data_select = "000" THEN
				index <= "000000";
				data_select <= "001"; -- increments data_select to begin output of B
				Output <= B;
				UART_TXD <= '1'; -- the fifth stop bit

			ELSIF index = "110001" AND data_select = "001" THEN
				index <= "000000";
				data_select <= "010"; -- increments data_select to begin output of C
				Output <= C;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "010" THEN
				index <= "000000";
				data_select <= "011"; -- increments data_select to begin output of D
				Output <= D;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "011" THEN
				index <= "000000";
				data_select <= "100"; -- increments data_select to begin output of Coincidence_0
				Output <= E;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "100" THEN
				index <= "000000";
				data_select <= "101"; -- increments data_select to begin output of Coincidence_1
				Output <= F;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "101" THEN
				index <= "000000";
				data_select <= "110"; -- increments data_select to begin output of Coincidence_2
				Output <= G;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "110" THEN
				index <= "000000";
				data_select <= "111"; -- increments data_select to begin output of Coincidence_3
				Output <= H;
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110001" AND data_select = "111" THEN
				index <= "110010";
				UART_TXD <= '1'; -- the fifth stop bit
				
			ELSIF index = "110010" THEN
				index <= "111111";
				UART_TXD <= '0'; -- the start bit of the termination byte
			
			ELSE
				index <= "111111";
				UART_TXD <= '1'; -- sets all subsequent bits to negative voltage
			END IF;
		END IF;		
	END PROCESS;
END Behavior;