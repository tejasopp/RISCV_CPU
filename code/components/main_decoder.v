
// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
    input  [2:0] funct3,
    input        Zero,
    input        ALUR31,
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump,Jalr,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

reg [10:0] controls;
reg Takebranch;

always @(*) begin
    Takebranch=0;
    casez (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_Jalr
        7'b0000011: controls = 11'b1_00_1_0_01__00_0_0; // lw
        7'b0100011: controls = 11'b0_01_1_1_00__00_0_0; // sw
        7'b0110011: controls = 11'b1_xx_0_0_00__10_0_0; // R–type
        7'b1100011:  begin // branch
                    controls = 11'b0_10_0_0_00__01_0_0;
                    casez(funct3)
                    3'b0?0: Takebranch=  Zero;
                    3'b0?1: Takebranch= !Zero;
                    3'b1?1: Takebranch= !ALUR31;
						  3'b1?0: Takebranch= ALUR31;
						  endcase
                end                    
        7'b0010011: controls = 11'b1_00_1_0_00__10_0_0; // I–type ALU
        7'b1101111: controls = 11'b1_11_0_0_10__00_1_0; // jal
		7'b1100111: controls = 11'b1_00_1_0_10__00_0_1; // jalr
		7'b0?10111: controls = 11'b1_xx_x_0_11__xx_0_0; // lui od AuiPC
        default:    controls = 11'bx_xx_x_x_xx_x_xx_x_x; // ???
    endcase
end
assign Branch=Takebranch;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc,ALUOp, Jump,Jalr} = controls;

endmodule
