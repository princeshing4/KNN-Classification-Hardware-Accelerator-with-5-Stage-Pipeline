`timescale 1ns / 1ps

module KNN_tb;

    reg         clk;
    reg         rst_n;
    reg  [63:0] test_vector;
    wire [3:0]  c1, c2, c3, c4, c5;
    wire [3:0]  final_class;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // DUT instantiation
    KNN dut (
        .clk(clk),
        .rst_n(rst_n),
        .test_vector(test_vector),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4),
        .c5(c5),
        .final_class(final_class)
    );

    initial begin
        $dumpfile("knn_tb.vcd");
        $dumpvars(0, KNN_tb);
        
        rst_n = 0;
        test_vector = 64'h0;
        
        $display("\n========== KNN Testbench ==========\n");
        
        #20;
        rst_n = 1;
        #10;
        
        // TEST 1: Class 0 sample
        $display("TEST 1: Class 0 (Setosa)");
        test_vector = {16'h0034, 16'h0024, 16'h000F, 16'h0003};
        #1600;
        $display("Result: Class %0d\n", final_class);
        
        #50;
        rst_n = 0;
        #30;
        rst_n = 1;
        #10;
        
        // TEST 2: Class 1 sample
        $display("TEST 2: Class 1 (Versicolor)");
        test_vector = {16'h0045, 16'h0021, 16'h002E, 16'h000F};
        #1600;
        $display("Result: Class %0d\n", final_class);
        
        #50;
        rst_n = 0;
        #30;
        rst_n = 1;
        #10;
        
        // TEST 3: Class 2 sample
        $display("TEST 3: Class 2 (Virginica)");
        test_vector = {16'h0040, 16'h0022, 16'h003B, 16'h0018};
        #1600;
        $display("Result: Class %0d\n", final_class);
        
        #50;
        rst_n = 0;
        #30;
        rst_n = 1;
        #10;
        
        // TEST 4: Boundary case
        $display("TEST 4: Boundary Case");
        test_vector = {16'h003C, 16'h001D, 16'h001F, 16'h0008};
        #1600;
        $display("Result: Class %0d\n", final_class);
        
        #100;
        $display("========== Tests Complete ==========\n");
        $finish;
    end
    
    initial begin
        #10000;
        $display("TIMEOUT!");
        $finish;
    end

endmodule
