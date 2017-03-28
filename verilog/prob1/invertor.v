module myInvert_tb();
   wire out;
   reg  clk;

   always begin
      #1 clk = !clk;
   end

   initial begin
      $dumpfile("waves.vcd");
      $dumpvars(0,myInvert_tb);
      
        
      clk = 0;
      #10
        $finish; // or $stop?
   end

   // fancy debug tools
   initial begin
      $monitor("At time %t, input = %d, value = %d", $time, clk, out);
   end
   
   
   myInvert tada(clk, out);
endmodule // myInvert_tb

module myInvert(a,b);

   input wire a;
   output wire b;

   assign b = !a;
endmodule // myInvert

              
