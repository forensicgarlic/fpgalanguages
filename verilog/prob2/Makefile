all: sim

sim: waves_euler2.vcd

waves_euler2.vcd: euler2.v euler2_tb.v
	iverilog -o euler2_tb.out euler2.v euler2_tb.v
	vvp euler2_tb.out
#	gtkwave waves_euler2.vcd &

clean:
	rm -rf *.bin *.txt *.blif *.out *.vcd *~
