library verilog;
use verilog.vl_types.all;
entity keycheck is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        key             : in     vl_logic;
        key_v           : out    vl_logic
    );
end keycheck;
