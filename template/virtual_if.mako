// Define virtual interface for ${module_name}
interface ${module_name}_if（input clk, input rstn);
    // Define interface signals
% for direction, typ, width, name in ports:
    ${typ} ${width} ${name};
% endfor
endinterface : ${module_name}_if
