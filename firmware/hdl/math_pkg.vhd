
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


package math_pkg is
	function log2c(constant value                : in integer) return integer;
	function log2f(constant value                : in integer) return integer;
	function min(constant value1, value2         : in integer) return integer;
	-- Returns the maximum of the two operands
	function max(constant value1, value2         : in integer) return integer;
	-- Returns the maximum of the three operands
	function max(constant value1, value2, value3 : in integer) return integer;
end package;

package body math_pkg is
	 function log2c(constant value : in integer) return integer is
        variable ret_value : integer;
        variable cur_value : integer;
    begin
        ret_value := 0;
        cur_value := 1;

        while cur_value < value loop
            ret_value := ret_value + 1;
            cur_value := cur_value * 2;
        end loop;
        return ret_value;
    end function log2c;

    function log2f(constant value : in integer) return integer is
        variable ret_value : integer;
        variable cur_value : integer;
    begin
        ret_value := 0;
        cur_value := 1;

        while cur_value < value loop
            ret_value := ret_value + 1;
            cur_value := cur_value * 2;
        end loop;
        if cur_value = value then
            return ret_value;
        else
            return ret_value-1;
        end if;
    end function log2f;

    function max(constant value1, value2 : in integer) return integer is
        variable ret_value : integer;
    begin
        if value1 > value2 then
            ret_value := value1;
        else
            ret_value := value2;
        end if;
        return ret_value;
    end function max;

    function max(constant value1, value2, value3 : in integer) return integer is
    begin
        return max(max(value1, value2), value3);
    end function max;
    
     function min(constant value1, value2 : in integer) return integer is
        variable ret_value : integer;
    begin
        if value1 < value2 then
            return value1;
        else
            ret_value := value2;
        end if;
        return ret_value;
    end function;

end;

