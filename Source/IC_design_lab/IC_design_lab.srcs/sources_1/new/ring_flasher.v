`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2025 08:25:35 AM
// Design Name: 
// Module Name: ring_flasher
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

`include "header.vh"

module ring_flasher(
    input clk,           // Clock h? th?ng
    input reset_n,       // Reset m?c th?p ch? ??ng
    input repeat_en,     // Tín hi?u kích ho?t m?c cao
    output reg [15:0] leds  // 16 LED tr?ng thái
);

    reg [2:0] state, next_state;
    reg [3:0] count;
    reg [3:0] loop;

    always @(posedge clk or negedge reset_n or posedge repeat_en) begin
        if (!reset_n) begin
            state <= `IDLE;
            count <= 0;
            loop <= 1;
            leds  <= 16'b0;
        end 
        else if(repeat_en) begin
            state <= `CW_ON;
            count <= 0;  
            loop <= 1;   
            leds <= 16'b0;   
        end
        else begin
            state <= next_state;

            case (state)
                `IDLE: begin
                    leds  <= 16'b0;
                    count <= 0;
                end
                
                `CW_ON: begin
                    leds[count] <= 1;  
                    count <= count + 1;
                end
                
                `CCW_OFF: begin
                    leds[count] <= 0;
                    count <= count - 1;
                    
                end
                
                `TOGGLE_ON: begin
                    leds[count % 16] <= ~leds[count % 16];
                    count <= count + 1;
                end
                
                `TOGGLE_OFF: begin
                    leds[count % 16] <= ~leds[count % 16];
                    count <= count - 1;
                end
            endcase
        end
    end

    always @(count, repeat_en) begin
        case (state)
            `IDLE: begin
                    if(repeat_en) begin
                        next_state = `CW_ON;
                    end            
                    else begin
                        next_state = `IDLE;
                    end
             end
            `CW_ON: begin
                if(count == (loop*8-1-(loop-1)*4)) begin
                    next_state = `CCW_OFF;
                end
                else begin
                    next_state = `CW_ON;
                end
             end
            `CCW_OFF: begin
                if(count == (loop*4)) begin
                    loop = loop + 1;
                    if(loop == 4) begin
                       next_state = `TOGGLE_ON; 
                    end
                    else begin
                        next_state = `CW_ON;
                    end
                end
                else begin
                    next_state = `CCW_OFF;
                end
             end
            `TOGGLE_ON: begin
                if(count == (loop*8-1-(loop-1)*4)) begin
                    next_state = `TOGGLE_OFF;
                end
                else begin
                    next_state = `TOGGLE_ON;
                end
             end
            `TOGGLE_OFF: begin
                if(count == (loop*4)) begin
                    loop = loop + 1;
                    if(leds == 16'b0) begin
                       next_state = `IDLE; 
                    end
                    else begin
                        next_state = `TOGGLE_ON;
                    end
                end
                else begin
                    next_state = `TOGGLE_OFF;
                end
             end
            default:    next_state = `IDLE;
        endcase
    end

endmodule