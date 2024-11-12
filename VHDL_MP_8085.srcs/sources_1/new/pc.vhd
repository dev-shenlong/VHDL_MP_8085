library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity pc_counter is
  Port (pc_out : out std_logic_vector(15 downto 0);  -- Renamed output port
        interrupt_to_pc : in std_logic;
        clk : in std_logic );
end pc_counter;

architecture Behavioral of pc_counter is
    signal pc_reg : unsigned(15 downto 0) := (others => '0');  -- Initialize pc_reg to zero
begin
    -- Process to update pc on clock's rising edge
    process(clk)
    begin
        if rising_edge(clk) then
            if interrupt_to_pc = '0' then
                pc_reg <= pc_reg + 1;  -- Increment internal register on each clock cycle
            end if;
        end if;
    end process;

    -- Output assignment
    pc_out <= std_logic_vector(pc_reg);  -- Assign internal register to output
end Behavioral;
