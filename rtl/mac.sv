module agni_x_mac (
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,

    input  logic [7:0]  a,
    input  logic [7:0]  b,

    output logic [15:0] acc
);

    logic [15:0] product;

    always_ff @(posedge clk) begin
        if (rst) begin
            product <= 16'd0;
            acc     <= 16'd0;
        end
        else if (enable) begin
            product <= a * b;
            acc     <= acc + (a * b);
        end
    end

endmodule
