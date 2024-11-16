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
        S1: inout std_logic:='Z';
        S0: inout std_logic:='Z';
        io_not_m : inout std_logic:='Z';
        RD_not: out std_logic;
        WR_not:out std_logic;
        ale: inout std_logic:='Z';
        done: out std_logic; -- Status 
   );
   
end bus_interface_unit;

architecture Behavioral of bus_interface_unit is
    --get instruction and set the type
    component bus_interface_instruction_decoder is
    end component;
    
    signal cmd_to_be_executed: bus_interface_cmd := idle;
    signal address: std_logic_vector(15 downto 0):="ZZZZZZZZZZZZZZZZ";
    signal data_buffer: std_logic_vector(7 downto 0):= "ZZZZZZZZ";
    signal command:std_logic_vector(7 downto 0);
    
begin
    

    opcode_control_process: process(clk, ale,command)
        if(rising_edge(ale)) then
            begin
                command := "ZZZZZZZZ";
                cmd_to_be_executed <= op_code_fetch;

                command_instruct:case(command(5 downto 3))
                    when "000" => --STAX command B

                    when "001" => -- LDAX command B
                    when "010" => -- STAX D
                    when "011" => -- LDAX D
                    when "100" => --SHLD
                    when "101" => -- LHLD
                    when "110" => -- STA
                    when "111" => -- LDA
            end case command_instruct;
        end if;
    end process opcode_control_process;

    bus_interface_fsm: process(cmd_to_be_executed )
        variable stage: integer:=0;
    begin
        cmd_fsm: case(cmd_to_be_executed) is
                    when op_code_fetch => --Need to be tested
                        case(stage) is
                            when 0 =>
                                if falling_edge(clk) then
                                    ale <= '1';
                                    A<= address(15 downto 8);
                                    AD <= address(7 downto 0);
                                    S1 <= '1'; -- S1 is 1 and S0 is 1
                                    S0 <= '1';
                                    io_not_m <= '0';
                                    RD_not <='1';
                                    WR_not <='1';
                                    stage := stage +1;
                                end if;
                            when 1=>
                                if rising_edge(clk) then
                                    ale <='0';
                                    stage := stage +1;
                                    
                                end if;
                            when 2 =>
                                if falling_edge(clk) then
                                    AD <= "ZZZZZZZZ";
                                    RD_not <= '0';
                                end if;
                                if rising_edge(clk) then
                                
                                    command <= AD;
                                    stage := stage + 1;

                                end if;
                            others =>
                                stage := 0;
                                
                        end case;
                        
                    when read =>  --Test later
                        case(stage) is
                            when 0 =>
                                if falling_edge(clk) then
                                    ale <= '1';
                                    A<= address(15 downto 8);
                                    AD <= address(7 downto 0);
                                    S1 <= '1'; -- S1 is 1 and S0 is 0
                                    S0 <= '0';
                                    io_not_m <= '0';
                                    RD_not <='1';
                                    WR_not <='1';
                                    stage := stage +1;
                                end if;
                            when 1=>
                                if rising_edge(clk) then
                                    ale <='0';
                                    stage := stage +1;
                                    
                                end if;
                            when 2 =>
                                if falling_edge(clk) then
                                    AD <= "ZZZZZZZZ";
                                    RD_not <= '0';
                                end if;
                                if rising_edge(clk) then
                                
                                    data_buffer <= AD;
                                    stage := stage + 1;
                                end if;
                            others =>
                                stage := 0;
                                
                        end case;
                    when write => --Testing required
                        case(stage) is
                            when 0 =>
                                if falling_edge(clk) then
                                    ale <= '1';
                                    A<= address(15 downto 8);
                                    AD <= address(7 downto 0);
                                    S1 <= '0'; -- S1 is 0 and S0 is 1
                                    S0 <= '1';
                                    io_not_m <= '0';
                                    RD_not <= '1';
                                    WR_not <= '1';
                                    stage := stage +1;
                                end if;
                            when 1=>
                                if rising_edge(clk) then
                                    ale <='0';
                                    stage := stage +1;
                                end if;
                            when 2 =>
                                if falling_edge(clk) then
                                    AD <= data_buffer;
                                    WR_not <= '0'
                                end if;
                            others =>
                                stage := 0;
                                
                        end case;

                


        end case cmd_fsm;
    end process bus_interface_fsm;

end Behavioral;

