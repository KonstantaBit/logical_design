synth:
	verilator --trace --exe --binary -Wall testbench.v
	./obj_dir/Vtestbench

clean:
	rm -r ./obj_dir
	rm image.svg

visualise_netlistsvg:
	yosys -p "read_verilog zero_counter.v; prep -top zero_counter; write_json ./obj_dir/vis.json"
	netlistsvg ./obj_dir/vis.json -o image.svg