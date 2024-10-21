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

entity bus_interface_unit is
    Generic (
        clk:std_logic   -- The clock input internally connected
        
    );
    Port (
        A: out std_logic_vector(7 downto 0); -- Address bus that carry the higher address bus
        AD: inout std_logic_vector(7 downto 0); -- Address and Data bus multiplexed with lower Adrress bus
        S: out std_logic_vector(1 downto 0);
        io_not_m : out std_logic;
        start: in std_logic;
        done: out std_logic; -- Status 
        command: in std_logic_vector(7 downto 0) -- DoData Pulse to interpret which command to carry out
   );
   
end bus_interface_unit;

architecture Behavioral of bus_interface_unit is
    component bus_interface_instruction_decoder is
    end component;
    
begin


end Behavioral;
