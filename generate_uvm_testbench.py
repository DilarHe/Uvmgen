import re
import argparse
from mako.template import Template

def remove_line_comments(verilog_code):
    # Remove line comments that start with // and extend to the end of the line
    return re.sub(r'//.*', '', verilog_code)


def parse_verilog_module(verilog_code):
    verilog_code = remove_line_comments(verilog_code)
    module_pattern = re.compile(r'module\s+(\w+)\s*\(([^)]+)\);', re.DOTALL)
    port_pattern = re.compile(r'\s*(input|output|inout)\s+(?:\s*(reg|wire|logic))?\s*(\[\d+:\d+\])?\s*(\w+)\s*[,;]*')
    module_match = module_pattern.search(verilog_code)
    if not module_match:
        raise ValueError("No module definition found in the provided code.")

    module_name = module_match.group(1)
    ports_str = module_match.group(2)
    ports = port_pattern.findall(ports_str)

    # Apply default values for typ and width
    parsed_ports = []
    for direction, typ, width, name in ports:
        typ = typ if typ else 'logic'
        width = width if width else ''
        parsed_ports.append((direction, typ, width, name))

    return module_name, parsed_ports


def generate_uvm_testbench(verilog_code, template):
    module_name, ports = parse_verilog_module(verilog_code)
    if template:
        templates = {template: "./template/"+template.split('.')[0]+".mako"}
    else:
        templates = {
            "sequence_item.svh": "./template/sequence_item.mako",
            "sequence.svh": "./template/sequence.mako",
            "driver.svh": "./template/driver.mako",
            "monitor.svh": "./template/monitor.mako",
            "env.svh": "./template/env.mako",
            "test.svh": "./template/test.mako",
            "tb_top.sv": "./template/tb_top.mako",
            "virtual_if.svh": "./template/virtual_if.mako",
            "uvm_package.sv": "./template/uvm_package.mako",
            "agent.svh": "./template/agent.mako",
            "sequencer.svh": "./template/sequencer.mako"
            }

    for filename, template_path in templates.items():
        with open(template_path, "r") as template_file:
            template = Template(template_file.read())
            rendered = template.render(module_name=module_name, ports=ports)
            with open(filename, "w") as output_file:
                output_file.write(rendered)
                print('{0:<20}'.format(filename)+"generated")


def main():
    parser = argparse.ArgumentParser(description="Generate UVM testbench from Verilog module")
    parser.add_argument("-file", type=str, required=True, help="Path to the Verilog module file")
    parser.add_argument("-template", type=str, required=False, help="specified template file")
    args = parser.parse_args()
    with open(args.file, "r") as verilog_file:
        verilog_code = verilog_file.read()

    generate_uvm_testbench(verilog_code, args.template)


if __name__ == "__main__":
    main()
