class ${module_name}_driver extends uvm_driver #(${module_name}_sequence_item);
    virtual ${module_name}_if vif;
    uvm_analysis_port #(${module_name}_sequence_item) ap;
    `uvm_component_utils(${module_name}_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if(!uvm_config_db #(virtual ${module_name}_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface specified for driver")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            ${module_name}_sequence_item req;
            seq_item_port.get_next_item(req);
            drive_transfer(req);
            seq_item_port.item_done();
            ap.write(req);
        end
    endtask

    task drive_transfer(${module_name}_sequence_item item);
        // Drive the transaction onto the interface
% for direction, typ, width, name in ports:
% if direction == "input":
        vif.${name} <= item.${name};
% endif
% endfor
        // Wait for some time (e.g., clock cycles)
        // Synchronize with the clock edge, it may be necessary to carry on simulation
        @(posedge vif.clk);
    endtask
endclass
