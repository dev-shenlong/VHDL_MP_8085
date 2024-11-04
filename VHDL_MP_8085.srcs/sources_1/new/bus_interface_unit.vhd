----------------------------------------------------------------------------------
-- Group: Dipanshu and Aryan 
-- 
-- 
-- Create Date: 20.10.2024 20:58:57
-- Design Name: 
-- Module Name: bus_interface_unit - Behavioral
-- Project Name: 8085 MP
-- Target Devices: XCS750 CSGA324ABX2321 
-- Tool Versions: 
-- Description: This file describes the bus interface unit of the 8085 MP
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
use work.data_types_bus_interface_unit.all;
entity bus_interface_unit is
    Generic (
        clk:std_logic   -- The clock input internally connected
        
    );
    Port (
        A: out std_logic_vector(7 downto 0); -- Address bus that carry the higher address bus
        AD: inout std_logic_vector(7 downto 0); -- Address and Data bus multiplexed with lower Adrress bus
        S: inout std_logic_vector(1 downto 0):="ZZ";
        io_not_m : inout std_logic:='Z';
        start: in std_logic;
        done: out std_logic; -- Status 
        command: in std_logic_vector(7 downto 0) -- DoData Pulse to interpret which command to carry out
   );
   
end bus_interface_unit;

architecture Behavioral of bus_interface_unit is
    --get instruction and set the type
    component bus_interface_instruction_decoder is
    end component;
    
    signal cmd_to_be_executed: bus_interface_cmd := idle;
    
begin
    

end Behavioral;
