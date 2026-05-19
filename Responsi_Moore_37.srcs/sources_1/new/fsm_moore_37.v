`timescale 1ns / 1ps

module fsm_moore_37 (
    input  wire clk,       // clock manual dari BTNC, sudah di-edge detect dari top
    input  wire reset,     // reset aktif high
    input  wire w,
    output reg  y,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    always @(*) begin
        case (state)
            S0: begin
                if (w == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end

            S1: begin
                next_state = S2;
            end

            S2: begin
                next_state = S3;
            end

            S3: begin
                next_state = S0;
            end

            default: begin
                next_state = S0;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Moore: output hanya bergantung pada state
    always @(*) begin
        case (state)
            S2: y = 1'b1;
            default: y = 1'b0;
        endcase
    end

endmodule