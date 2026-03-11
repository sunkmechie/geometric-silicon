# GSE : Geometric Silicon Emitter
**Hardware Acceleration for Clifford Algebra Primitives**

GSE is the hardware-layer companion CLifford Algebra. It translates abstract Geometric Algebra (GA) signatures into high-performance, combinational Verilog logic. 


## Current Status: Cl(2,0) Euclidean
The repository currently provides a mathematically verified `Cl(2,0)` Geometric Product module.
- **Inputs**: 8-bit signed multivectors.
- **Outputs**: 18-bit signed result (to prevent overflow).
- **Architecture**: Optimized for DSP48 slice mapping on FPGAs.

## Repository Structure
- `src/`: Python-based Verilog generation logic.
- `rtl/`: Generated Verilog modules (The "Silicon").
- `sim/`: Verification testbenches.

## Quickstart
To run the hardware simulation (requires `iverilog`):

```bash
cd sim
chmod +x run_sim.sh
./run_sim.sh
```
