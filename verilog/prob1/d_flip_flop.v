module myDFF_tb();
   wire out, out_bar;
   reg  clk, d;

   always begin
      #1 clk = !clk; // every time period, invert the clk
   end

   always begin
      #2 d = !d;
   end
   
   
   initial begin
      $dumpfile("waves_dff.vcd");
      $dumpvars(0, myDFF_tb);

      clk = 0;
      d = 1;
       
      #10
        $finish;
   end

   initial begin
      $monitor("At time %t input = %d, value = %d", $time, d, out);
   end

   d_ff myName(d, clk, out, out_bar);
endmodule // myDFF_tb


module d_ff(d, clk, q, q_bar);
   input d, clk;
   output q, q_bar;
   wire   d, clk;
   reg    q, q_bar;

   always @ (posedge clk)
     begin
        q <= d;
        q_bar <= ! d;
     end
endmodule // d_ff
