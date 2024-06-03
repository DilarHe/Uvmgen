class ${module_name}_scb extends uvm_scoreboard;
    `uvm_component_utils(${module_name}_scb)

    uvm_analysis_export#(${module_name}_sequence_item) monitor_ap;
    uvm_analysis_export#(${module_name}_sequence_item) driver_ap;

    uvm_tlm_analysis_fifo#(${module_name}_sequence_item) monitor_fifo;
    uvm_tlm_analysis_fifo#(${module_name}_sequence_item) driver_fifo;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);
        driver_ap = new("driver_ap", this);
        monitor_fifo = new("monitor_fifo", this);
        driver_fifo = new("driver_fifo", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor_ap.connect(monitor_fifo.analysis_export);
        driver_ap.connect(driver_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        ${module_name}_sequence_item monitor_trans;
        ${module_name}_sequence_item driver_trans;

        forever begin
            // Wait for transactions from both monitor and driver
            monitor_fifo.get(monitor_trans);
            driver_fifo.get(driver_trans);

            // Compare the transactions
            //if (monitor_trans.addr !== driver_trans.addr ||
            //    monitor_trans.data !== driver_trans.data ||
            //    monitor_trans.read_write !== driver_trans.read_write) begin
            //    `uvm_error("MISMATCH", $sformatf("Monitor and driver transactions do not match: Monitor(addr=%0h, data=%0h, rw=%0d), Driver(addr=%0h, data=%0h, rw=%0d)",
            //                                    monitor_trans.addr, monitor_trans.data, monitor_trans.read_write,
            //                                    driver_trans.addr, driver_trans.data, driver_trans.read_write))
            //end else begin
            //    `uvm_info("MATCH", $sformatf("Monitor and driver transactions match: addr=%0h, data=%0h, rw=%0d",
            //                                 monitor_trans.addr, monitor_trans.data, monitor_trans.read_write), UVM_MEDIUM)
            //end
        end
    endtask
endclass
