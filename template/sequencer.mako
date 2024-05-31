class ${module_name}_sequencer extends uvm_sequencer #(${module_name}_sequence_item);
    `uvm_component_utils(${module_name}_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
