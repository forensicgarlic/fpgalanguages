from myhdl import *

import unittest
from unittest import TestCase


def euler2(results, results_valid, n, clk, reset):
    """ implement a solution in hardware to https://projecteuler.net/problem=2 """

    even = Signal(bool())
    mysum, fib_r1, fib_r2 = [Signal(intbv(1, 1, n*10)) for i in range(3)]
    results_int = Signal(intbv(0, 0, 5000000))

    @always_comb
    def a():
        even.next = True if mysum[0] == 0 else False
        results_valid.next = True if mysum >= n else False
        results.next = results_int

    @always_comb
    def c():
        mysum.next = fib_r1 + fib_r2

    @always_seq(clk.posedge, reset)
    def b():
        fib_r1.next = mysum
        fib_r2.next = fib_r1
        if even:
            results_int.next = results_int + mysum
    return a, b, c

def euler2_hw(results, results_valid, max_value, enable, clk, reset):
    """ implements a pythonlike solution to https://projecteuler.net/problem=2 """

    mysum, fib_r1, fib_r2 = [Signal(intbv(1)[64:]) for i in range(3)]
    even, results_valid_int = [Signal(bool()) for i in range(2)]
    results_int = Signal(intbv(0)[64:])

    @always_comb
    def a():
        even.next = True if mysum[0] == 0 and enable else False
        results_valid_int.next = True if mysum >= max_value else False
        results.next = results_int

    @always_comb
    def c():
        mysum.next = fib_r1 + fib_r2
        results_valid.next = results_valid_int

    @always_seq(clk.posedge, reset)
    def b():
        if enable and not results_valid_int:
            fib_r1.next = mysum
            fib_r2.next = fib_r1
            if even:
                results_int.next = results_int + mysum
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
        print " "
        while (f1 + f2) < n:
            mysum = mysum + f1 + f2
            f1, f2 = f1 + (2 * f2), (2 * f1) + (3 * f2)
        return mysum

    def checkResult(self, i, results, results_valid, clk, reset):
        reset.next = 1
        yield clk.negedge
        reset.next = 0
        while 1:
            yield clk.negedge
            if results_valid:
                self.assertEqual(results, self.euler2_py(i),
                                 "does " + str(results) + " == " + str(self.euler2_py(i)) + " for i == " + str(i))
                raise StopSimulation

    def set_and_check(self, max_value):
        self.max_value.next = max_value;
        yield self.clk.negedge
        self.enable.next = True
        yield self.results_valid
        self.assertEqual(self.results, self.euler2_py(self.max_value),
                             "does " + str(self.results) + " == " + str(self.euler2_py(self.max_value)) + " for max == " + str(self.max_value))
        yield self.clk.negedge
        self.enable.next = False
        yield self.clk.negedge


    def checkResultHw(self):
        self.reset.next = 1
        yield self.clk.negedge
        self.reset.next = 0

        self.set_and_check(100)
        self.set_and_check(10000)

        raise StopSimulation

    def test100(self):
        i = 100
        dut = euler2(self.results, self.results_valid, i, self.clk, self.reset)
        check = self.checkResult(i, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)
        # euler_inst = toVHDL(euler2, self.results, self.results_valid, i, self.clk, self.reset)

    def test10000(self):
        i = 10000
        dut = euler2(self.results, self.results_valid, i, self.clk, self.reset)
        check = self.checkResult(i, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)

    def test4000000(self):
        i = 4000000
        dut = euler2(self.results, self.results_valid, i, self.clk, self.reset)
        check = self.checkResult(i, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)
        # euler_inst = toVHDL(euler2, self.results, self.results_valid, 4000000, self.clk, self.reset)

    def test_hw(self):
        dut = traceSignals(euler2_hw, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)
        check = self.checkResultHw()
        Simulation(dut, check, self.clk_inst).run(300000)
        euler_hw_inst = toVHDL(euler2_hw, self.results, self.results_valid, self.max_value, self.enable, self.clk, self.reset)

unittest.main()
