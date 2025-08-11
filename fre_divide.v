`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 15:57:23
// Design Name: 
// Module Name: fre_divide
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


module fre_divide(
    input clock_undivided, 
    input reset,
    output reg clock_divided
);

    reg [15:0] counter;
    parameter DIVISOR = 50000;
    
    initial begin
        counter <= 0;
        clock_divided <= 0;
    end
    
    always @(posedge clock_undivided or posedge reset) begin
        if (reset) begin
            counter <= 16'b0;
            clock_divided <= 1'b0;
        end else begin
            if (counter == (DIVISOR - 1)) begin
                counter <= 16'b0;
                clock_divided <= ~clock_divided;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule