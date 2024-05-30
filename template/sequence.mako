class ${module_name}_sequence extends uvm_sequence #(${module_name}_sequence_item);
    `uvm_object_utils(${module_name}_sequence)

    function new(string name = "${module_name}_sequence");
        super.new(name);
    endfunction

    virtual task body();
        ${module_name}_sequence_item item;

        // Create a sequence item
        item = ${module_name}_sequence_item::type_id::create("item");

        // Configure the sequence item
% for direction, typ, name in ports:
% if direction == "input":
        item.${name} = 'h0;
% endif
% endfor

        // Start the sequence item
        start_item(item);

        // Finish the sequence item
        finish_item(item);
    endtask
endclass
