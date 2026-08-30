`timescale 1ns/1ps

module mac_tb;

    parameter WIDTH = 8;

    logic clk;
    logic rst;
    logic en;

    logic signed [WIDTH-1:0] a;
    logic signed [WIDTH-1:0] b;

    logic signed [(2*WIDTH)-1:0] acc;

    // ------------------------------------------------------------
    // DUT
    // ------------------------------------------------------------
    mac #(
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .a(a),
        .b(b),
        .acc(acc)
    );

    // ------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ------------------------------------------------------------
    // Main verification
    // ------------------------------------------------------------
    initial begin

        rst = 1'b1;
        en  = 1'b0;
        a   = '0;
        b   = '0;

        // --------------------------------------------------------
        // Initial reset
        // --------------------------------------------------------
        @(posedge clk);
        #1;

        if (acc !== 0)
            $fatal(1, "INITIAL RESET FAILED: acc=%0d", acc);

        $display("INITIAL RESET PASSED: acc=%0d", acc);

        rst = 1'b0;

        // --------------------------------------------------------
        // Basic directed tests
        // --------------------------------------------------------
        en = 1'b1;

        a = 8'sd2;
        b = 8'sd3;

        @(posedge clk);
        #1;

        if (acc !== 16'sd6)
            $fatal(1, "BASIC TEST 1 FAILED: acc=%0d", acc);

        $display("BASIC TEST 1 PASSED: 2 x 3 = %0d", acc);


        a = 8'sd4;
        b = 8'sd5;

        @(posedge clk);
        #1;

        if (acc !== 16'sd26)
            $fatal(1, "BASIC TEST 2 FAILED: acc=%0d", acc);

        $display("BASIC TEST 2 PASSED: acc=%0d", acc);


        // --------------------------------------------------------
        // Signed tests
        // --------------------------------------------------------

        // Reset accumulator
        rst = 1'b1;
        en  = 1'b0;

        @(posedge clk);
        #1;

        if (acc !== 0)
            $fatal(1, "SIGNED RESET FAILED: acc=%0d", acc);

        rst = 1'b0;
        en  = 1'b1;


        // -3 x 4 = -12
        a = -8'sd3;
        b =  8'sd4;

        @(posedge clk);
        #1;

        if (acc !== -16'sd12)
            $fatal(1, "SIGNED TEST 1 FAILED: acc=%0d", acc);

        $display("SIGNED TEST 1 PASSED: acc=%0d", acc);


        // -2 x -5 = +10
        // -12 + 10 = -2
        a = -8'sd2;
        b = -8'sd5;

        @(posedge clk);
        #1;

        if (acc !== -16'sd2)
            $fatal(1, "SIGNED TEST 2 FAILED: acc=%0d", acc);

        $display("SIGNED TEST 2 PASSED: acc=%0d", acc);


        // 7 x -3 = -21
        // -2 - 21 = -23
        a =  8'sd7;
        b = -8'sd3;

        @(posedge clk);
        #1;

        if (acc !== -16'sd23)
            $fatal(1, "SIGNED TEST 3 FAILED: acc=%0d", acc);

        $display("SIGNED TEST 3 PASSED: acc=%0d", acc);


        // --------------------------------------------------------
        // ENABLE HOLD TEST
        // --------------------------------------------------------
        rst = 1'b1;
        en  = 1'b0;

        @(posedge clk);
        #1;

        rst = 1'b0;

        en = 1'b1;
        a  = 8'sd10;
        b  = 8'sd10;

        @(posedge clk);
        #1;

        if (acc !== 16'sd100)
            $fatal(1, "ENABLE SETUP FAILED: acc=%0d", acc);

        en = 1'b0;

        a = 8'sd127;
        b = 8'sd127;

        @(posedge clk);
        #1;

        if (acc !== 16'sd100)
            $fatal(1, "ENABLE HOLD FAILED: acc=%0d", acc);

        $display("ENABLE HOLD TEST PASSED: acc=%0d", acc);


        // --------------------------------------------------------
        // CORNER-CASE TESTS
        // --------------------------------------------------------

        rst = 1'b1;
        en  = 1'b0;

        @(posedge clk);
        #1;

        rst = 1'b0;
        en  = 1'b1;


        // 0 x 127
        a = 8'sd0;
        b = 8'sd127;

        @(posedge clk);
        #1;

        if (acc !== 16'sd0)
            $fatal(1, "CORNER 0x127 FAILED: acc=%0d", acc);


        // 1 x 127
        a = 8'sd1;
        b = 8'sd127;

        @(posedge clk);
        #1;

        if (acc !== 16'sd127)
            $fatal(1, "CORNER 1x127 FAILED: acc=%0d", acc);


        // -1 x 127 = -127
        // 127 - 127 = 0
        a = -8'sd1;
        b =  8'sd127;

        @(posedge clk);
        #1;

        if (acc !== 16'sd0)
            $fatal(1, "CORNER -1x127 FAILED: acc=%0d", acc);


        // 127 x 127 = 16129
        a = 8'sd127;
        b = 8'sd127;

        @(posedge clk);
        #1;

        if (acc !== 16'sd16129)
            $fatal(1, "CORNER 127x127 FAILED: acc=%0d", acc);


        // --------------------------------------------------------
        // Exhaustive verification
        // 256 x 256 = 65,536 cases
        // --------------------------------------------------------

        run_exhaustive_tests();


        // --------------------------------------------------------
        // FINAL
        // --------------------------------------------------------
        $display("");
        $display("======================================================");
        $display(" AGNI-X MAC EXHAUSTIVE SIGNED VERIFICATION PASSED");
        $display("======================================================");
        $display("  Width              : %0d bits", WIDTH);
        $display("  Input combinations : 65,536");
        $display("  Failed             : 0");
        $display("  Status             : PASS");
        $display("======================================================");
        $display("");

        $finish;
    end


    // ============================================================
    // Exhaustive signed verification
    // ============================================================
    task automatic run_exhaustive_tests;

        integer ai;
        integer bi;
        integer count;

        logic signed [WIDTH-1:0] test_a;
        logic signed [WIDTH-1:0] test_b;

        logic signed [(2*WIDTH)-1:0] expected_product;
        logic signed [(2*WIDTH)-1:0] expected_acc;

        begin

            // ----------------------------------------------------
            // Reset before exhaustive test
            // ----------------------------------------------------
            rst = 1'b1;
            en  = 1'b0;
            a   = '0;
            b   = '0;

            @(posedge clk);
            #1;

            if (acc !== 0)
                $fatal(
                    1,
                    "EXHAUSTIVE RESET FAILED: acc=%0d",
                    acc
                );

            rst = 1'b0;
            en  = 1'b1;

            expected_acc = '0;
            count = 0;

            $display("");
            $display("======================================================");
            $display(" STARTING 65,536-CASE EXHAUSTIVE SIGNED TEST");
            $display("======================================================");
            $display("");

            // ----------------------------------------------------
            // IMPORTANT:
            //
            // Each individual pair is tested after resetting
            // the accumulator so that the expected value is
            // simply a*b.
            //
            // This prevents accumulator overflow from hiding
            // multiplier errors.
            // ----------------------------------------------------

            for (ai = -128; ai <= 127; ai = ai + 1) begin

                for (bi = -128; bi <= 127; bi = bi + 1) begin

                    test_a = ai;
                    test_b = bi;

                    // Reset accumulator for this pair
                    rst = 1'b1;
                    en  = 1'b0;

                    @(posedge clk);
                    #1;

                    if (acc !== 0)
                        $fatal(
                            1,
                            "RESET FAILED at A=%0d B=%0d acc=%0d",
                            ai,
                            bi,
                            acc
                        );

                    rst = 1'b0;
                    en  = 1'b1;

                    a = test_a;
                    b = test_b;

                    expected_product =
                        $signed(test_a) * $signed(test_b);

                    @(posedge clk);
                    #1;

                    count = count + 1;

                    if (acc !== expected_product) begin

                        $display("");
                        $display("!!!!!!!! EXHAUSTIVE TEST FAILED !!!!!!!!");
                        $display("Case              = %0d", count);
                        $display("A                 = %0d", test_a);
                        $display("B                 = %0d", test_b);
                        $display("Expected product  = %0d",
                                 expected_product);
                        $display("Actual acc        = %0d", acc);
                        $display("");

                        $fatal(
                            1,
                            "EXHAUSTIVE SIGNED MAC TEST FAILED"
                        );
                    end


                    // Progress every 4096 cases
                    if ((count % 4096) == 0) begin
                        $display(
                            "EXHAUSTIVE TEST: %0d / 65536 PASSED",
                            count
                        );
                    end

                end
            end

            $display("");
            $display(
                "ALL 65,536 SIGNED INPUT COMBINATIONS PASSED."
            );
            $display("");

        end

    endtask

endmodule
