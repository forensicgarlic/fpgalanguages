from myhdl import *
import unittest
from unittest import TestCase

ACTIVE_HIGH = 1
INACTIVE_LOW = 0

def hardway(results, results_valid, max_count, enable, clk, reset):

    threes, fives, fifteens = [Signal(intbv(0,0,500000)) for i in range(3)]
    sumthrees, sumfives, sumfifteens = [Signal(intbv(0,0,500000)) for i in range(3)]

    def if_less_add(counter, max_count, count_value, accumulator, enable, clk, reset):
        ''' we could use this as an accumulator function. It doesn't save lines of code, but does save rewritten code'''
        @always_seq(clk.posedge, reset)
        def acc():
            if enable==1:
                if counter < max_count:
                    counter.next = counter + count_value
                    accumulator.next = accumulator + counter
        return acc

    @always_seq(clk.posedge, reset)
    def count_by_cycle():
        ''' Enable the hardware to have 3 counters and 3 accumulators, as well as an extra state to calculate final values'''
        onemore = 0
        if enable == 1:
            if threes < max_count:
                threes.next = threes + 3
                sumthrees.next = sumthrees + threes
            elif onemore == 0: 
                ''' give accumumlators another clock '''
                onemore = 1
            else:
                ''' taking advantage of knowing threes will take longer to get to it's max'''
                results_valid.next = True
                results.next = sumthrees + sumfives - sumfifteens

            if fives < max_count:
                fives.next = fives + 5
                sumfives.next = sumfives + fives

            if fifteens < max_count:
                fifteens.next = fifteens + 15
                sumfifteens.next = sumfifteens + fifteens

    return count_by_cycle



class TestHardHeaded(TestCase):
    def setUp(self):
        self.reset = ResetSignal(0, active=ACTIVE_HIGH, async=True)
        self.results_valid, self.clk, self.enable = [Signal(bool(False)) for i in range(3)]
        self.results = Signal(intbv(0, -500000, 500000)) #converting to VHDL requires a calcualble size. 
        self.clk_inst = self.run_clk(self.clk)

    def run_clk(self, clk):
        HALF_PERIOD = delay(10)

        @always(HALF_PERIOD)
        def clkgen():
            clk.next = not clk
        return clkgen

    def euler1_python(self, n):
        threes = sum(range(0, n + 1, 3))
        fives = sum(range(0, n + 1, 5))
        fifteens = sum(range(0, n + 1, 3 * 5))
        return threes + fives - fifteens

    def checkResult(self, i, results, results_valid, enable, clk, reset):
        reset.next = ACTIVE_HIGH
        yield clk.negedge
        reset.next = INACTIVE_LOW
        yield clk.negedge
        enable.next = ACTIVE_HIGH
        while 1:
            yield clk.negedge
            if results_valid:
                self.assertEqual(results, self.euler1_python(i),
                                 "does " + str(results) + " == " + str(self.euler1_python(i)) + " for i == " + str(i))
                raise StopSimulation

    def test999(self):
        dut = traceSignals(hardway, self.results, self.results_valid, 999, self.enable, self.clk, self.reset)
        check = self.checkResult(999, self.results, self.results_valid, self.enable, self.clk, self.reset)
        Simulation(dut, check, self.clk_inst).run(300000)
        euler_inst = toVHDL(hardway, self.results, self.results_valid, 999, self.enable, self.clk, self.reset)

unittest.main()
