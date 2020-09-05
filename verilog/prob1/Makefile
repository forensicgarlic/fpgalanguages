all: sim 

sim: waves_euler1.vcd

waves_euler1.vcd: euler1.v euler1_tb.v
	iverilog -o euler1_tb.out euler1.v euler1_tb.v
	vvp euler1_tb.out
	gtkwave waves_euler1.vcd &

clean:
	rm -rf *.bin *.txt *.blif *.out *.vcd *~
