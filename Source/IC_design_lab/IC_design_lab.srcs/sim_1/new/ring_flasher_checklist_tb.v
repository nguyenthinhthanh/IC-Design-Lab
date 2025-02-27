`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2025 06:17:11 PM
// Design Name: 
// Module Name: ring_flasher_checklist_tb
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


module ring_flasher_checklist_tb;

    // Testbench Signals
    reg clk;
    reg reset_n;
    reg repeat_en;
    wire [15:0] leds;
    
    // Instantiate DUT (Device Under Test)
    ring_flasher uut (
        .clk(clk),
        .reset_n(reset_n),
        .repeat_en(repeat_en),
        .leds(leds)
    );

    // Generate Clock Signal
    always #5 clk = ~clk;  // 10ns clock period (100MHz)

    // Test Procedure
    initial begin

        // Initialize signals
        clk = 0;
        reset_n = 0;
        repeat_en = 0;
        #10;

        // Test 1: System Reset
        reset_n = 0;
        #20;
        reset_n = 1;
        #10;
        
        // Test 2: Enable repeat_en (Start Operation)
        repeat_en = 1;
        #10;
        repeat_en = 0;
        
        // Test 3: Let the system run for some cycles
        #200;

        // Test 4: Check if LEDs toggle correctly in CW direction
        #100;

        // Test 5: Reset system during operation
        reset_n = 0;
        #10;
        reset_n = 1;

        // Test 6: Re-enable repeat_en
        #50;
        repeat_en = 1;
        #10;
        repeat_en = 0;
        
        // Run for a while and finish simulation
        #500;
        $finish;
    end

endmodule
