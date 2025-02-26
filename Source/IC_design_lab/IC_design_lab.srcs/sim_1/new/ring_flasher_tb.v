`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 09:13:30 AM
// Design Name: 
// Module Name: ring_flasher_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ring_flasher_tb;
    reg clk;
    reg reset_n; 
    reg repeat_en;
    wire [15:0] leds;

    ring_flasher uut (
        .clk(clk),
        .reset_n(reset_n),
        .repeat_en(repeat_en),
        .leds(leds)
    );

    always #5 clk = ~clk; // Clock 10ns

    initial begin
        clk = 0; reset_n = 0; repeat_en = 0;
        #20 reset_n = 1; // B? reset
        #30 repeat_en = 1; // B?t flasher
        #5 repeat_en = 0;
        
        #2000 $stop;
    end
endmodule
