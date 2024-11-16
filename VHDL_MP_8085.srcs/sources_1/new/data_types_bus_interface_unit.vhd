----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.10.2024 21:47:19
-- Design Name: 
-- Module Name: data_types_bus_interface_unit - Behavioral
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

package data_types_bus_interface_unit is
    type bus_interface_cmd is (idle, move, read, write, op_code_fetch,interrupt); -- This is an internal type for the decoder to keep track of what command to perform

end package;

