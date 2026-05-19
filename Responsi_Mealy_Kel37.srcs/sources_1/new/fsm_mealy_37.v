`timescale 1ns / 1ps

module fsm_mealy_37 (
    input  wire clk,
    input  wire reset,
    input  wire w,

    output reg  y,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    localparam S0 = 2'b00; // idle, palang tertutup
    localparam S1 = 2'b01; // kendaraan terdeteksi, palang terbuka
    localparam S2 = 2'b10; // kendaraan lewat
    localparam S3 = 2'b11; // kembali ke awal

    always @(*) begin
        next_state = S0;
        y = 1'b0;

        case (state)
            S0: begin
                if (w == 1'b1) begin
                    next_state = S1;
                    y = 1'b1;
                end
                else begin
                    next_state = S0;
                    y = 1'b0;
                end
            end

            S1: begin
                if (w == 1'b1) begin
                    next_state = S1;
                    y = 1'b1;
                end
                else begin
                    next_state = S2;
                    y = 1'b0;
                end
            end

            S2: begin
                next_state = S3;
                y = 1'b0;
            end

            S3: begin
                next_state = S0;
                y = 1'b0;
            end

            default: begin
                next_state = S0;
                y = 1'b0;
            end
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule