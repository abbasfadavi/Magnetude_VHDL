----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;
----------------------------------------------------------------------------------
entity main is
generic 
(
   processing_element : integer := 5;
   nbit : integer := 64
);
    Port 
    (
		clk		    : in  STD_LOGIC;
		in1		    : in  STD_LOGIC_VECTOR (nbit-1 downto 0);
		in2		    : in  STD_LOGIC_VECTOR (nbit-1 downto 0);
		magnitude  	: out STD_LOGIC_VECTOR (nbit-1 downto 0)
		);
end main;
----------------------------------------------------------------------------------
architecture Behavioral of main is
----------------------------------------------------------------------------------
type data is array (0 TO processing_element) of std_logic_vector(nbit-1 downto 0);
signal sig1 : data;
signal sig2 : data;
signal sh1 	: data;
signal sh2  : data;
----------------------------------------------------------------------------------
COMPONENT cor
  PORT 
  (
		clk		: in  STD_LOGIC;
		n		: in  integer;
		in1		: in  STD_LOGIC_VECTOR (nbit-1 downto 0);
		in2		: in  STD_LOGIC_VECTOR (nbit-1 downto 0);
		out1	: out STD_LOGIC_VECTOR (nbit-1 downto 0);
		out2	: out STD_LOGIC_VECTOR (nbit-1 downto 0)
  );
END COMPONENT;
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
 sig1(0) <= std_logic_vector(abs(signed(in1)));
 sig2(0) <= in2;
 GENERATE_FOR: for ii in 0 to processing_element-1 generate  
    sh1(ii) <= std_logic_vector(shift_right(signed(sig1(ii)),ii));
    sh2(ii) <= std_logic_vector(shift_right(signed(sig2(ii)),ii));   
    sig1(ii+1)  <= std_logic_vector(signed( sig1(ii)) - signed(sh2(ii))) when (sig2(ii)(63) = '1') else std_logic_vector(signed( sig1(ii)) + signed(sh2(ii)));
    sig2(ii+1)  <= std_logic_vector(signed( sig2(ii)) - signed(sh1(ii))) when (sig2(ii)(63) = '0') else std_logic_vector(signed( sig2(ii)) + signed(sh1(ii)));
  end generate GENERATE_FOR;
  magnitude <= sig1(processing_element);
----------------------------------------------------------------------------------
end Behavioral;

