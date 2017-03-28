
//interface
module euler1(clk, reset, max_value, enable, results_valid, results);
   input wire clk, reset, enable;
   input wire [15:0] max_value;
   
   output reg results_valid;
   output reg [23:0] results;
   reg [1:0] mod3;
   reg [2:0] mod5;
   reg [15:0] cnt;
   
   wire      accum3, accum5;
   

   // NOTES::
   // python has ruined me. parens around an if? begin and end?
   // also, the clarity of constant assignment widths might be nice sometimes,
   // but for this simple problem, it looks like garbage.
   // and you'd think with so much specificity here, they woudln't let you
   // get away with assigning constants of the wrong size elsewhere, but you'd
   // be very wrong.
   // it wasn't obvious where I did it, but somewhere in the cnt / results assignment
   // I used a blocking assignment, and it fucked up all the math. So that's a lovely
   // danger to run into with the language. It feels like the sort of thing that once you're
   // used to it, you'll be fine, but if you do a lot of language switching, or poor testing
   // you might miss a few. I bet verilog linters take a hard look at any = assignments. 
   always @ (posedge clk)
     begin
        if (reset == 1'b1) begin
           mod3 <= 1;
           mod5 <= 1;
           cnt <= 1;
           results_valid <=0;
           results <=0;
           
        end else begin
        
           // 1 2 bit 3's counter
           if (cnt < max_value) begin
              if (mod3 == 2'd3) begin
                 mod3 <= 1;
              end else begin 
                 mod3 <= mod3 + 1;
              end
           end else begin
              mod3 <= 1;
           end
           
           // 1 3 bit 5's counter
           if (cnt < max_value) begin
              if (mod5 == 3'd5) begin
                 mod5 <= 1;
              end else begin
                 mod5 <= mod5 + 1;
              end
           end else begin
             mod5 <= 1;
           end
           
           // the below runs into problems because apparently the cnt value
           // is evaluated after addition instead of the registered version.
           // changing cnt <= cnt + 1 to cnt = cnt + 1 had no effect. 
           //if (cnt == max_value) begin
           //   results_valid <= 1;
           //end else if (accum3 | accum5) begin
           //   results <= results + cnt;
           //end
           if (cnt == max_value) begin
              results_valid <= 1;
           end else begin
           
              cnt <= cnt + 1;
           end
           if (accum3 | accum5) begin
              results <= results + cnt;
           end
        end
     end
   
   assign accum3 = mod3 == 3;
   assign accum5 = mod5 == 5;
   
        
// it's tempting to simply write the problem in python and have myHDL convert it to a verilog file
// but that's not really the goal. But looking at some of the basics tutorials for the language, and
// boy oh boy it's been a while since I've done this from scratch, and I have a feeling verilog isn't
// going to be as friendly in tutorials as python was.

   // reading through some of these 'helpful tutorials' and holy moly I completely understand why someone
   // might give up pretty quick on hardware design if they just had these 

   // after getting through dumb typos, problem one is trying to figure out how the simulator works. 
   // I correctly guessed that you call it, and the file to simulate. But then icarus makes an a.out file. 
   // what's that for? More web page reading for me I guess.  
   
   // step one -- while we've given you a simulator, you only get printf's for debug capability. woo. 
   // which to be fair for these simple problems is probably enough.

   // step two -- oh, you want a vcd file? well guess what, you have to mention that in the file.
   // not actually unusual, but with the majority of my experience with ModelSim, it still feels weird
   // declaring what you're monitoring in the file you're actually create the signals in. 
//      
endmodule // euler1
