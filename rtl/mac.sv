`timescale 1ns/1ps

module mac #(
    parameter WIDTH = 8
)(
    input  logic                   clk,
    input  logic                   rst,
    input  logic                   en,

    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,

    output logic signed [(2*WIDTH)-1:0] acc
);

    logic signed [(2*WIDTH)-1:0] product;

    assign product = a * b;

    always_ff @(posedge clk) begin
        if (rst)
            acc <= '0;
        else if (en)
            acc <= acc + product;
    end

endmodule
