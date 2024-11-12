library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity interrupt_controller is
    Port (
        clk : in std_logic;                         -- Clock signal
        irq_trap      : in  STD_LOGIC;  -- TRAP interrupt request
        irq_rst75     : in  STD_LOGIC;  -- RST 7.5
        irq_rst65     : in  STD_LOGIC;  -- RST 6.5
        irq_rst55     : in  STD_LOGIC;  -- RST 5.5
        irq_intr      : in  STD_LOGIC;  -- INTR interrupt request
        pc_in : in std_logic_vector(15 downto 0);   -- Input: Current value of pc from pc module
        pc_out : out std_logic_vector(15 downto 0); -- Output: Modified pc value to be sent to pc module
        interrupt_to_pc : out std_logic             -- Output: Control signal to pc module to stop incrementing
    );
end interrupt_controller;

architecture Behavioral of interrupt_controller is
    signal stored_pc : std_logic_vector(15 downto 0) := (others => '0'); -- Signal to store pc value during interrupt
    signal interrupt_state : std_logic := '0';                            -- Interrupt state (high during interrupt)
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if irq_trap = '1' and interrupt_state = '0' then
                -- Trigger the interrupt
                stored_pc <= pc_in;             -- Store the current pc value
                pc_out <=  "0000000000100100"; -- TRAP vector: 0024H;
                interrupt_to_pc <= '1';         -- Stop pc incrementing
                interrupt_state <= '1';         -- Set interrupt state to active
            
            elsif irq_rst75 = '1' and interrupt_state = '0' then
                -- Trigger the interrupt
                stored_pc <= pc_in;             -- Store the current pc value
                pc_out <=  "0000000000111100"; -- RST 7.5 vector: 003C
                interrupt_to_pc <= '1';         -- Stop pc incrementing
                interrupt_state <= '1';         -- Set interrupt state to active

            elsif irq_rst65 = '1' and interrupt_state = '0' then
                -- Trigger the interrupt
                stored_pc <= pc_in;             -- Store the current pc value
                pc_out <=   "0000000000110100"; -- RST 6.5 vector: 0034
                interrupt_to_pc <= '1';         -- Stop pc incrementing
                interrupt_state <= '1';         -- Set interrupt state to active

            elsif irq_rst55 = '1' and interrupt_state = '0' then
                -- Trigger the interrupt
                stored_pc <= pc_in;             -- Store the current pc value
                pc_out <=  "0000000000101100"; -- RST 5.5 vector: 002C
                interrupt_to_pc <= '1';         -- Stop pc incrementing
                interrupt_state <= '1';         -- Set interrupt state to active

            elsif irq_intr = '1' and interrupt_state = '0' then
                -- Trigger the interrupt
                stored_pc <= pc_in;             -- Store the current pc value
                pc_out <=  "1111111111111111"; -- INTR vector: FFFFH;
                interrupt_to_pc <= '1';         -- Stop pc incrementing
                interrupt_state <= '1';         -- Set interrupt state to active

            
            elsif interrupt_state = '1' then
                -- Restore the pc value on the next clock cycle
                pc_out <= stored_pc;            -- Restore original pc value
                interrupt_to_pc <= '0';         -- Allow pc to increment again
                interrupt_state <= '0';         -- Reset interrupt state

            else
                -- Normal operation (no interrupt)
                pc_out <= pc_in;                -- Pass through pc value
                interrupt_to_pc <= '0';         -- Ensure interrupt_to_pc is held low in normal operation
            end if;
        end if;
    end process;

end Behavioral;
