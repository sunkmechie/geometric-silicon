// ─────────────────────────────────────────────────────────────────
// Testbench for geometric_product_cl20
// Tests known Cl(2,0) identities so you can verify correctness.
//
// Run:
//   iverilog -o sim geometric_product_cl20.v testbench.v && vvp sim
// ─────────────────────────────────────────────────────────────────
`timescale 1ns/1ps

module testbench;

    // ── DUT inputs (driven by us) ─────────────────────────────────
    reg signed [7:0]  a0, a1, a2, a12;
    reg signed [7:0]  b0, b1, b2, b12;

    // ── DUT outputs (we read these) ───────────────────────────────
    wire signed [17:0] c0, c1, c2, c12;

    // ── Instantiate the generated module ─────────────────────────
    geometric_product_cl20 dut (
        .a0(a0), .a1(a1), .a2(a2), .a12(a12),
        .b0(b0), .b1(b1), .b2(b2), .b12(b12),
        .c0(c0), .c1(c1), .c2(c2), .c12(c12)
    );

    // ── Test counter ──────────────────────────────────────────────
    integer pass = 0;
    integer fail = 0;

    // ── Helper task: check one output blade ───────────────────────
    task check;
        input [63:0]    test_num;
        input [127:0]   label;
        input signed [17:0] got;
        input signed [17:0] expected;
        begin
            if (got === expected) begin
                $display("  PASS  Test %0d %-12s  got=%0d", test_num, label, got);
                pass = pass + 1;
            end else begin
                $display("  FAIL  Test %0d %-12s  got=%0d  expected=%0d",
                          test_num, label, got, expected);
                fail = fail + 1;
            end
        end
    endtask

    initial begin
        $display("\n=== Cl(2,0) Geometric Product Testbench ===\n");

        // ── Test 1: e1 * e1 = +1 (scalar) ────────────────────────
        // Algebra rule: e1² = +1 in Cl(2,0)
        $display("Test 1: e1 * e1 = scalar(1)");
        {a0,a1,a2,a12} = {8'd0, 8'd1, 8'd0, 8'd0};
        {b0,b1,b2,b12} = {8'd0, 8'd1, 8'd0, 8'd0};
        #10;
        check(1, "c0(scalar)", c0,  18'd1);
        check(1, "c1(e1)",     c1,  18'd0);
        check(1, "c2(e2)",     c2,  18'd0);
        check(1, "c12(e12)",   c12, 18'd0);

        // ── Test 2: e2 * e2 = +1 (scalar) ────────────────────────
        $display("\nTest 2: e2 * e2 = scalar(1)");
        {a0,a1,a2,a12} = {8'd0, 8'd0, 8'd1, 8'd0};
        {b0,b1,b2,b12} = {8'd0, 8'd0, 8'd1, 8'd0};
        #10;
        check(2, "c0(scalar)", c0,  18'd1);
        check(2, "c1(e1)",     c1,  18'd0);
        check(2, "c2(e2)",     c2,  18'd0);
        check(2, "c12(e12)",   c12, 18'd0);

        // ── Test 3: e1 * e2 = +e12 ───────────────────────────────
        $display("\nTest 3: e1 * e2 = e12");
        {a0,a1,a2,a12} = {8'd0, 8'd1, 8'd0, 8'd0};
        {b0,b1,b2,b12} = {8'd0, 8'd0, 8'd1, 8'd0};
        #10;
        check(3, "c0(scalar)", c0,  18'd0);
        check(3, "c1(e1)",     c1,  18'd0);
        check(3, "c2(e2)",     c2,  18'd0);
        check(3, "c12(e12)",   c12, 18'd1);

        // ── Test 4: e2 * e1 = -e12  (anticommutativity) ──────────
        $display("\nTest 4: e2 * e1 = -e12  (anticommutative)");
        {a0,a1,a2,a12} = {8'd0, 8'd0, 8'd1, 8'd0};
        {b0,b1,b2,b12} = {8'd0, 8'd1, 8'd0, 8'd0};
        #10;
        check(4, "c0(scalar)", c0,   18'd0);
        check(4, "c1(e1)",     c1,   18'd0);
        check(4, "c2(e2)",     c2,   18'd0);
        check(4, "c12(e12)",   c12, -18'd1);

        // ── Test 5: e12 * e12 = -1 ───────────────────────────────
        // e12² = e1*e2*e1*e2 = -e1*e1*e2*e2 = -1
        $display("\nTest 5: e12 * e12 = scalar(-1)");
        {a0,a1,a2,a12} = {8'd0, 8'd0, 8'd0, 8'd1};
        {b0,b1,b2,b12} = {8'd0, 8'd0, 8'd0, 8'd1};
        #10;
        check(5, "c0(scalar)", c0,  -18'd1);
        check(5, "c1(e1)",     c1,   18'd0);
        check(5, "c2(e2)",     c2,   18'd0);
        check(5, "c12(e12)",   c12,  18'd0);

        // ── Test 6: scalar * anything = anything (identity) ──────
        // 3 * (2 + 4*e1) = 6 + 12*e1
        $display("\nTest 6: scalar(3) * (2 + 4*e1) = 6 + 12*e1");
        {a0,a1,a2,a12} = {8'd3, 8'd0, 8'd0, 8'd0};
        {b0,b1,b2,b12} = {8'd2, 8'd4, 8'd0, 8'd0};
        #10;
        check(6, "c0(scalar)", c0,  18'd6);
        check(6, "c1(e1)",     c1,  18'd12);
        check(6, "c2(e2)",     c2,  18'd0);
        check(6, "c12(e12)",   c12, 18'd0);

        // ── Test 7: Rotor acting on e1 ────────────────────────────
        // R = 1 + e12  (unnormalized rotor)
        // v = e1
        // R*v = 1*e1 + e12*e1
        //     = e1   + (-e2)     ← e12*e1 = -e2  (from Cayley table)
        //     = e1 - e2
        $display("\nTest 7: (1 + e12) * e1 = e1 - e2");
        {a0,a1,a2,a12} = {8'd1, 8'd0, 8'd0, 8'd1};  // R = 1 + e12
        {b0,b1,b2,b12} = {8'd0, 8'd1, 8'd0, 8'd0};  // v = e1
        #10;
        check(7, "c0(scalar)", c0,   18'd0);
        check(7, "c1(e1)",     c1,   18'd1);
        check(7, "c2(e2)",     c2,  -18'd1);   // e12*e1 = -e2
        check(7, "c12(e12)",   c12,  18'd0);

        // ── Summary ───────────────────────────────────────────────
        $display("\n─────────────────────────────────────────");
        $display("  Results: %0d passed,  %0d failed", pass, fail);
        if (fail == 0)
            $display("  ✓ All tests passed — Cayley table is correct!");
        else
            $display("  ✗ Failures detected — check assign logic.");
        $display("─────────────────────────────────────────\n");

        $finish;
    end

endmodule
