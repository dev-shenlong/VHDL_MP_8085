library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_pc_interrupt is
end tb_pc_interrupt;

architecture Behavioral of tb_pc_interrupt is
    -- Signals for testbench
    signal clk : std_logic := '0';
    signal pc_out_internal : std_logic_vector(15 downto 0);
    signal interrupt_to_pc : std_logic := '0';  -- Initialize to '0' to allow pc_counter to increment
    signal pc_out : std_logic_vector(15 downto 0);
    signal irq_trap : std_logic := '0';
    signal irq_rst75 : std_logic := '0';
    signal irq_rst65 : std_logic := '0';
    signal irq_rst55 : std_logic := '0';
    signal irq_intr : std_logic := '0';

    -- Clock period definition
    constant clk_period : time := 10 ns;

    -- Instantiate pc_counter (Program Counter) component
    component pc_counter
        Port (
            pc_out : out std_logic_vector(15 downto 0);
            interrupt_to_pc : in std_logic;
            clk : in std_logic
        );
    end component;

    -- Instantiate interrupt_controller component
    component interrupt_controller
        Port (
            clk : in std_logic;
            irq_trap      : in  STD_LOGIC;  -- TRAP interrupt request
            irq_rst75     : in  STD_LOGIC;  -- RST 7.5
            irq_rst65     : in  STD_LOGIC;  -- RST 6.5
            irq_rst55     : in  STD_LOGIC;  -- RST 5.5
            irq_intr      : in  STD_LOGIC;  -- INTR interrupt request
            pc_in : in std_logic_vector(15 downto 0);
            pc_out : out std_logic_vector(15 downto 0);
            interrupt_to_pc : out std_logic
        );
    end component;

begin
    -- Instantiate the pc_counter module (UUT)
    pc_counter_inst : pc_counter
        Port map (
            pc_out => pc_out_internal,
            interrupt_to_pc => interrupt_to_pc,
            clk => clk
        );

    -- Instantiate the interrupt_controller module
    interrupt_controller_inst : interrupt_controller
        Port map (
            clk => clk,
            irq_trap         => irq_trap,
            irq_rst75        => irq_rst75,
            irq_rst65        => irq_rst65,
            irq_rst55        => irq_rst55,
            irq_intr         => irq_intr,
            pc_in => pc_out_internal,
            pc_out => pc_out,
            interrupt_to_pc => interrupt_to_pc
        );

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process to test interrupt behavior
    stim_proc: process
    begin
        -- Normal operation (no interrupt), observe pc incrementing
        wait for 50 ns;

        -- Trigger interrupt by setting interrupt_request high
        irq_trap <= '1';
        wait for clk_period; -- Wait one clock cycle to observe FFFF in pc_out
        irq_trap <= '0';
        wait for 10 ns;
        irq_rst75 <= '1';
        wait for clk_period;       -- Observe pc returns to normal increment
        irq_rst75 <= '0';
        wait for 80 ns;
        
        irq_rst65 <= '1';
        irq_rst55 <= '1';
        wait for clk_period;
        irq_rst65 <= '0';
        irq_rst55 <= '0';
  
        
        wait for 30 ns;
        -- Finish simulation
        wait;
    end process;

end Behavioral;
