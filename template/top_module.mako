module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    bit clk;
    bit rst_n;
    ${module_name}_if vif();

    // Instantiate the DUT
    ${module_name} dut (
% for i, (direction, typ, width, name) in enumerate(ports):
% if i < len(ports) - 1:
        .${name}(vif.${name}),
% else:
        .${name}(vif.${name})
% endif
% endfor
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end
    //  Generate Waveform
    initial begin
        $fsdbDumpfile("${module_name}_tb.fsdb");
        $fsdbDumpvars(0,tb_top);
    end

    // UVM configuration
    initial begin
        uvm_config_db#(virtual ${module_name}_if)::set(null, "uvm_test_top.env.agent.driver", "vif", vif);
        uvm_config_db#(virtual ${module_name}_if)::set(null, "uvm_test_top.env.agent.monitor", "vif", vif);
        run_test("${module_name}_test");
    end
endmodule
