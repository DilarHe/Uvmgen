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
        ${module_name}_sequence_item seq_item;
        seq_item = ${module_name}_sequence_item::type_id::create("seq_item");
        seq_item.phy_addr = 5'h1;
        seq_item.reg_addr = 5'h2;
        seq_item.data_in = 16'h1234;

        env.driver.seq_item_port.start_item(seq_item);
        env.driver.seq_item_port.finish_item(seq_item);

        `uvm_info("${module_name}_TEST", $sformatf("Data out: %0h", seq_item.data_out), UVM_MEDIUM)
    endtask
endclass
