`include "colparity_controller.v"
`include "colparity_datapath.v"

module Main (clk, rst, start, matrixIn,
             ready, putInput, outReady, matrixOut);
    parameter Count = 64;

    input clk, rst, start;
    input [25-1:0] matrixIn;
    output ready, putInput, outReady;
    output [25-1:0] matrixOut;

    wire adrSrc, regSrc;
    wire sliceCntEn, sliceCntClr, memRead, memWrite;
    wire regLd, regClr, regShfR;
    wire xorSrc, matCntEn, matCntClr;
    wire colCntEn, colCntClr, colRegShR, colRegClr;
    wire PDParLd, PDParClr;
    wire matCntCo, colCntCo, sliceCntCo;

    MainController controller(clk, rst, start, adrSrc, regSrc,
                              sliceCntEn, sliceCntClr, memRead, memWrite,
                              regLd, regClr, regShfR,
                              xorSrc, matCntEn, matCntClr,
                              colCntEn, colCntClr, colRegShR, colRegClr,
                              PDParLd, PDParClr,
                              matCntCo, colCntCo, sliceCntCo,
                              ready, putInput, outReady);

    MainDatapath datapath(clk, rst, adrSrc, regSrc, matrixIn,
                          sliceCntEn, sliceCntClr, memRead, memWrite,
                          regLd, regClr, regShfR,
                          xorSrc, matCntEn, matCntClr,
                          colCntEn, colCntClr, colRegShR, colRegClr,
                          PDParLd, PDParClr,
                          matCntCo, colCntCo, sliceCntCo, matrixOut);
endmodule
