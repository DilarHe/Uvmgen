module mdio_master (
    input wire clk,             // System clock
    input wire reset,           // System reset
    input wire start,           // Start signal for MDIO operation
    input wire [4:0] phy_addr,  // PHY address
    input wire [4:0] reg_addr,  // Register address
    input wire [15:0] data_in,  // Data to be written
    input wire write,           // Write enable signal
    output reg [15:0] data_out, // Data read from PHY
    output reg ready,           // Ready signal
    output reg mdio,            // MDIO data line
    output reg mdc              // MDIO clock line
);

    // State encoding
    localparam IDLE      = 3'b000,
               PREAMBLE  = 3'b001,
               START     = 3'b010,
               OPCODE    = 3'b011,
               ADDR      = 3'b100,
               TURNAROUND= 3'b101,
               READ      = 3'b110,
               WRITE     = 3'b111;

    reg [2:0] state, next_state;
    reg [4:0] bit_cnt;
    reg [31:0] shift_reg;

    // Clock divider for generating MDC (typically 2.5 MHz from a faster system clock)
    reg [4:0] clk_div;
    always @(posedge clk or posedge reset) begin
        if (reset)
            clk_div <= 5'd0;
        else
            clk_div <= clk_div + 5'd1;
    end

    // Generate MDC from clk_div
    always @(posedge clk) begin
        if (clk_div == 5'd15)  // Adjust divider value as needed
            mdc <= ~mdc;
    end

    // Shift register for preamble, start, opcode, addresses, and data
    always @(posedge mdc or posedge reset) begin
        if (reset) begin
            shift_reg <= 32'hFFFFFFFF;
            bit_cnt <= 5'd0;
            state <= IDLE;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    ready <= 1;
                    if (start) begin
                        ready <= 0;
                        shift_reg <= {32{1'b1}};  // Preamble
                        bit_cnt <= 5'd31;
                        next_state <= PREAMBLE;
                    end
                end
                PREAMBLE: begin
                    if (bit_cnt == 5'd0) begin
                        shift_reg <= {2'b01, 2'b10, phy_addr, reg_addr, 16'b0}; // Start (01), Opcode (10), PHY address, Reg address
                        bit_cnt <= 5'd17;
                        next_state <= START;
                    end else begin
                        shift_reg <= {shift_reg[30:0], 1'b1};
                        bit_cnt <= bit_cnt - 5'd1;
                    end
                end
                START: begin
                    if (bit_cnt == 5'd0) begin
                        if (write) begin
                            shift_reg <= {16'b0, data_in}; // Data to write
                            bit_cnt <= 5'd15;
                            next_state <= WRITE;
                        end else begin
                            shift_reg <= {32{1'bZ}}; // Prepare for read turnaround
                            bit_cnt <= 5'd1;
                            next_state <= TURNAROUND;
                        end
                    end else begin
                        shift_reg <= {shift_reg[30:0], 1'b0};
                        bit_cnt <= bit_cnt - 5'd1;
                    end
                end
                TURNAROUND: begin
                    if (bit_cnt == 5'd0) begin
                        if (!write) begin
                            bit_cnt <= 5'd15;
                            next_state <= READ;
                        end
                    end else begin
                        bit_cnt <= bit_cnt - 5'd1;
                    end
                end
                READ: begin
                    if (bit_cnt == 5'd0) begin
                        data_out <= shift_reg[15:0];
                        next_state <= IDLE;
                        ready <= 1;
                    end else begin
                        shift_reg <= {shift_reg[30:0], mdio}; // Shift in read data
                        bit_cnt <= bit_cnt - 5'd1;
                    end
                end
                WRITE: begin
                    if (bit_cnt == 5'd0) begin
                        next_state <= IDLE;
                        ready <= 1;
                    end else begin
                        shift_reg <= {shift_reg[30:0], 1'b0};
                        bit_cnt <= bit_cnt - 5'd1;
                    end
                end
            endcase
        end
    end

    // MDIO output control
    always @(posedge clk) begin
        if (state == WRITE || state == PREAMBLE || state == START) begin
            mdio <= shift_reg[31];
        end else begin
            mdio <= 1'bZ; // High impedance during read and idle
        end
    end

endmodule
