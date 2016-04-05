from myhdl import *

import unittest
from unittest import TestCase

def hardway2(results, results_valid, max_value, enable, clk, reset):
    """ implements a pythonlike solution to https://projecteuler.net/problem=2 , but not a synthesizable one"""

    
    @always_seq(clk.posedge, reset)
    def hardheaded2():
        f1 = 1
        f2 = 1
        results_int = 0
        while (f1 + f2) < max_value:
            results_int = results_int + f1 + f2
            #tuple assignment is not supported in hardware conversion
            #f1, f2 = f1 + (2 * f2), (2 * f1) + (3 * f2)
            #if these were signals, I wouldn't be worried about the below being sequential. Since they aren't though...
            f1_old = f1 #added because of sequential assignments
            f1 = f1 + (2 * f2)
            f2 = (2 * f1_old) + (3 * f2)
            #conversions get mad about print format strings
            #print "results %3d, max %d, f1 %3d, f2 %3d, f1+f2 %4d" % (results_int, max_value, f1, f2, f1+f2)
            
        results_valid.next = enable
        results.next = results_int
    return hardheaded2

def euler2_hw(results, results_valid, max_value, enable, clk, reset):
    """ implements a pythonlike solution to https://projecteuler.net/problem=2 that is synthesizable """

    fib_r1, fib_r2 = [Signal(intbv(1)[64:]) for i in range(2)]
    results_valid_int = Signal(bool()) 
    results_int = Signal(intbv(0)[64:])

    @always_comb
    def a():
        results.next = results_int
        results_valid_int.next = True if (fib_r1 + fib_r2) >= max_value else False

    #this needs it's own combinatorial generator because otherwise, we get an inout in always_comb function error
    @always_comb
    def c():
        results_valid.next = results_valid_int

    @always_seq(clk.posedge, reset)
    def b():
        if enable and not results_valid_int:
            fib_r1.next = fib_r1 + 2 * fib_r2
            fib_r2.next = (2 * fib_r1) + (3 * fib_r2)
            results_int.next = results_int + fib_r1 + fib_r2
        elif not enable:
            fib_r1.next = 1
            fib_r2.next = 1
            results_int.next = 0
            
    return a, b, c


class TestEuler2(TestCase):
    def setUp(self):
        self.reset = ResetSignal(0, active=1, async=True)
        self.results_valid, self.clk, self.enable = [Signal(bool()) for i in range(3)]
        self.results = Signal(intbv(0)[64:])
        self.clk_inst = self.run_clk(self.clk)
        self.results_hw = Signal(intbv(0)[64:])
        self.max_value = Signal(intbv(0)[64:])


    def run_clk(self, clk):
        half_period = delay(10)

        @always(half_period)
        def clkgen():
            clk.next = not clk

        return clkgen

    def euler2_py(self, n):
        f1 = 1
        f2 = 1
        mysum = 0
        while (f1 + f2) < n:
            mysum = mysum + f1 + f2
            f1, f2 = f1 + (2 * f2), (2 * f1) + (3 * f2)
        return mysum

    def set_and_check(self, max_value):
        self.max_value.next = max_value;
        yield self.clk.negedge
        self.enable.next = True
        yield self.results_valid 
        #print "expected results = %d" % self.euler2_py(self.max_value)
        #print "actual results   = %d" % self.results
        #notice that you can call euler2_py instead of yielding to it. How come? It's a regular python function. 
        self.assertEqual(self.results, self.euler2_py(self.max_value),
                             "does " + str(self.results) + " == " + str(self.euler2_py(self.max_value)) + " for max == " + str(self.max_value))
        yield self.clk.negedge
        self.enable.next = False
        yield self.clk.negedge


    def checkResultHw(self):
        self.reset.next = 1
        yield self.clk.negedge
        self.reset.next = 0

        print "set and check 100"
        #you can't call the function like
        #self.set_and_check(100)
        #instead you have to yield to it because it's a myHDL generator.
        yield self.set_and_check(100)
        print "set and check 10000"
        yield self.set_and_check(10000)
        print "set and check 4000000"
        yield self.set_and_check(4000000)

        raise StopSimulation


    def test_hardheaded(self):
        print "testing hardheaded"
        dut = traceSignals(euler2_hw, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)
        check = self.checkResultHw()
        Simulation(dut, check, self.clk_inst).run(3000)
        # if you pass in max_value as a constant, it gets converted to an internal constant, not a generic/parameter
        euler_hardheaded_inst = toVHDL(euler2_hw, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)
        
unittest.main()
