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
  AD, H, L: inout std_logic_vector(7 downto 0);
  bytes: inout std_logic_vector(1 downto 0);
  byte1, byte2: out std_logic_vector(7 downto 0);
  psw: in std_logic_vector(7 downto 0);
  stack_pointer: inout std_logic_vector(15 downto 0);
  interrupt: in std_logic);
end instruction_processor;

architecture Behavioral of instruction_processor is
  signal pc_int: std_logic_vector(15 downto 0) := "0000000000000000";
  signal next_pc,sp,next_sp: std_logic_vector(15 downto 0);
  signal branch: std_logic := '0';
  signal int_inst: std_logic_vector(7 downto 0);
  signal bytes_reqd: std_logic_vector(1 downto 0):="00";
  signal b1,b2: std_logic_vector(7 downto 0);
  type instruction_decoder_state is (T1, T2, T3, Fetch_op1, Fetch_op11, Fetch_op2, Fetch_op22);
  signal curr_state, next_state: instruction_decoder_state := T1;

begin

  process(clk) is
  begin
    if rising_edge(clk) then
      if reset = '1' then
        curr_state <= T1;
        pc_int <= (others => '0');
        PC <= (others => '0');
      elsif interrupt = '1' then
        curr_state <= curr_state;
        pc_int <= pc_int;
      else
        curr_state <= next_state;  -- Update curr_state here
        pc_int <= next_pc;          -- Update pc_int here
        sp <= next_sp;
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
        pc_int <= PC;
        bytes_reqd <= "00";
        branch <= '0';
        A <= pc_int(15 downto 8);
        AD <= pc_int(7 downto 0);
        ALE <= '1';
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
        
--        if branch = '1' then
--          next_pc <= std_logic_vector(unsigned(pc_int) + 1);  -- Increment PC
--          instruction_register <= int_inst;
--          DoData <= '1';
--        else
--          next_pc <= pc_int;  -- Maintain current PC if no branch
--        end if;
--        next_state <= T1;  -- Prepare for the next state
        if int_inst(7 downto 6) = "01" then
            if int_inst(5 downto 3) = "110" or int_inst(2 downto 0) = "110" then
                bytes_reqd <= "01";
            end if;
        elsif int_inst(7 downto 6) = "00" then
            if int_inst(3 downto 0) = "0001" then
                bytes_reqd <= "10";
            elsif int_inst(2 downto 0) = "010" then
                if (int_inst(5 downto 3) = "100") or (int_inst(5 downto 3) = "101") or (int_inst(5 downto 3) = "110") or (int_inst(5 downto 3) = "111")  then
                    bytes_reqd <= "10";
                end if;
            elsif int_inst(2 downto 0) = "110" then
                bytes_reqd <= "01";
            end if;
        elsif int_inst(7 downto 6) = "10" then
            if int_inst(2 downto 0) = "110" then
                bytes_reqd <= "01";
            end if;
        elsif int_inst(7 downto 6) = "11" then
            if (int_inst(3 downto 0) = "1101") or (int_inst(2 downto 0) = "100") or (int_inst(2 downto 0) = "010") then
                bytes_reqd <= "10";
            elsif int_inst(2 downto 0) = "011" then
                if int_inst(5 downto 3) = "000" then
                    bytes_reqd <= "10";
                elsif (int_inst(5 downto 3) = "010") or (int_inst(5 downto 3) = "011") then
                    bytes_reqd <= "01";
                end if;
            end if;
        end if;
        if (int_inst(7 downto 6) = "11") and ((int_inst(2 downto 0) = "111")) then
            branch <= '1';
            if int_inst(5 downto 3) = "000" then
                next_pc <= "0000000000000000";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "001" then
                next_pc <= "0000000000001000";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "010" then
                next_pc <= "0000000000001010";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "011" then
                next_pc <= "0000000000010010";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "100" then
                next_pc <= "0000000000010100";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "101" then
                next_pc <= "0000000000011100";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "110" then
                next_pc <= "0000000000011110";
                next_state <= T1;
            elsif int_inst(5 downto 3) = "111" then
                next_pc <= "0000000000100110";
                next_state <= T1;
            end if;
        elsif int_inst(7 downto 0) = x"c2" or
            int_inst(7 downto 0) = x"c3" or
            int_inst(7 downto 0) = x"c4" or
            int_inst(7 downto 0) = x"ca" or
            int_inst(7 downto 0) = x"d2" or
            int_inst(7 downto 0) = x"da" or
            int_inst(7 downto 0) = x"e2" or
            int_inst(7 downto 0) = x"ea" or
            int_inst(7 downto 0) = x"f2" or
            int_inst(7 downto 0) = x"fa" or
            int_inst(7 downto 0) = x"e9" or
            int_inst(7 downto 0) = x"cd" or
            int_inst(7 downto 0) = x"cc" or
            int_inst(7 downto 0) = x"d4" or
            int_inst(7 downto 0) = x"dc" or
            int_inst(7 downto 0) = x"e4" or
            int_inst(7 downto 0) = x"ec" or
            int_inst(7 downto 0) = x"f4" or
            int_inst(7 downto 0) = x"fc" or
            int_inst(7 downto 0) = x"c9" or
            int_inst(7 downto 0) = x"c0" or
            int_inst(7 downto 0) = x"c8" or
            int_inst(7 downto 0) = x"d0" or
            int_inst(7 downto 0) = x"d8" or
            int_inst(7 downto 0) = x"e0" or
            int_inst(7 downto 0) = x"e8" or
            int_inst(7 downto 0) = x"f0" or
            int_inst(7 downto 0) = x"f8" then
            branch <= '1';
            next_pc <= std_logic_vector(unsigned(pc_int) + 1);
            next_state <= T1;
        else 
            next_pc <= std_logic_vector(unsigned(pc_int) + 1);
            DoData <= '1';
            next_state <= T1;
        end if;
        if (bytes_reqd <= "01") or (bytes_reqd <= "10") then
            next_state <= Fetch_op1;
        end if;
        if branch = '1' then
            if (int_inst(3 downto 0) = x"0") or (int_inst(3 downto 0) = x"8") or (int_inst(3 downto 0) = x"9") then
                next_pc <= H & L;
                next_sp <= std_logic_vector(unsigned(sp) - 1);
            end if;
        end if;
      when Fetch_op1 =>
        A <= pc_int(15 downto 8);
        AD <= pc_int(7 downto 0);
        ALE <= '1';
        next_state <= Fetch_op11;
      when Fetch_op11 =>
        ALE <= '0';
        b1 <= AD;
        bytes_reqd <= std_logic_vector(unsigned(bytes_reqd) - 1);
        if bytes_reqd = "00" then
            next_pc <= std_logic_vector(unsigned(pc_int) + 1);
            DoData <= '1';
            next_state <= T1;
        elsif bytes_reqd = "01" then
            next_pc <= std_logic_vector(unsigned(pc_int) + 1);
            next_state <= Fetch_op2;
        end if;
      when Fetch_op2 =>
        A <= pc_int(15 downto 8);
        AD <= pc_int(7 downto 0);
        ALE <= '1';
        next_state <= Fetch_op22;
      when Fetch_op22 =>
        ALE <= '0';
        b2 <= AD;
        next_pc <= std_logic_vector(unsigned(pc_int) + 1);
        bytes_reqd <= std_logic_vector(unsigned(bytes_reqd) - 1);
        if branch = '1' then
            next_pc <= b1 & b2;
            if (int_inst(3 downto 0) = x"d") or (int_inst(3 downto 0) = x"4") or (int_inst(3 downto 0) = x"c") then
                H <= b1;
                L <= b2;
                next_sp <= std_logic_vector(unsigned(sp) + 1);
            end if;
        else 
            DoData <= '1';
        end if;
        next_state <= T1;
      when others =>
        next_state <= T1;  -- Default case
    end case;
  end process;

  PC <= pc_int;  -- Drive the PC output
  bytes <= bytes_reqd;
  byte1 <= b1;
  byte2 <= b2;
  stack_pointer <= sp;

end Behavioral;
