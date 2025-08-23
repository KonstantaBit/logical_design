synth:
	verilator --trace --exe --binary testbench.v
	./obj_dir/Vtestbench

clean:
	rm -r ./obj_dir

visualise:
	yosys -p "read_verilog csa.v csa_tree.v; prep -top csa_tree; write_json ./obj_dir/vis.json"
	netlistsvg ./obj_dir/vis.json -o image.svgvisualise_graphviz:
	yosys -p "read_verilog top.v; show"