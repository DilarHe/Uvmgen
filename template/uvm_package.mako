package ${module_name}_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // Include all generated UVM components
    `include "sequence_item.svh"
    `include "sequence.svh"
    `include "sequencer.svh"
    `include "scoreboard.svh"
    `include "driver.svh"
    `include "monitor.svh"
    `include "agent.svh"
    `include "env.svh"
    `include "test.svh"

endpackage : ${module_name}_pkg
