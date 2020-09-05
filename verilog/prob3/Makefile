all: iverilog verilator

iverilog: waves_euler3.vcd

verilator: waves_euler3.fst

waves_euler3.vcd: euler3.v euler3_tb.v
	iverilog -o euler3_tb.out euler3.v euler3_tb.v -g2005-sv
	vvp euler3_tb.out
#	gtkwave waves_euler3.vcd &

waves_euler3.fst: euler3.v test.cc
	verilator -Wall --cc euler3.v --exe --build test.cc --trace-fst
	./obj_dir/Veuler3

clean:
	rm -rf *.bin *.txt *.blif *.out *.vcd *~ *.fst obj_dir

# verilator takes 6 seconds,
# iverilog takes 99 seconds.

#dstanfor@garlic:~/git/fpgalanguages/verilog/prob3$ time make verilator
#verilator -Wall --cc euler3.v --exe --build test.cc --trace-fst
#make[1]: Entering directory '/home/dstanfor/git/fpgalanguages/verilog/prob3/obj_dir'
#g++  -I. -Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o test.o ../test.cc
#g++  -I. -Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o verilated.o /usr/local/share/verilator/include/verilated.cpp
#g++  -I. -Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o verilated_fst_c.o /usr/local/share/verilator/include/verilated_fst_c.cpp
#/usr/bin/perl /usr/local/share/verilator/bin/verilator_includer -DVL_INCLUDE_OPT=include Veuler3.cpp Veuler3__Trace.cpp Veuler3__Slow.cpp Veuler3__Syms.cpp Veuler3__Trace__Slow.cpp > Veuler3__ALL.cpp
#g++  -I. -Wall -Wextra -Wfloat-conversion -Wlogical-op -Werror -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o Veuler3__ALL.o Veuler3__ALL.cpp
#Archive ar -cr Veuler3__ALL.a Veuler3__ALL.o
#g++    test.o verilated.o verilated_fst_c.o Veuler3__ALL.a   -lz    -o Veuler3
#make[1]: Leaving directory '/home/dstanfor/git/fpgalanguages/verilog/prob3/obj_dir'
#./obj_dir/Veuler3
#10970717
#
#real	0m6.081s
#user	0m5.764s
#sys	0m0.267s
#dstanfor@garlic:~/git/fpgalanguages/verilog/prob3$ time make iverilog
#iverilog -o euler3_tb.out euler3.v euler3_tb.v -g2005-sv
#vvp euler3_tb.out
#VCD info: dumpfile waves_euler3.vcd opened for output.
#results:             10970717
#
#real	1m39.985s
#user	1m38.687s
#sys	0m0.793s
