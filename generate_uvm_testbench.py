import re
import argparse
from mako.template import Template


def parse_verilog_module(verilog_code):
    module_pattern = re.compile(r'module\s+(\w+)\s*\(([^)]+)\);', re.DOTALL)
    port_pattern = re.compile(r'\s*(input|output|inout)\s+([^;,\n]+)\s+(\w+)\s*[,;]*')

    module_match = module_pattern.search(verilog_code)
    if not module_match:
        raise ValueError("No module definition found in the provided code.")

    module_name = module_match.group(1)
    ports_str = module_match.group(2)
    ports = port_pattern.findall(ports_str)
    print(ports)
    return module_name, ports


def generate_uvm_testbench(verilog_code):
    module_name, ports = parse_verilog_module(verilog_code)

    templates = {
        "sequence_item.svh": "./template/sequence_item.mako",
        "sequence.svh": "./template/sequence.mako",
        "driver.svh": "./template/driver.mako",
        "monitor.svh": "./template/monitor.mako",
        "env.svh": "./template/env.mako",
        "test.svh": "./template/test.mako",
        "tb_top.sv": "./template/top_module.mako"
    }

    for filename, template_path in templates.items():
        with open(template_path, "r") as template_file:
            template = Template(template_file.read())
            rendered = template.render(module_name=module_name, ports=ports)
            with open(filename, "w") as output_file:
                output_file.write(rendered)


def main():
    #parser = argparse.ArgumentParser(description="Generate UVM testbench from Verilog module")
    #parser.add_argument("-file", type=str, required=True, help="Path to the Verilog module file")
    #args = parser.parse_args()
    args_file = "mdio_master.sv"
    with open(args_file, "r") as verilog_file:
        verilog_code = verilog_file.read()

    generate_uvm_testbench(verilog_code)


if __name__ == "__main__":
    main()
