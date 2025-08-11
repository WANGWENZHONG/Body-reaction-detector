`timescale 1ns / 1ps


module react_time_count(
    input clock,
    input reset,
    input react,
    input random_finish,
    output reg react_exceed,
    output reg [31:0] t_react // Save reaction time by using 32-bit register
    );

    reg [31:0] cc_counter; // Counter clock cycles
    reg counting; // Flag to detect whether to count time
    reg prev_react; // Save last state of react to detect edge

    initial begin
        t_react = 0;
        cc_counter = 0;
        counting = 0;
        prev_react = 0;
        react_exceed = 0;
    end

    always @(posedge clock or posedge reset) begin
        if(reset)begin
            t_react <= 0;
            cc_counter <= 0;
            counting <= 0;
            prev_react <= 0;
            react_exceed <= 0;    
        end
        else begin
        prev_react <= react;
        if (random_finish) begin
            if (!counting) begin
                // Start timing
                counting <= 1;
                cc_counter <= 1;
            end else if (counting && !prev_react && react && !react_exceed) begin
                // Stop timing if react turns to 1 from 0
                t_react <= cc_counter;
                counting <= 0; // Stop timing
            end else if (counting) begin
                // Continue to time, and every cycle represents 1ms
                cc_counter <= cc_counter + 1;
                if(cc_counter >= 10000)begin
                    react_exceed <= 1;
                end
            end
        end 
        else begin
            // Reset state if random_finish = 0
            counting <= 0;
            cc_counter <= 0;
            t_react <= 0;
            prev_react <= 0;
        end
        end
    end
endmodule

