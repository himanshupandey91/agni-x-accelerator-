module accelerator_top #(
    parameter WIDTH = 8
)(
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    output logic signed [(2*WIDTH)-1:0] acc
);

    accelerator #(
        .WIDTH(WIDTH)
    ) u_accelerator (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

endmodule
