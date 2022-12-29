module Mapper (in, out);
    parameter N = 5;
    parameter M = 5;
    parameter InputLenBitCount = 5;

    input [(N*M)-1:0] in;
    output [(N*M)-1:0] out;

    reg [(N*M)-1:0] out;

    reg [InputLenBitCount-1:0] nHalf = N % 2 ? ((N / 2) + 1) : N / 2;
    reg [InputLenBitCount-1:0] mHalf = M % 2 ? ((M / 2) + 1) : M / 2;

    function [InputLenBitCount-1:0] index2DTo1D;
        input [InputLenBitCount-1:0] i;
        input [InputLenBitCount-1:0] j;

        begin: index2DTo1DBlock
            reg [InputLenBitCount-1:0] row, col;
            row = (j + N - nHalf) % N;
            col = (i + M - mHalf) % M;
            index2DTo1D = row * M + col;
        end
    endfunction

    function [InputLenBitCount-1:0] findDst;
        input [InputLenBitCount-1:0] i;
        input [InputLenBitCount-1:0] j;

        begin: findDstBlock
            reg [InputLenBitCount-1:0] jDst;
            jDst = (2 * i + 3 * j) % N;
            findDst = index2DTo1D(j, jDst);
        end
    endfunction

    always @(in, out) begin: mapper
        reg [InputLenBitCount-1:0] i, j;
        for (i = 0; i < M; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                out[findDst(i, j)] = in[index2DTo1D(i, j)];
            end
        end
    end
endmodule
