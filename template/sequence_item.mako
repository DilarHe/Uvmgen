class ${module_name}_sequence_item extends uvm_sequence_item;
% for direction, typ, width, name in ports:
    rand logic ${width} ${name};
% endfor

    `uvm_object_utils(${module_name}_sequence_item)
    // Constraints
    // example:
    // constraint addr_c { addr >= 0 && addr < 256; }
    // constraint read_write_c { read_write inside {0, 1}; }

    function new(string name = "${module_name}_sequence_item");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
% for direction, typ, width, name in ports:
        printer.print_field("${name}", ${name}, $bits(${name}));
% endfor
    endfunction
endclass
