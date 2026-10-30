
module alu_control (
    input  logic [2:0] alu_op,
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,
    input  logic       fn7_5,
    output logic [4:0] control_out
);

    always_comb begin
        // Default operation: ADD
        control_out = 5'b00000;

        case (alu_op)

            // R-type instructions
            3'b000: begin
                case (fn3)
                    3'b000: control_out = fn7_5 ? 5'b00001 : 5'b00000;
                    3'b001: control_out = 5'b00101;
                    3'b010: control_out = 5'b01000;
                    3'b011: control_out = 5'b01001;
                    3'b100: control_out = 5'b00010;
                    3'b101: control_out = fn7_5 ? 5'b00111 : 5'b00110;
                    3'b110: control_out = 5'b00011;
                    3'b111: control_out = 5'b00100;
                    default: control_out = 5'b00000;
                endcase
            end

            // I-type ALU instructions
            3'b001: begin
                case (fn3)
                    3'b000: control_out = 5'b00000;
                    3'b001: control_out = 5'b00101;
                    3'b010: control_out = 5'b01000;
                    3'b011: control_out = 5'b01001;
                    3'b100: control_out = 5'b00010;
                    3'b101: control_out = (imm11_5 == 7'h20) ? 5'b00111 : 5'b00110;
                    3'b110: control_out = 5'b00011;
                    3'b111: control_out = 5'b00100;
                    default: control_out = 5'b00000;
                endcase
            end

            // Load and Store
            3'b010,
            3'b011: control_out = 5'b00000;

            // Branch instructions
            3'b100: begin
                case (fn3)
                    3'b000: control_out = 5'b01010; // BEQ
                    3'b001: control_out = 5'b01011; // BNE
                    3'b100: control_out = 5'b01100; // BLT
                    3'b101: control_out = 5'b01101; // BGE
                    3'b110: control_out = 5'b01110; // BLTU
                    3'b111: control_out = 5'b01111; // BGEU
                    default: control_out = 5'b00000;
                endcase
            end

            // JAL and LUI
            3'b110: control_out = 5'b00000;

            // Other operation classes
            default: control_out = 5'b00000;

        endcase
    end

endmodule
