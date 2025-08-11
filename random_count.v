`timescale 1ns / 1ps


module random_count(
    input clock,
    input reset,
    input start,
    output reg random_finish
);

    // Parameters to define the range of random time (500ms to 5s)
    // Assuming clock frequency is 1000Hz
    // 500ms => 500 clock cycles
    // 5s => 5,000 clock cycles
    localparam MIN_COUNT = 500;
    localparam MAX_COUNT = 5000;

    reg [31:0] randomtime;
    reg [31:0] counter;
    reg [15:0] lfsr;
    wire feedback;

    initial begin
        random_finish = 0;
        counter = 0;
        randomtime = 0;
        lfsr = 16'hACE1;  // Seed for the LFSR
    end

    // LFSR logic to generate pseudo-random numbers
    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            // Reset all state variables to initial values
            random_finish <= 0;
            counter <= 0;
            randomtime <= 0;
            lfsr <= 16'hACE1;  // Seed for the LFSR
        end
        else if (!start) begin
            // Generate and update random number using LFSR
            lfsr <= {lfsr[14:0], feedback};
            randomtime <= MIN_COUNT + (lfsr % (MAX_COUNT - MIN_COUNT));
            // Reset counter and random_finish
            counter <= 0;
            random_finish <= 0;         
        end
        else begin
            if (counter < randomtime) begin
                // Traversaling set randomtime
                counter <= counter + 1;
            end
            else begin
                random_finish <= 1;
            end  
        end
    end
endmodule