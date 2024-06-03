class ${module_name}_sequence extends uvm_sequence #(${module_name}_sequence_item);
    `uvm_object_utils(${module_name}_sequence)

    function new(string name = "${module_name}_sequence");
        super.new(name);
    endfunction

    virtual task body();
        ${module_name}_sequence_item item;

        // Generate Item by randomization
        repeat(10) begin
            // Create a sequence item
            item = ${module_name}_sequence_item::type_id::create("item");
            // Randomize item
            assert(item.randomize()) else `uvm_error("RANDOMIZE", "Randomization failed")
            // Print Info
            `uvm_info("SEQ", "Item Generated", UVM_MEDIUM)
            // Start item
            start_item(req);
            finish_item(req);
        end

    // following code allow configuring item
    /*
        // Create a sequence item
        item = ${module_name}_sequence_item::type_id::create("item");

        // Configure the sequence item
% for direction, typ, width, name in ports:
% if direction == "input":
        item.${name} = 'h0;
% endif
% endfor

        // Start the sequence item
        start_item(item);

        // Finish the sequence item
        finish_item(item);
    */
    endtask
endclass
