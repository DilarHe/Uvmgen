class ${module_name}_driver extends uvm_driver #(${module_name}_sequence_item);
    virtual ${module_name}_if vif;

    `uvm_component_utils(${module_name}_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual ${module_name}_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface specified for driver")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_transfer(req);
            seq_item_port.item_done();
        end
    endtask

    task drive_transfer(${module_name}_sequence_item item);
% for direction, typ, width, name in ports:
% if direction == "input":
        vif.${name} <= item.${name};
% endif
% endfor
        //@(posedge vif.clk); //you must set clk of vif in tb_top
    endtask
endclass
