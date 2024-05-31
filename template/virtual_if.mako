// Define virtual interface for ${module_name}
interface ${module_name}_if（input clk, input rstn);
    // Define interface signals
% for direction, typ, name in ports:
    ${direction} ${typ} ${name};
% endfor
endinterface : ${module_name}_if
