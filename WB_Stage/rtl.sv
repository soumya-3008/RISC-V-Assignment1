
module wb_stage(
    input  logic [31:0] mem_out,
    input  logic [31:0] alu_out,
    input  logic [31:0] return_addr,
    input  logic [31:0] imm_out,
    input  logic [31:0] pc_signed_offset,
    input  logic [1:0]  memtoreg,
    input  logic [6:0]  opcode_out_d,
    output logic [31:0] wb_data
);

    always_comb begin
        // Default selection
        wb_data = alu_out;

        case (memtoreg)

            // ALU result
            2'b00: begin
                wb_data = alu_out;
            end

            // Data memory result
            2'b01: begin
                wb_data = mem_out;
            end

            // Select according to instruction opcode
            2'b10: begin
                case (opcode_out_d)

                    // JAL and JALR
                    7'b1101111,
                    7'b1100111: wb_data = return_addr;

                    // LUI
                    7'b0110111: wb_data = imm_out;

                    // AUIPC
                    7'b0010111: wb_data = pc_signed_offset;

                    // Other instructions
                    default: wb_data = alu_out;

                endcase
            end

            // Default ALU result
            2'b11: begin
                wb_data = alu_out;
            end

            default: begin
                wb_data = alu_out;
            end

        endcase
    end

endmodule
