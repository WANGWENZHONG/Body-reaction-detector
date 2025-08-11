`timescale 1ns / 1ps


module top(
    input clock_undivided,
    input reset,
    input start,
    input react,
    output [10:0] result
    );
    
    wire clock;
    wire start_sustain;
    wire react_sustain;
    wire random_finish;
    wire react_exceed;
    wire [31:0] t_react;

    fre_divide fre_divide(
        .clock_undivided(clock_undivided),
        .reset(reset),
        .clock_divided(clock)
    );
    Buffet_elimination Buffet_elimination(
        .clock(clock),
        .reset(reset),
        .start(start),
        .react(react),
        .start_sustain(start_sustain),
        .react_sustain(react_sustain)
    );
    random_count random_count(
        .clock(clock),
        .reset(reset),
        .start(start_sustain),
        .random_finish(random_finish)
    );
    react_time_count react_time_count(
        .clock(clock),
        .reset(reset),
        .react(react_sustain),
        .random_finish(random_finish),
        .react_exceed(react_exceed),
        .t_react(t_react)
    );
    display display(
        .clock(clock),
        .reset(reset),
        .start(start_sustain),
        .random_finish(random_finish),
        .react(react_sustain),
        .t_react(t_react),
        .react_exceed(react_exceed),
        .result(result)
    );
    
//    initial begin
//        react_simulation <= 0;
//        tmp <= 0;
//    end
    
//    always @(posedge clock) begin
//// Detected successfully
//        if(random_finish)begin
//            tmp <= tmp + 1;
//            if(tmp >= 589)begin
//                react_simulation <= 1; // Simulate reaction after 589ms
//            end
//        end
//        else begin
//            react_simulation <= 0;
//        end
//    end

// Fail for react before random_finish
//        if(start_sustain)begin
//            react_simulation <= 1;
//        end
//    end

// Fail for reaction only in 63ms after random_finish
//        if(random_finish)begin
//            tmp <= tmp + 1;
//            if(tmp >= 63)begin
//                react_simulation <= 1; // Simulate reaction after 63ms
//            end
//        end
//        else begin
//            react_simulation <= 0;
//        end
//    end

// Fail for no reaction in 10s after random_finish
//        if(random_finish)begin
//            tmp <= tmp + 1;
//            if(tmp >= 12000)begin
//                react_simulation <= 1; // Simulate reaction after 12s
//            end
//        end
//        else begin
//            react_simulation <= 0;
//        end
//    end

endmodule