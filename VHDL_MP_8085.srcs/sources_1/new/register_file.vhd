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
-- BC Z00
-- DE Z01
-- HL Z10
-- PSW Z11 -- Not donne yet
-- PC 100 


--PORTS
-- Register type 0 for 8 bit and 1 for 16 bit
-- Register Code is the code for each as detailed above
-- data is the data to be written / read from
-- register operation type 1 for read and 0 for write

entity register_file is
    Port ( 
        register_type: std_logic;
        register_code: in std_logic_vector(0 to 2);
        register_operation_type: in std_logic;
        data: inout std_logic_vector(15 downto 0)
        );
end register_file;

architecture Behavioral of register_file is
        signal A,B,C,D,E,H,L: std_logic_vector(7 downto 0):= "ZZZZZZZZ";
        signal PSW, PC, SP: std_logic_vector(15 downto 0):= "ZZZZZZZZZZZZZZZZ";
begin
    process(register_type, register_code, register_operation_type, data) is
    
    begin
        data<= "ZZZZZZZZZZZZZZZZ";
        if register_type = '0' then
            select_register_8_bit: case register_code is
            
                when "000" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= B;
                    elsif register_operation_type = '0' then

                        B <= data(7 downto 0);
                    end if;
                when "001" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= C;
                    elsif register_operation_type = '0' then
                        C <= data(7 downto 0);
                    end if;
                when "010" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= D;
                    elsif register_operation_type = '0' then
                        D<= data(7 downto 0);
                    end if;
                when "011" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= E;
                    elsif register_operation_type = '0' then
                        E <= data(7 downto 0);
                    end if;
                when "100" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= H;
                    elsif register_operation_type = '0' then
                        H <= data(7 downto 0);
                    end if;
                when "101" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= L;
                    elsif register_operation_type = '0' then
                        L <= data(7 downto 0);
                    end if;
                when "111" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= A;
                    elsif register_operation_type = '0' then
                        A <= data(7 downto 0);
                    end if;
                when others =>
                        assert 1 /=1 report "Incorrect Register code" severity error;
            end case ;
        else
             select_register_16_bit: case register_code is
            
                when "Z00" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= C;
                        data(15 downto 8) <= B;
                    elsif register_operation_type = '0' then
                        B <= data(15 downto 8);
                        C <=data(7 downto 0);
                    end if;
                when "Z01" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= E;
                        data(15 downto 8) <= D;
                    elsif register_operation_type = '0' then
                        D <= data(15 downto 8);
                        E <=data(7 downto 0);
                    end if;
                when "Z10" =>
                    if register_operation_type = '1' then
                        data(7 downto 0) <= L;
                        data(15 downto 8) <= H;
                    elsif register_operation_type = '0' then
                        H <= data(15 downto 8);
                        L <=data(7 downto 0);
                    end if;
                when others =>
                        assert 1 /=1 report "Incorrect Register code" severity error;
            end case ;
        end if;
    end process;   
end Behavioral;
