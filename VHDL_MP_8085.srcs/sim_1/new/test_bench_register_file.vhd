----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2024 03:57:51
-- Design Name: 
-- Module Name: test_bench_register_file - Behavioral
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

entity test_bench_register_file is
end test_bench_register_file;

architecture Behavioral of test_bench_register_file is

component register_file is
    Port ( 
        register_type: std_logic;
        register_code: in std_logic_vector(0 to 2);
        register_operation_type: in std_logic;
        data: inout std_logic_vector(15 downto 0) 
        );
end component register_file;

signal temp_register_type: std_logic:='1';
signal temp_register_code: std_logic_vector(0 to 2):="Z00";
signal temp_register_operation_type: std_logic:='0';
signal temp_data: std_logic_vector(15 downto 0) := "1010101001010101";

begin
inst: register_file port map(register_type=>temp_register_type,register_code=>temp_register_code, register_operation_type=>temp_register_operation_type, data=>temp_data );

process is 
begin
    wait for 10 ns;
    temp_register_operation_type <= '1';
    temp_data <= "ZZZZZZZZZZZZZZZZ";
    wait for 10 ns;
wait;
end process;

end Behavioral;
