// initial module copied from euler2.

module euler3( input logic clk,
	       input logic 	  reset,
	       input logic 	  enable,
	       output logic 	  results_valid,
	       output logic [63:0] results
	       );


   
//The prime factors of 13195 are 5, 7, 13 and 29.
//
//What is the largest prime factor of the number 600851475143 ?

   // factors -- integers multiplied by other integers that will equal the given number.
   // prime numbers -- integers whose factors are only 1 and themselves.
   // prime factors -- both of the above.


   // finding the largest prime factor would typically mean a lot of 
   // division. division is not an fpga's strong suit. 

   logic 			   results_valid_int;
   logic [63:0] 		   product;
   logic [63:0] 		   max_value = 64'h600851475143;
   logic [63:0] 		   roots;
   logic [63:0] 		   y;
   logic [63:0] 		   x;

// this is the same thing i did for the myhdl path. 
   // i'm still not real happy with doing modulous and divide here. 
   // i don't really care to self discover the right algorithm, vs trying
   // to implement the right algorithm in the language.
   // this sort of algorithm is fine for a simulation model, but bad for
   // actual hardware. 
   // this basically translated right in, with just some tweaks about the reset
   assign results_valid = results_valid_int;
   assign results_valid_int = (product == max_value);
   assign results = roots;

   always @(posedge clk) begin
      if (reset == 1 || enable == 0) begin
	 roots <= 0;
	 product <= 1;
	 x <= 2;
	 y <= max_value;
      end else if (enable == 1 && results_valid_int == 0) begin
	 if (y % x == 0) begin
	    roots <= x;
	    product <= product * x;
	    y <= y / x;
	 end else begin
	   x <= x + 1;
	 end
      end else if (enable == 0) begin
      end
   end
endmodule 
 
   
