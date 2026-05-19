`timescale 1ns / 1ps

module top_mealy_37 (
    input  wire CLK100MHZ,
    input  wire w,          // SW0
    input  wire btn_clk,    // BTNC
    input  wire reset,      // BTNU

    output wire y,          // LED0

    output wire [6:0] seg,  // CA-CG
    output wire dp,
    output wire [7:0] an
);

    wire clk_pulse;
    wire [1:0] state;

    button_pulse pulse_clock (
        .clk(CLK100MHZ),
        .btn(btn_clk),
        .pulse(clk_pulse)
    );

    fsm_mealy_37 mealy_fsm (
        .clk(clk_pulse),
        .reset(reset),
        .w(w),
        .y(y),
        .state(state)
    );

    sevenseg_display display (
        .clk(CLK100MHZ),
        .w(w),
        .y(y),
        .state(state),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

endmodule