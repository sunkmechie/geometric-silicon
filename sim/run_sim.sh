#!/bin/bash
# 1. Compile the Verilog source and testbench
iverilog -o gse_sim.vvp ../rtl/geometric_product_cl20.v testbench.v

# 2. Run the simulation
vvp gse_sim.vvp
