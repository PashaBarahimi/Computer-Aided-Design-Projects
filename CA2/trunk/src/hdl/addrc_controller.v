module AddRcController (clk, rst, start, sliceCntCo, sliceCntEn, sliceCntClr, ldReg, clrReg, ready, putInput);
    localparam Idle  = 2'b00,
               Init  = 2'b01,
               Start = 2'b10,
               Calc  = 2'b11;

    input clk, rst, start, sliceCntCo;
    output reg sliceCntEn, sliceCntClr, ldReg, clrReg, ready, putInput;

    reg [1:0] pstate, nstate;

    always @(pstate or start or sliceCntCo) begin
        nstate = Idle;
        case (pstate)
            Idle:  nstate = start ? Init : Idle;
            Init:  nstate = Start;
            Start: nstate = Calc;
            Calc:  nstate = sliceCntCo ? Init : Calc;
            default:;
        endcase
    end

    always @(pstate) begin
        {sliceCntEn, sliceCntClr, ldReg, clrReg, ready, putInput} = 6'd0;
        case (pstate)
            Idle:  ready = 1'b1;
            Init:  {sliceCntClr, clrReg} = 2'b11;
            Start: putInput = 1'b1;
            Calc:  {sliceCntEn, ldReg} = 2'b11;
            default:;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            pstate <= Idle;
        else
            pstate <= nstate;
    end
endmodule