// this is basically the euler2 test, but for the 3rd problem. 
module euler3_tb();
   logic clk = 0;
   logic reset;
   logic testFail;
   logic [31:0] MAX_VALUE;
   wire  [63:0] results; 
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
	    #100000000 
	      disable wait_until_or_timeout;
	 end
      join
   endtask // signal
   
   
   initial begin
      $dumpfile("waves_euler3.vcd");
      $dumpvars(0, euler3_tb);
      testFail = 0;
      reset = 0;
      MAX_VALUE = 4000000;
      #2 reset = 1;
      #4 reset = 0;
      wait_until_or_timeout(results_valid);
      $display("results: %d", results);
      $finish;
   end // initial begin
   
   euler3 inst3(clk, reset, enable, results_valid, results);

endmodule // euler3_tb
