import re

def remove_line_comments(verilog_code):
    # Remove line comments that start with // and extend to the end of the line
    return re.sub(r'//.*', '', verilog_code)
def parse_verilog_module(verilog_code):
    # Remove line comments to avoid affecting port parsing
    verilog_code = remove_line_comments(verilog_code)

    module_pattern = re.compile(r'module\s+(\w+)\s*\(([^;]*)\);', re.DOTALL)
    port_pattern = re.compile(r'\s*(input|output|inout)\s+[^,;]+\b(\w+)\b\s*[,;]*')

    module_match = module_pattern.search(verilog_code)
    if not module_match:
        raise ValueError("No module definition found in the provided code.")

    module_name = module_match.group(1)
    ports_str = module_match.group(2)
    ports = port_pattern.findall(ports_str)
    port_names = [port[1] for port in ports]

    return module_name, port_names


def generate_instance_code(module_name, port_names):
    instance_name = f"{module_name}_inst"
    max_port_length = max(len(port) for port in port_names)
    instance_code = f"{module_name} {instance_name} (\n"
    port_mappings = [f"    .{port.ljust(max_port_length)} ({port.ljust(max_port_length)})" for port in port_names]
    instance_code += ",\n".join(port_mappings)
    instance_code += "\n);"
    return instance_code
def convert_verilog_to_instance(verilog_code):
    module_name, port_names = parse_verilog_module(verilog_code)
    return generate_instance_code(module_name, port_names)


# Convert to instance
with open("./mdio_master.sv","r") as file:
    verilog_code = file.read()
instance_code = convert_verilog_to_instance(verilog_code)
print(instance_code)