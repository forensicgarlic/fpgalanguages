// Verilator testbench.

// Verilator Tutorial googling doesn't show you much, just the manual and
// a zipcpu tutorial from an older version of the code. Luckily Dan Guisselquist
// is an excellent tutorial writer. The manual is not quite as excellent where
// some steps are assumed to be understood. 

#include <stdlib.h>
#include "obj_dir/Veuler3.h" // verilated module
#include "verilated.h" // verilator references
#include <iostream>
#include "verilated_fst_c.h" // for fst output

int main (int argc, char **argv) {
  Verilated::commandArgs(argc, argv); // to parse the commandline (which we don't utiliize)
  Verilated::traceEverOn(true); // turn on the tracing
  VerilatedFstC* tfp = new VerilatedFstC; 
  Veuler3 *tb = new Veuler3;
  tb->trace(tfp, 99);
  tfp->open("waves_euler3.fst");
  int cnt = 0;
  // tick until done

  // this loop while results !valid is great, better than doing it in
  // a verilog testbench. cnt can also easily be added to the below line
  // and used as a timeout for safety sake. 
  while (!Verilated::gotFinish() && tb->results_valid == 0){

    // This clock sucks, and should be ported into something else, but for this
    // first 'testbench' is ok
    tb->clk = 1;
    tb->eval();
    tb->clk = 0;
    tb->eval();
    cnt++;
    tfp->dump(cnt); // for the waveform
    // this is not awesome, but we're doing this based off our two examples,
    // so it's ok for now. 
    if (cnt > 10)
      tb->enable = 1;
  }
  tfp->close();
  // a real test ought to verify the results match expected. 
  std::cout << tb->results << std::endl;
  exit(EXIT_SUCCESS);
}
