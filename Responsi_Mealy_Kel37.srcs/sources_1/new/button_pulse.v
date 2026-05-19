`timescale 1ns / 1ps

module button_pulse (
    input  wire clk,
    input  wire btn,
    output reg  pulse
);

    reg btn_d1 = 1'b0;
    reg btn_d2 = 1'b0;
    reg btn_prev = 1'b0;

    always @(posedge clk) begin
        btn_d1 <= btn;
        btn_d2 <= btn_d1;

        pulse <= btn_d2 & ~btn_prev;
        btn_prev <= btn_d2;
    end

endmodule