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
        seq.start(env.driver.seq_item_port);

        //`uvm_info("${module_name}_TEST", $sformatf("Data out: %0h", seq_item.data_out), UVM_MEDIUM)
    endtask

endclass
