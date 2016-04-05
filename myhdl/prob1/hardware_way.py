from myhdl import *
from random import randrange
import unittest
from unittest import TestCase

ACTIVE_HIGH = 1
INACTIVE_LOW = 0


def euler1(results, results_valid, n, clk, reset):
    """ implement a solution in hardware to https://projecteuler.net/problem=1 """
    number = Signal(intbv(1, 1, n + 1))
    mod3 = Signal(intbv(0, 0, 3))
    mod5 = Signal(intbv(0, 0, 5))
    accumulate3 = Signal(bool())
    accumulate5 = Signal(bool())
    accumulate_en = Signal(bool())
    results_int = Signal(intbv(0, 0, 500000))

    @always_comb
    def b():
        """ combinatorial logic for enabling accumulator and output"""
        accumulate3.next = True if mod3 == 2 else False
        accumulate5.next = True if mod5 == 4 else False
        results.next = results_int

    @always_comb
    def c():
        """ seperate combinatorial block based off of myHDL errors trying to prevent combinatorial loops """
        accumulate_en.next = accumulate3 or accumulate5

    @always_seq(clk.posedge, reset)
    def a():
        """ sequential block, registering counters and results """
        if number != n:
            number.next = number + 1
        else:
            results_valid.next = True
        mod5.next = (mod5 + 1) % 5
        mod3.next = (mod3 + 1) % 3
        if accumulate_en:
            results_int.next = results_int + number

    return a, b, c


class TestEuler1(TestCase):
    def setUp(self):
        self.reset = ResetSignal(0, active=ACTIVE_HIGH, async=True)
        self.results_valid, self.clk = [Signal(bool()) for i in range(2)]
        self.results = Signal(intbv(0, 0, 500000))
        self.clk_inst = self.run_clk(self.clk)

    def run_clk(self, clk):
        HALF_PERIOD = delay(10)

        @always(HALF_PERIOD)
        def clkgen():
            clk.next = not clk

        return clkgen

    def euler1_py(self, n):
        threes = sum(range(0, n + 1, 3))
        fives = sum(range(0, n + 1, 5))
        fifteens = sum(range(0, n + 1, 3 * 5))
        return threes + fives - fifteens

    def checkResult(self, i, results, results_valid, clk, reset):
        reset.next = ACTIVE_HIGH
        yield clk.negedge
        reset.next = INACTIVE_LOW
        while 1:
            yield clk.negedge
            if results_valid:
                self.assertEqual(results, self.euler1_py(i),
                                 "does " + str(results) + " == " + str(self.euler1_py(i)) + " for i == " + str(i))
                raise StopSimulation

    def test9(self):
        dut = euler1(self.results, self.results_valid, 9, self.clk, self.reset)
        check = self.checkResult(9, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)

    def test99(self):
        dut = euler1(self.results, self.results_valid, 99, self.clk, self.reset)
        check = self.checkResult(99, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)

    def test999(self):
        dut = traceSignals(euler1, self.results, self.results_valid, 999, self.clk, self.reset)
        check = self.checkResult(999, self.results, self.results_valid, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)
        euler_inst = toVHDL(euler1, self.results, self.results_valid, 999, self.clk, self.reset)


unittest.main()
