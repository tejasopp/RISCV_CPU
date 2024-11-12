//
//// alu.v - ALU module
//

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(*) begin // Use * to trigger on any change
    case (alu_ctrl)
        4'b0000: alu_out = a + b;         // ADD
        4'b0001: alu_out = a - b;         // SUB
        4'b0010: alu_out = a & b;         // AND
        4'b0011: alu_out = a | b;         // OR
        4'b0100: alu_out = a ^ b;         // XOR
        4'b0101: alu_out = (a[31] != b[31]) ? (a[31] ? 1 : 0) : (a < b); // SLT
        4'b0111: alu_out = (a < b);       // SLTu (unsigned)
        4'b1000: alu_out = a << b[4:0];   // SLL
        4'b1001: alu_out = $signed(a) >>> b[4:0]; // SRA
        4'b1111: alu_out = a >> b[4:0];   // SRL
        default: alu_out = 0;              // Default case
    endcase
end

assign zero = (alu_out == 0);            // Zero flag

endmodule


