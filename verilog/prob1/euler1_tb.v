
// it's so long between builds that I forget the commands to actually compile
// iverilog <filename> -o <outputfile>
// and simulate
// vvp <outputfile>
   

module euler1_tb();
   reg clk, testFail;
   reg reset;
   reg [15:0] max_value;
   wire [23:0] results;
   always begin
      #1 clk = !clk;
   end

   initial begin
      $dumpfile("waves_euler1.vcd");
      $dumpvars(0, euler1_tb);
      clk = 0;
      testFail = 0;
      reset = 0;
      max_value = 999;
      #2
        reset = 1;
      #4
        reset = 0;
      
      #2020
        $display("results: %d",results);
        // I can't seem to get iverilog to use asserts from SystemVerilog. I got to try this with ModelSim
        //assert (results == 233168) $display("results: %d",results);
        //else $error("results are bad");
      $finish;
   end
   // Test Driven Design? oops.

   
   // easy mistake, it's generic name, instance name, not instance name, generic name
   euler1 inst1(clk, reset, max_value, enable, results_valid, results);

endmodule // euler1_tb

