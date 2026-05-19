`timescale 1ns / 1ps

module sevenseg_display (
    input  wire clk,
    input  wire w,
    input  wire y,
    input  wire [1:0] state,

    output reg  [6:0] seg,  // seg[0]=CA, seg[1]=CB, ..., seg[6]=CG
    output wire dp,
    output reg  [7:0] an
);

    reg [19:0] refresh_counter = 20'd0;
    wire [2:0] digit_select;

    reg [3:0] char_code;

    localparam CHAR_0     = 4'd0;
    localparam CHAR_1     = 4'd1;
    localparam CHAR_W     = 4'd2;
    localparam CHAR_Y     = 4'd3;
    localparam CHAR_S     = 4'd4;
    localparam CHAR_T     = 4'd5;
    localparam CHAR_BLANK = 4'd15;

    assign dp = 1'b1;   // decimal point mati, aktif-low

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 1'b1;
    end

    assign digit_select = refresh_counter[19:17];

    always @(*) begin
        an = 8'b11111111;
        char_code = CHAR_BLANK;

        case (digit_select)

            // Digit paling kanan
            // Format display: wXyXStXX
            // Dari kiri ke kanan: AN7 AN6 AN5 AN4 AN3 AN2 AN1 AN0

            3'd0: begin
                an = 8'b11111110;               // AN0
                char_code = state[0] ? CHAR_1 : CHAR_0;
            end

            3'd1: begin
                an = 8'b11111101;               // AN1
                char_code = state[1] ? CHAR_1 : CHAR_0;
            end

            3'd2: begin
                an = 8'b11111011;               // AN2
                char_code = CHAR_T;
            end

            3'd3: begin
                an = 8'b11110111;               // AN3
                char_code = CHAR_S;
            end

            3'd4: begin
                an = 8'b11101111;               // AN4
                char_code = y ? CHAR_1 : CHAR_0;
            end

            3'd5: begin
                an = 8'b11011111;               // AN5
                char_code = CHAR_Y;
            end

            3'd6: begin
                an = 8'b10111111;               // AN6
                char_code = w ? CHAR_1 : CHAR_0;
            end

            3'd7: begin
                an = 8'b01111111;               // AN7, paling kiri
                char_code = CHAR_W;
            end

            default: begin
                an = 8'b11111111;
                char_code = CHAR_BLANK;
            end
        endcase
    end

    always @(*) begin
        case (char_code)

            // Mapping aktif-low untuk Nexys A7
            // seg[6:0] = {CG, CF, CE, CD, CC, CB, CA}
            // Tetapi port fisik tetap seg[0]=CA sampai seg[6]=CG
            // Maka nilai ditulis sesuai urutan seg[6:0]

            CHAR_0:     seg = 7'b1000000;  // 0
            CHAR_1:     seg = 7'b1111001;  // 1

            // Huruf pendekatan seven segment
            CHAR_W:     seg = 7'b1000001;  // seperti U / w
            CHAR_Y:     seg = 7'b0010001;  // y
            CHAR_S:     seg = 7'b0010010;  // S
            CHAR_T:     seg = 7'b0000111;  // t

            CHAR_BLANK: seg = 7'b1111111;  // mati

            default:    seg = 7'b1111111;
        endcase
    end

endmodule