// Define virtual interface for mdio_master
interface mdio_master_if;
    // Define interface signals
    input wire clk;
    input wire reset;
    input wire start;
    input wire [4:0] phy_addr;
    input wire [4:0] reg_addr;
    input wire [15:0] data_in;
    input wire write;
    output reg [15:0] data_out;
    output reg ready;
    output reg mdio;
    output reg mdc              // MDIO clock line;
endinterface : mdio_master_if
