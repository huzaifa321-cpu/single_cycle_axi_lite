`ifndef SINGLE_CYCLE_DEFS
`define SINGLE_CYCLE_DEFS

parameter DATA_WIDTH = 8;

typedef enum logic [6:0] {
R_TYPE = 7'h33,
I_TYPE = 7'h13,
LOAD_I = 7'h03 ,
S_TYPE = 7'h23,
B_TYPE = 7'h63,
JALR_I = 7'h67,
J_TYPE = 7'h6F,
LUI_I  = 7'h37,
AUIPC  = 7'h17
} type_opcode_e;

typedef enum logic [3:0] {
ADD  = 4'h0,
SUB  = 4'h1,
SLL  = 4'h2,
SLT  = 4'h3,
SLTU = 4'h4,
XOR  = 4'h5,
SRL  = 4'h6,
SRA  = 4'h7,
OR   = 4'h8,
AND  = 4'h9,
LUI  = 4'hA
} type_alu_op_e;

typedef enum logic [2:0] {
BEQ   = 3'h0,
BNE   = 3'h1,
BLT   = 3'h2,
BGE   = 3'h3,
BLTU  = 3'h4,
BGEU  = 3'h5,
JUMP  = 3'h6,
NO_BR = 3'h7
} type_branch_cond_e;

`endif //SINGLE_CYCLE_DEFS