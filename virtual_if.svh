// Define virtual interface for mdio_master
interface mdio_master_if（input clk, input rstn);
    // Define interface signals
    wire  clk;
    wire  reset;
    wire  start;
    wire [4:0] phy_addr;
    wire [4:0] reg_addr;
    wire [15:0] data_in;
    wire  write;
    reg [15:0] data_out;
    reg  ready;
    reg  mdio;
    reg  mdc;
endinterface : mdio_master_if
