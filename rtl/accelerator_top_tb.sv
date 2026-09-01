`timescale 1ns/1ps

module accelerator_top_tb;

    localparam WIDTH = 8;

    logic clk;
    logic rst;
    logic en;

    logic signed [WIDTH-1:0] a;
    logic signed [WIDTH-1:0] b;

    logic signed [(2*WIDTH)-1:0] acc;

    accelerator_top #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        en  = 0;
        a   = 0;
        b   = 0;

        // RESET
        #10;

        if (acc !== 0)
            $fatal(1, "TOP RESET FAILED: acc=%0d", acc);

        $display("TOP RESET PASSED: acc=%0d", acc);

        // BASIC
        rst = 0;
        en  = 1;

        a = 2;
        b = 3;

        #10;

        if (acc !== 6)
            $fatal(1, "TOP BASIC FAILED: acc=%0d", acc);

        $display("TOP BASIC PASSED: 2 x 3 = %0d", acc);

        // SECOND ACCUMULATION
        a = 4;
        b = 5;

        #10;

        if (acc !== 26)
            $fatal(1, "TOP ACCUMULATION FAILED: acc=%0d", acc);

        $display("TOP ACCUMULATION PASSED: acc=%0d", acc);

        // SIGNED
        rst = 1;
        en  = 0;

        #10;

        rst = 0;
        en  = 1;

        a = -3;
        b = 4;

        #10;

        if (acc !== -12)
            $fatal(1, "TOP SIGNED FAILED: acc=%0d", acc);

        $display("TOP SIGNED PASSED: -3 x 4 = %0d", acc);

        // ENABLE HOLD
        en = 0;

        a = 10;
        b = 10;

        #10;

        if (acc !== -12)
            $fatal(1, "TOP HOLD FAILED: acc=%0d", acc);

        $display("TOP ENABLE HOLD PASSED: acc=%0d", acc);

        $display("");
        $display("==============================================");
        $display("AGNI-X TOP-LEVEL VERIFICATION PASSED");
        $display("Reset           : PASS");
        $display("Basic           : PASS");
        $display("Accumulation    : PASS");
        $display("Signed          : PASS");
        $display("Enable Hold     : PASS");
        $display("==============================================");

        $finish;

    end

endmodule
