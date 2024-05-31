class ${module_name}_agent extends uvm_agent;
    `uvm_component_utils(${module_name}_agent)

    ${module_name}_sequencer sequencer;
    ${module_name}_driver driver;
    ${module_name}_monitor monitor;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = ${module_name}_sequencer::type_id::create("sequencer", this);
        driver = ${module_name}_driver::type_id::create("driver", this);
        monitor = ${module_name}_monitor::type_id::create("monitor", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.agent = this;
    endfunction

endclass
