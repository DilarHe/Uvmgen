class ${module_name}_sequence_item extends uvm_sequence_item;
% for direction, typ, name in ports:
    rand logic ${name};
% endfor

    `uvm_object_utils(${module_name}_sequence_item)

    function new(string name = "${module_name}_sequence_item");
        super.new(name);
    endfunction

    function void do_print(uvm_printer printer);
        super.do_print(printer);
% for direction, typ, name in ports:
        printer.print_field("${name}", ${name}, $bits(${name}));
% endfor
    endfunction
endclass
