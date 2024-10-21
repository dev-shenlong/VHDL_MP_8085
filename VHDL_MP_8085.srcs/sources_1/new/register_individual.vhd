----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.10.2024 22:35:32
-- Design Name: 
-- Module Name: register_individual - Behavioral
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

--operation type --> 1 for read and 0 for write


--future development
--Create a startup entity that will set all registers to 0
-- might not work used wait statement might have to make it clock driven
entity register_individual is
    Generic
    (
        data_size: integer:=8
    );
    Port ( 
        operation_type: in std_logic;
        data_port: inout std_logic_vector(data_size-1 downto 0)
        
    );
end register_individual;
    
architecture Behavioral of register_individual is
    signal data: std_logic_vector(data_size-1 downto 0);
    
begin
    process is
    begin
        if operation_type = '0' then
           initialize_loop:for i in data_size-1 downto 0 loop
                data_port(i) <= 'Z';
           end loop initialize_loop;
           data <= data_port;
        elsif operation_type = '1' then
            data_port <= data;
        end if;
        wait;
    end process;

end Behavioral;
