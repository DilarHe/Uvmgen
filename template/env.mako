class ${module_name}_env extends uvm_env;
    ${module_name}_driver driver;
    ${module_name}_monitor monitor;
    uvm_analysis_port #(${module_name}_sequence_item) ap;

    `uvm_component_utils(${module_name}_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = ${module_name}_driver::type_id::create("driver", this);
        monitor = ${module_name}_monitor::type_id::create("monitor", this);
        ap = new("ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        monitor.ap.connect(ap);
    endfunction
endclass
