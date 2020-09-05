// ugh, i don't want to write a test in verilog, but
// i also want to actually get something done, and not
// spend the next 2 hours figuring out what's up with cocotb
// and/or verilator to write a test in a better language.
// so iverilog to the rescue, since this is basicallly a stupid
// test anyway.

module euler2_tb();
   logic clk = 0;
   logic reset;
   logic testFail;
   logic [31:0] MAX_VALUE;
   wire  [31:0] results; // woah woah woah, this can't be logic because it/s
                         // driven by the uut? this is not right, right? 
   logic 	enable = 1;
   
   always begin
      #1 clk = !clk;
   end

   task wait_until_or_timeout(input logic signal);
      fork
	 begin
	    @(posedge signal)
	      disable wait_until_or_timeout;
	 end
	 
	 begin
	    #100000 // can you pass a time duration? that'd be better
	      // turns out not really, without making the task it's own class
	      disable wait_until_or_timeout;
	 end
      join
   endtask // signal
   
   
   initial begin
      $dumpfile("waves_euler2.vcd");
      $dumpvars(0, euler2_tb);
      testFail = 0;
      reset = 0;
      MAX_VALUE = 4000000;
      #2 reset = 1;
      #4 reset = 0;
      // this is dumb. you should wait until results_valid = 1.
      // you could just @(posedge results_valid) here, or call a task
      // with a timeout and posedge sensativity list. fancy. 
      //#2020 $display("results: %d", results);
      wait_until_or_timeout(results_valid);
      $display("results: %d", results);
      $finish;
   end // initial begin
   
   euler2 inst2(clk, reset, enable, MAX_VALUE, results_valid, results);

endmodule // euler2_tb
