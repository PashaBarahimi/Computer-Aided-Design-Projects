`include "mux.v"
`include "shift_register.v"
`include "counter_modn.v"
`include "memory.v"
`include "parity_calc.v"

module ColParityDatapath (clk, rst, adrSrc, regSrc, matrixIn,
                          sliceCntEn, sliceCntClr, memRead, memWrite,
                          regLd, regClr, regShfR,
                          xorSrc, matCntEn, matCntClr,
                          colCntEn, colCntClr, colRegShR, colRegClr,
                          PDParLd, PDParClr,
                          matCntCo, colCntCo,
                          sliceCntCo, matrixOut);
    parameter Count = 64;
    localparam CntBits = $clog2(Count);

    input clk, rst, adrSrc, regSrc;
    input [24:0] matrixIn;
    input sliceCntEn, sliceCntClr;
    input memRead, memWrite;
    input regLd, regClr, regShfR;

    input xorSrc, matCntEn, matCntClr;
    input colCntEn, colCntClr, colRegShR, colRegClr;
    input PDParLd, PDParClr;
    output matCntCo, colCntCo;

    output sliceCntCo;
    output [24:0] matrixOut;

    wire [CntBits-1:0] memAdr;
    wire [24:0] memOut;
    wire [24:0] regIn, regOut;
    wire regSerIn;

    wire [CntBits-1:0] sliceCntOut;
    CounterModN #(Count) sliceCntr(
        .clk(clk),
        .rst(rst),
        .clr(sliceCntClr),
        .en(sliceCntEn),
        .q(sliceCntOut),
        .co(sliceCntCo)
    );

    Mux2to1 #(CntBits) memMux(
        .sel(adrSrc),
        .a0(sliceCntOut),
        .a1({CntBits{1'b0}}),
        .out(memAdr)
    );

    Memory #(25, Count) mem(
        .clk(clk),
        .rst(rst),
        .clr(1'b0),
        .read(memRead),
        .write(memWrite),
        .adr(memAdr),
        .din(regOut),
        .dout(memOut)
    );

    assign matrixOut = memOut;

    Mux2to1 #(25) regMux(
        .sel(regSrc),
        .a0(matrixIn),
        .a1(memOut),
        .out(regIn)
    );

    ShiftRegister #(25) shreg(
        .clk(clk),
        .rst(rst),
        .clr(regClr),
        .ld(regLd),
        .shR(regShfR),
        .shL(1'b0),
        .serIn(regSerIn),
        .din(regIn),
        .dout(regOut)
    );

    ParityCalc parityCalc(
        .clk(clk),
        .rst(rst),
        .xorSrc(xorSrc),
        .regInp(regOut),
        .matCntEn(matCntEn),
        .matCntClr(matCntClr),
        .colCntEn(colCntEn),
        .colCntClr(colCntClr),
        .colRegShR(colRegShR),
        .colRegClr(colRegClr),
        .PDParLd(PDParLd),
        .PDParClr(PDParClr),
        .matCntCo(matCntCo),
        .colCntCo(colCntCo),
        .out(regSerIn)
    );
endmodule
