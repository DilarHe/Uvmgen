class ${module_name}_monitor extends uvm_monitor;
    virtual ${module_name}_if vif;
    uvm_analysis_port #(${module_name}_sequence_item) ap;

    `uvm_component_utils(${module_name}_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if(!uvm_config_db #(virtual ${module_name}_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface specified for monitor")
    endfunction

    task run_phase(uvm_phase phase);
        ${module_name}_sequence_item item;
        forever begin
            item = ${module_name}_sequence_item::type_id::create("item");
            @(posedge vif.clk);
% for direction, typ, width, name in ports:
% if direction == "output":
            item.${name} = vif.${name};
% endif
% endfor
            ap.write(item);
        end
    endtask
endclass
