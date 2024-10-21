----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.10.2024 21:47:46
-- Design Name: 
-- Module Name: interrupt - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity InterruptController is
    Port ( clk           : in  STD_LOGIC;
           reset         : in  STD_LOGIC;
           irq_trap      : in  STD_LOGIC;  -- TRAP interrupt request
           irq_rst75     : in  STD_LOGIC;  -- RST 7.5
           irq_rst65     : in  STD_LOGIC;  -- RST 6.5
           irq_rst55     : in  STD_LOGIC;  -- RST 5.5
           irq_intr      : in  STD_LOGIC;  -- INTR interrupt request
           pc            : inout STD_LOGIC_VECTOR(15 downto 0);  -- Program Counter
           stack         : inout STD_LOGIC_VECTOR(15 downto 0);  -- Stack for saving state
           isr_vector    : in  STD_LOGIC_VECTOR(15 downto 0); -- ISR vector address
           interrupt_to_bus: out STD_LOGIC); -- Signal to the BUS to read the instruction coming from the software
end InterruptController;

architecture Behavioral of InterruptController is
    type state_type is (IDLE, SAVE_STATE, LOAD_VECTOR, EXECUTE_ISR, RESTORE_STATE, RESUME);
    signal current_state, next_state : state_type;
    signal interrupt_vector : STD_LOGIC_VECTOR(15 downto 0);

begin
    -- State transition process
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            pc <= (others => '0');
            stack <= (others => '0');
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Next state logic
    process(current_state, irq_trap, irq_rst75, irq_rst65, irq_rst55, irq_intr)
    begin
        case current_state is
            when IDLE =>
                if irq_trap = '1' then
                    interrupt_vector <= "0000000000100100"; -- TRAP vector: 0024H
                    next_state <= SAVE_STATE;
                    
                elsif irq_rst75 = '1' then
                    interrupt_vector <= "0000000000111100"; -- RST 7.5 vector: 003C
                    next_state <= SAVE_STATE;
                    
                elsif irq_rst65 = '1' then
                    interrupt_vector <= "0000000000110100"; -- RST 6.5 vector: 0034
                    next_state <= SAVE_STATE;
                    
                elsif irq_rst55 = '1' then
                    interrupt_vector <= "0000000000101100"; -- RST 5.5 vector: 002C
                    next_state <= SAVE_STATE;
                    
                elsif irq_intr = '1' then
                    interrupt_to_bus <= '1';
                    next_state <= SAVE_STATE;
                else
                    next_state <= IDLE;
                end if;

            when SAVE_STATE =>
                -- Logic to save current PC and flags to the stack
                stack <= pc; 
                next_state <= LOAD_VECTOR;

            when LOAD_VECTOR =>
                -- Load ISR address into PC
                pc <= interrupt_vector;
                next_state <= EXECUTE_ISR;

            when EXECUTE_ISR =>
                
                next_state <= RESTORE_STATE;

            when RESTORE_STATE =>
                -- Logic to restore PC and flags from the stack
                pc <= stack;
                next_state <= RESUME;

            when RESUME =>
                -- Resume normal operation
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;

        end case;
    end process;
    
end Behavioral;
