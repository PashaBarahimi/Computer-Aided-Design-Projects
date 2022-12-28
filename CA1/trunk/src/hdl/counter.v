module Counter (clk, rst, clr, en, q, co);
    parameter N = 32;
    parameter CounterValue = 64;

    input clk, rst, clr, en;
    output [N-1:0] q;
    output co;

    reg [N-1:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst || clr || co)
            q <= 0;
        else if (en)
            q <= q + 1;
    end

    assign co = (q == CounterValue - 1);
endmodule
