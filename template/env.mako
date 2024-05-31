class ${module_name}_env extends uvm_env;
    `uvm_component_utils(${module_name}_env)

    ${module_name}_agent agent;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = ${module_name}_agent::type_id::create("agent", this);
    endfunction

endclass
