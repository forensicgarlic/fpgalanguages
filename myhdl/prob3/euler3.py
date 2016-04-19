from myhdl import *

import unittest
from unittest import TestCase

def euler3(results, results_valid, max_value, enable, clk, reset):
    """ implements a pythonic solution to https://projecteuler.net/problem=3"""

    #x, y, roots, product = [Signal(intbv(1)[64:]) for i in range(4)]
    # shaving 16 bits gives us almost double the Fmax! 
    x, y, roots, product = [Signal(intbv(1)[48:]) for i in range(4)]

    results_valid_int = Signal(bool(False))

    @always_comb
    def b():
        results_valid.next = results_valid_int

    @always_comb
    def c():
        results_valid_int.next = (product == max_value)
        results.next = roots
        
    @always_seq(clk.posedge, reset)
    def a():
        if enable and not results_valid_int:
            if (y % x == 0):
                roots.next = x
                product.next = product * x
                y.next = y // x
            else:
                x.next = x + 1
        elif not enable:
            # algorithm initialization
            roots.next = 0
            product.next = 1
            x.next = 2
            y.next = max_value

    return a, b, c
    
class TestEuler3(TestCase):
    def setUp(self):
        self.reset = ResetSignal(0, active=1, async=True)
        self.results_valid, self.clk, self.enable = [Signal(bool()) for i in range(3)]
        self.results = Signal(intbv(0)[64:])
        self.clk_inst = self.run_clk(self.clk)
        self.max_value = Signal(intbv(0)[64:])

    def run_clk(self, clk):
        half_period = delay(63) # quartus says Fmax is ~ 8 Mhz with non-pipelined / and * operations and 64 bit vectors 

        @always(half_period)
        def clkgen():
            clk.next = not clk

        return clkgen

    def euler3_py(self, number):
        roots = 0
        product = 1
        x = 2
        y = number
        while product != number:
	    while (y % x == 0):
                roots = x
		y /= x
                product *= roots
	    x += 1
        return roots


    def set_and_check(self, max_value):
        print "starting set and check with max = %d" % max_value
        self.max_value.next = max_value
        yield self.clk.negedge
        self.enable.next = True
        yield self.results_valid
        self.assertEqual(self.results, self.euler3_py(max_value), "does " +str(self.results) + " == " + str(self.euler3_py(max_value)) + " for max == " + str(self.max_value))

        yield self.clk.negedge
        self.enable.next = False
        yield self.clk.negedge
        
        
    def runTest(self):
        self.reset.next = 1
        yield self.clk.negedge
        self.reset.next = 0

        yield self.set_and_check(100)
        yield self.set_and_check(1000)
        yield self.set_and_check(600851475143)
        print "done successfully"
        raise StopSimulation
    
    def test_hardware(self):
        dut = traceSignals(euler3, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)
        my_test = self.runTest()
        Simulation(dut, my_test, self.clk_inst).run(1500000)
        euler3_vhdl = toVHDL(euler3, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)
    
unittest.main()
