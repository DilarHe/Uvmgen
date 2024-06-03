class ${module_name}_env extends uvm_env;
    `uvm_component_utils(${module_name}_env)

    ${module_name}_agent agent;
    ${module_name}_scb scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = ${module_name}_agent::type_id::create("agent", this);
        scoreboard = ${module_name}_scb::type_id::create("scoreboard", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.ap.connect(scoreboard.monitor_ap);
        agent.driver.ap.connect(scoreboard.driver_ap);
    endfunction

endclass
