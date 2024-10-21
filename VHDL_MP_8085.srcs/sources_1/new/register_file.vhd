----------------------------------------------------------------------------------
-- Group: Dipanshu and Aryan
-- 
-- Create Date: 20.10.2024 22:20:42
-- Design Name: 
-- Module Name: register_file - Behavioral
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

library work;
use work;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- 8 bit Register Code

-- B 000
-- C 001
-- D 010
-- E 011
-- H 100
-- L 101
-- M 110
-- A 111
-- 16 bit Register Code
-- BC 00
-- DE 01
-- HL 10
-- PSW 11
-- PC 100


--PORTS
-- Register type 0 for 8 bit and 1 for 16 bit

entity register_file is
    Port ( 
        register_type: std_logic;
        register_code: in std_logic_vector(2 downto 0);
        register_operation_type: in std_logic;
        data: inout std_logic_vector(15 downto 0) 
        
    );
end register_file;

architecture Behavioral of register_file is
    component register_individual is
        Generic
        (
            data_size: integer:=8
        );
        Port ( 
            operation_type: in std_logic;
            data_port: inout std_logic_vector(data_size-1 downto 0)
            
        );
    end component register_individual;
    signal temp_data_8_bit: std_logic_vector(7 downto 0):="ZZZZZZZZ";
begin
    generate_8bit: for i in 0 to 7 generate
        register_8bit: register_individual generic map(data_size => 8) port map(operation_type => register_operation_type, data_port => temp_data_8_bit);
    end generate generate_8bit;
end Behavioral;
