module agni_x_mac_pipeline (
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,

    input  logic [7:0]  a,
    input  logic [7:0]  b,

    output logic [15:0] acc
);

    // Stage 1: Input registers
    logic [7:0] a_s1;
    logic [7:0] b_s1;

    // Stage 2: Multiply
    logic [15:0] product_s2;

    // Stage 3: Product register
    logic [15:0] product_s3;

    // Stage 4: Accumulation
    logic [15:0] acc_s4;

    // Stage 5: Output register
    logic [15:0] acc_s5;

    always_ff @(posedge clk) begin

        if (rst) begin
            a_s1      <= 8'd0;
            b_s1      <= 8'd0;
            product_s2 <= 16'd0;
            product_s3 <= 16'd0;
            acc_s4     <= 16'd0;
            acc_s5     <= 16'd0;
        end

        else if (enable) begin

            // Stage 1
            a_s1 <= a;
            b_s1 <= b;

            // Stage 2
            product_s2 <= a_s1 * b_s1;

            // Stage 3
            product_s3 <= product_s2;

            // Stage 4
            acc_s4 <= acc_s4 + product_s3;

            // Stage 5
            acc_s5 <= acc_s4;

        end
    end

    assign acc = acc_s5;

endmodule
