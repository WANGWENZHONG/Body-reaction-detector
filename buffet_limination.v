`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/11 12:40:09
// Design Name: 
// Module Name: buffet_limination
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

module Buffet_elimination(
    input clock,
    input reset,
    input start,
    input react,
    output reg start_sustain,
    output reg react_sustain
    );
    
    reg [3:0] start_count;
    reg [3:0] react_count;
    
    initial begin
        start_sustain = 0;
        react_sustain = 0;
        start_count = 0;
        react_count = 0;
    end
    
    always @(posedge clock or posedge reset)begin
        if(reset)begin
            start_sustain <= 0;
            react_sustain <= 0;
            start_count <= 0;
            react_count <= 0;
        end
        else begin
        if(start && start_count < 4)begin
            start_count <= start_count + 1;
        end
        if(start_count >= 4)begin
            start_sustain <= 1;
        end
        if(react && react_count < 4)begin
            react_count <= react_count + 1;
        end
        if(react_count >= 4)begin
            react_sustain <= 1;
        end
        end
    end 
endmodule
