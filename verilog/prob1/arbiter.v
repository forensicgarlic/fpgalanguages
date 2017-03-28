module arbiter_tb();
   wire gnt_0, gnt_1;
   reg  req_0, req_1, clk, testFail;
   
   
   always begin
      #1 clk = !clk;
   end

   always begin
      #4 req_0 = !req_0;
   end

   always begin
      #6 req_1 = !req_1;
   end

   initial begin
      $dumpfile("waves_arb.vcd");
      $dumpvars(0, arbiter_tb);
      clk = 0;
      testFail = 0;
      req_0 = 0;
      req_1 = 1;
      #96
        $finish;
   end

   initial begin
      $monitor("At time %t r0 = %d, r1 = %d, g0 = %d, g1=%d, testFail =%d", $time, req_0, req_1, gnt_0, gnt_1, testFail);
   end

   // having to code this was pretty upsetting. I think using a language
   // where we've already built up the library for test assertions (even
   // though they weren't included by default) and having done a decent
   // amount of python testing (where someone else did that hardwork for
   // me) made me forget the pain of low level hardware design for some
   // reason. My guess is no languages the age of VHDL or Verilog were
   // smart enough to be designed with self checking testing in mind, but
   // now that I don't have to live that reality every day, I've forgotten
   // some of the pain of it. 
   always @ (posedge clk)
     begin
        if (gnt_0 == gnt_1) begin 
           $display("things are bad");
           testFail = 1;
        end
     end
   
   arbiter arb(clk, reset, req_0, req_1, gnt_0, gnt_1);
   
   
endmodule

module arbiter(clk, reset, req0, req1, gnt0, gnt1);
   
   input clk, reset, req0, req1;
   output gnt0, gnt1;
   wire   clk, reset, req0, req1;
   // are there any registers? -- of course, you're using a clk
   reg    gnt0, gnt1;
    

   always @ (posedge clk or posedge reset)
     begin
        if (reset) begin
           gnt0 <= 1'b0;
           gnt1 <= 1'b0;
        end else if (req0) begin
           gnt0 <= 1'b1;
           gnt1 <= 1'b0;
        end else if (req1) begin
           gnt1 <= 1'b1;
           gnt0 <= 1'b0;
//        end else begin
//           gnt1 <= 1'b0;
//           gnt0 <= 1'b0;
        end
     end
endmodule // arbiter
