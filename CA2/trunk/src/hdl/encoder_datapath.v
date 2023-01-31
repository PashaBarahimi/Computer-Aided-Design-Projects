`include "addrc.v"
`include "colparity.v"
`include "permutation.v"
`include "revaluate.v"
`include "rotate.v"
`include "memory.v"
`include "counter_modn.v"
`include "mux.v"

module EncoderDatapath (clk, rst, in, start, memSrc, memWrite, memRead, sliceCntEn, sliceCntClr,
                        cycleCntEn, cycleCntClr, colStart, rotStart, perStart, revStart, addStart,
                        colPutInput, colOutReady, colReady, rotPutInput, rotOutReady, rotReady,
                        perPutInput, perReady, revPutInput, revOutReady, revReady, addPutInput,
                        addReady, sliceCntCo, cycleCntCo, out);
    input clk, rst, start, memWrite, memRead, sliceCntEn, sliceCntClr, cycleCntEn, cycleCntClr,
          colStart, rotStart, perStart, revStart, addStart;
    input [24:0] in;
    input [2:0] memSrc;
    output colPutInput, colOutReady, colReady, rotPutInput, rotOutReady, rotReady, perPutInput,
           perReady, revPutInput, revOutReady, revReady, addPutInput, addReady, sliceCntCo, cycleCntCo;
    output [24:0] out;

    wire [24:0] memIn, memOut, colOut, rotOut, perOut, revOut, addOut;
    wire [5:0] sliceCnt;
    wire [4:0] cycleCnt;

    assign out = memOut;

    Mux8to1 mux(.sel(memSrc), .a0(in), .a1(colOut), .a2(rotOut), .a3(perOut), .a4(revOut), .a5(addOut), .out(memIn));

    CounterModN #(.N(64)) sliceCounter(.clk(clk), .rst(rst), .clr(sliceCntClr), .en(sliceCntEn), .q(sliceCnt), .co(sliceCntCo));
    CounterModN #(.N(24)) cycleCounter(.clk(clk), .rst(rst), .clr(cycleCntClr), .en(cycleCntEn), .q(cycleCnt), .co(cycleCntCo));

    Memory mem(.clk(clk), .rst(rst), .clr(1'b0), .read(memRead), .write(memWrite), .adr(sliceCnt), .din(memIn), .dout(memOut));

    ColParity   col(.clk(clk), .rst(rst), .start(colStart), .in(memOut), .ready(colReady), .putInput(colPutInput), .out(colOut), .outReady(colOutReady));
    Rotate      rot(.clk(clk), .rst(rst), .start(rotStart), .in(colOut), .ready(rotReady), .putInput(rotPutInput), .out(rotOut), .outReady(rotOutReady));
    Permutation per(.clk(clk), .rst(rst), .start(perStart), .in(rotOut), .ready(perReady), .putInput(perPutInput), .out(perOut));
    Revaluate   rev(.clk(clk), .rst(rst), .start(revStart), .in(perOut), .ready(revReady), .putInput(revPutInput), .out(revOut), .outReady(revOutReady));
    AddRC       add(.clk(clk), .rst(rst), .start(addStart), .in(revOut), .ready(addReady), .putInput(addPutInput), .out(addOut));
endmodule
