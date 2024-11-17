library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_processor is
  Port (clk, reset: in std_logic;
  DoData, RD, WR: out std_logic;
  PC: inout std_logic_vector(15 downto 0);
  instruction_register: out std_logic_vector(7 downto 0);
  IOM, ALE, S1, S0: out std_logic;
  A: out std_logic_vector(15 downto 8);
  AD: inout std_logic_vector(7 downto 0);
  bytes: inout std_logic_vector(1 downto 0));
end instruction_processor;

architecture Behavioral of instruction_processor is
  signal pc_int: std_logic_vector(15 downto 0) := "0000000000000000";
  signal next_pc: std_logic_vector(15 downto 0);
  signal branch: std_logic := '1';
  signal int_inst: std_logic_vector(7 downto 0);
  
  type instruction_decoder_state is (T1, T2, T3);
  signal curr_state, next_state: instruction_decoder_state := T1;

begin

  process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        curr_state <= T1;
        pc_int <= (others => '0');
        PC <= (others => '0');
      else
        curr_state <= next_state;  -- Update curr_state here
        pc_int <= next_pc;          -- Update pc_int here
      end if;
    end if;
  end process;

  process(curr_state, pc_int) is
  begin
    -- Default signal values
    DoData <= '0';
    WR <= '0';
    RD <= '0';
    ALE <= '0';
    IOM <= '0';
    S1 <= '0';
    S0 <= '0';
    next_state <= curr_state;  -- Default to stay in current state
    next_pc <= pc_int;          -- Default next PC to current PC

    case curr_state is
      when T1 =>
        ALE <= '1';
        A <= pc_int(15 downto 8);
        AD <= pc_int(7 downto 0);
        next_state <= T2;  -- Prepare for the next state

      when T2 =>
        IOM <= '0';
        S1 <= '1';
        S0 <= '1';
        ALE <= '0';
        WR <= '1';
        RD <= '0';
        int_inst <= AD;
        next_state <= T3;  -- Prepare for the next state

      when T3 =>
        IOM <= '0';
        S1 <= '1';
        S0 <= '1';
        ALE <= '0';
        WR <= '0';
        RD <= '1';
        if branch = '1' then
          next_pc <= std_logic_vector(unsigned(pc_int) + 1);  -- Increment PC
          instruction_register <= int_inst;
          DoData <= '1';
        else
          next_pc <= pc_int;  -- Maintain current PC if no branch
        end if;
        next_state <= T1;  -- Prepare for the next state

      when others =>
        next_state <= T1;  -- Default case
    end case;
  end process;

  PC <= next_pc;  -- Drive the PC output

end Behavioral;
