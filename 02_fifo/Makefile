synth:
	verilator --trace --exe --binary -Wall testbench.v
	./obj_dir/Vtestbench

clean:
	rm -r ./obj_dir

visualise:
	yosys -p "read_verilog shift_fifo.v; prep -top shift_fifo; write_json ./obj_dir/vis.json"
	netlistsvg ./obj_dir/vis.json -o image.svgvisualise_graphviz:
	yosys -p "read_verilog shift_fifo.v; show"