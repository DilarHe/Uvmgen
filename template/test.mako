class ${module_name}_test extends uvm_test;
    ${module_name}_env env;

    `uvm_component_utils(${module_name}_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = ${module_name}_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        ${module_name}_sequence seq;

        // Create the sequence
        seq = ${module_name}_sequence::type_id::create("seq");

        // Start the sequence
        phase.raise_objection(this);
        `uvm_info("TEST", "Starting sequence", UVM_LOW)
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask

endclass
