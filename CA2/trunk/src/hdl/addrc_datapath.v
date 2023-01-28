`include "register.v"
`include "counter_modn.v"

module AddRcDatapath (clk, rst, in, cycleNum, sliceCntEn, sliceCntClr, ldReg, clrReg, sliceCntCo, out);
    input clk, rst, sliceCntEn, sliceCntClr, ldReg, clrReg;
    input [24:0] in;
    input [4:0] cycleNum;
    output sliceCntCo;
    output [24:0] out;

    wire [5:0] sliceCnt;
    wire [24:0] regIn;
    wire [24:0] regOut;
    wire [63:0] currCoeff;
    reg [63:0] coeff [0:23];

    initial $readmemh("rc.hex", coeff);

    Register #(.N(25)) reg(.clk(clk), .rst(rst), .clr(clrReg), .ld(ldReg), .din(regIn), .dout(regOut));
    CounterModN #(.N(6)) sliceNum(.clk(clk), .rst(rst), .clr(sliceCntClr), .en(sliceCntEn), .q(sliceCnt), .co(sliceCntCo));

    assign currCoeff = coeff[cycleNum];
    assign out = regOut;
    assign regIn = {in[24:13], in[12] ^ currCoeff[sliceCnt], in[11:0]};
endmodule
