`timescale 1ns / 1ps

module display(
    input clock,
    input reset,
    input start,
    input random_finish,
    input react,
    input [31:0] t_react,
    input react_exceed,
    output reg [10:0] result
    );

    reg [27:0] t_react_converted; // Convert t_react to be four-bit DEC for LED
    reg whether_fail; // Judge whether failuer has happened
    reg whether_test; // Judge whether test has begun
    reg [1:0] counter1;
    reg [1:0] counter2;
    reg [1:0] counter3;
    reg [1:0] counter4;
    reg [1:0] counter5;
    reg [1:0] counter6;
    reg [1:0] counter7;

    // Define charater constant
    parameter DISPLAY_NONE = 7'b1111111; // Display nothing
    parameter DISPLAY_DASH = 7'b1111110; // Display "-" 
    parameter DISPLAY_F = 11'b01110111000; // Display "F"
    parameter DISPLAY_A = 11'b10110001000; // Display "A"
    parameter DISPLAY_I = 11'b11011001111; // Display "I"
    parameter DISPLAY_L = 11'b11101110001; // Display "L"
    parameter DISPLAY_0 = 7'b0000001; // Display "0"
    parameter DISPLAY_1 = 7'b1001111; // Display "1"
    parameter DISPLAY_2 = 7'b0010010; // Display "2"
    parameter DISPLAY_3 = 7'b0000110; // Display "3"
    parameter DISPLAY_4 = 7'b1001100; // Display "4"
    parameter DISPLAY_5 = 7'b0100100; // Display "5"
    parameter DISPLAY_6 = 7'b0100000; // Display "6"
    parameter DISPLAY_7 = 7'b0001111; // Display "7"
    parameter DISPLAY_8 = 7'b0000000; // Display "8"
    parameter DISPLAY_9 = 7'b0000100; // Display "9"
    
    initial begin
        counter1 <= 0;
        counter2 <= 0;
        counter3 <= 0;
        counter4 <= 0;
        counter5 <= 0;
        counter6 <= 0;
        counter7 <= 0;
    end

    always @(posedge clock or posedge reset) begin
        // Convert HEX reaction time to four-bit DEC
        case(t_react%10)
            0: t_react_converted[6:0] <= DISPLAY_0;
            1: t_react_converted[6:0] <= DISPLAY_1;
            2: t_react_converted[6:0] <= DISPLAY_2;
            3: t_react_converted[6:0] <= DISPLAY_3;
            4: t_react_converted[6:0] <= DISPLAY_4;
            5: t_react_converted[6:0] <= DISPLAY_5;
            6: t_react_converted[6:0] <= DISPLAY_6;
            7: t_react_converted[6:0] <= DISPLAY_7;
            8: t_react_converted[6:0] <= DISPLAY_8;
            9: t_react_converted[6:0] <= DISPLAY_9;
        endcase
        case((t_react/10)%10)
            0: t_react_converted[13:7] <= DISPLAY_0;
            1: t_react_converted[13:7] <= DISPLAY_1;
            2: t_react_converted[13:7] <= DISPLAY_2;
            3: t_react_converted[13:7] <= DISPLAY_3;
            4: t_react_converted[13:7] <= DISPLAY_4;
            5: t_react_converted[13:7] <= DISPLAY_5;
            6: t_react_converted[13:7] <= DISPLAY_6;
            7: t_react_converted[13:7] <= DISPLAY_7;
            8: t_react_converted[13:7] <= DISPLAY_8;
            9: t_react_converted[13:7] <= DISPLAY_9;
        endcase
        case((t_react/100)%10)
            0: t_react_converted[20:14] <= DISPLAY_0;
            1: t_react_converted[20:14] <= DISPLAY_1;
            2: t_react_converted[20:14] <= DISPLAY_2;
            3: t_react_converted[20:14] <= DISPLAY_3;
            4: t_react_converted[20:14] <= DISPLAY_4;
            5: t_react_converted[20:14] <= DISPLAY_5;
            6: t_react_converted[20:14] <= DISPLAY_6;
            7: t_react_converted[20:14] <= DISPLAY_7;
            8: t_react_converted[20:14] <= DISPLAY_8;
            9: t_react_converted[20:14] <= DISPLAY_9;
        endcase
        case(t_react/1000)
            0: t_react_converted[27:21] <= DISPLAY_NONE; // Display nothing if hundreds and thousands places are 0
            1: t_react_converted[27:21] <= DISPLAY_1;
            2: t_react_converted[27:21] <= DISPLAY_2;
            3: t_react_converted[27:21] <= DISPLAY_3;
            4: t_react_converted[27:21] <= DISPLAY_4;
            5: t_react_converted[27:21] <= DISPLAY_5;
            6: t_react_converted[27:21] <= DISPLAY_6;
            7: t_react_converted[27:21] <= DISPLAY_7;
            8: t_react_converted[27:21] <= DISPLAY_8;
            9: t_react_converted[27:21] <= DISPLAY_9;
        endcase
    
        if(reset)begin
            result[6:0] <= DISPLAY_NONE; // Reset, no display
            if(counter1 == 0)begin
                result[10:7] <= 4'b0111;
                counter1 <= 1;
            end
            if(counter1 == 1)begin
                result[10:7] <= 4'b1011;
                counter1 <= 2;
            end
            if(counter1 == 2)begin
                result[10:7] <= 4'b1101;
                counter1 <= 3;
            end
            if(counter1 == 3)begin
                result[10:7] <= 4'b1110;
                counter1 <= 0;
            end
            whether_test <= 0;
            whether_fail <= 0;
        end
        else if (start) begin
            if(!random_finish && !react)begin
                result[6:0] <= DISPLAY_DASH; // Display "----", if start
                if(counter2 == 0)begin
                    result[10:7] <= 4'b0111;
                    counter2 <= 1;
                end
                if(counter2 == 1)begin
                    result[10:7] <= 4'b1011;
                    counter2 <= 2;
                end
                if(counter2 == 2)begin
                    result[10:7] <= 4'b1101;
                    counter2 <= 3;
                end
                if(counter2 == 3)begin
                    result[10:7] <= 4'b1110;
                    counter2 <= 0;
                end
                whether_test <= 0;
                whether_fail <= 0;
            end
            else if(!random_finish && react)begin
                // Display "Fail", react before random time finish
                if(counter3 == 0)begin
                    result <= DISPLAY_F;
                    counter3 <= 1;
                end
                if(counter3 == 1)begin
                    result <= DISPLAY_A;
                    counter3 <= 2;
                end
                if(counter3 == 2)begin
                    result <= DISPLAY_I;
                    counter3 <= 3;
                end
                if(counter3 == 3)begin
                    result <= DISPLAY_L;
                    counter3 <= 0;
                end
                whether_test <= 0;
                whether_fail <= 1;
            end
            else if(random_finish && !react && !react_exceed && !whether_fail)begin
                result[6:0] <= DISPLAY_1; // Display "1111", random time finish, it should be to react
                if(counter4 == 0)begin
                    result[10:7] <= 4'b0111;
                    counter4 <= 1;
                end
                if(counter4 == 1)begin
                    result[10:7] <= 4'b1011;
                    counter4 <= 2;
                end
                if(counter4 == 2)begin
                    result[10:7] <= 4'b1101;
                    counter4 <= 3;
                end
                if(counter4 == 3)begin
                    result[10:7] <= 4'b1110;
                    counter4 <= 0;
                end
                whether_test <= 1;
            end
            else if(random_finish && react && t_react >= 100 && whether_test) begin
                // Display t_react, react successfully
                if(counter7 == 0)begin
                    result[10:7] <= 4'b0111;
                    result[6:0] <= t_react_converted[27:21];
                    counter7 <= 1;
                end
                if(counter7 == 1)begin
                    result[10:7] <= 4'b1011;
                    result[6:0] <= t_react_converted[20:14];
                    counter7 <= 2;
                end
                if(counter7 == 2)begin
                    result[10:7] <= 4'b1101;
                    result[6:0] <= t_react_converted[13:7];
                    counter7 <= 3;
                end
                if(counter7 == 3)begin
                    result[10:7] <= 4'b1110;
                    result[6:0] <= t_react_converted[6:0];
                    counter7 <= 0;
                end
            end
            else begin
                // Display "Fail", react failed
                if(counter5 == 0)begin
                    result <= DISPLAY_F;
                    counter5 <= 1;
                end
                if(counter5 == 1)begin
                    result <= DISPLAY_A;
                    counter5 <= 2;
                end
                if(counter5 == 2)begin
                    result <= DISPLAY_I;
                    counter5 <= 3;
                end
                if(counter5 == 3)begin
                    result <= DISPLAY_L;
                    counter5 <= 0;
                end
                whether_fail <= 1;
            end
        end 
        else begin
                result[6:0] <= DISPLAY_NONE; // Display Nothing, for else conditions
                if(counter6 == 0)begin
                    result[10:7] <= 4'b0111;
                    counter6 <= 1;
                end
                if(counter6 == 1)begin
                    result[10:7] <= 4'b1011;
                    counter6 <= 2;
                end
                if(counter6 == 2)begin
                    result[10:7] <= 4'b1101;
                    counter6 <= 3;
                end
                if(counter6 == 3)begin
                    result[10:7] <= 4'b1110;
                    counter6 <= 0;
                end
                whether_fail <= 0;
        end
    end
endmodule

