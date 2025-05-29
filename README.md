**Tiled Matrix Multiplication Unit (TMMU)**

This project presents the design and implementation of a Tiled Matrix Multiplication Unit (TMMU)—a hardware accelerator built using Verilog for efficient matrix computation in edge AI systems. Developed as a Master’s thesis at The University of Texas at San Antonio, this project provides a practical and open reference for custom AI hardware based on systolic array architecture.

**📌 Overview**

Matrix multiplication is a cornerstone operation in deep learning. While cloud systems often rely on GPUs or TPUs, edge devices require lightweight, efficient alternatives. The TMMU meets this need by:

* Supporting basic and tiled matrix multiplication

* Using an INT8 data format for optimal energy efficiency

* Integrating a 4×4 systolic Tensor Processing Unit (TPU)

* Employing a CISC instruction set for control flexibility

**🧱 Architecture**

The TMMU consists of two main layers:

* **Level 2 Controller (TMMU)**: Top-level unit handling data flow and instruction sequencing

* **Level 1 Controller (TPU)**: Manages fine-grained execution of matrix operations

Key components include:

* Instruction decoders

* Host memory modules

* Activation normalization unit (with ReLU)

* Systolic data setup and MMU

**⚙️ Features**

* Supports matrix sizes from 1×1 to 8×8 via tiling

* Tiled matrix computation strategy improves memory locality and parallelism

* Cycle-accurate simulation using Verilog testbenches

* Power estimation via Xilinx Vivado

* Physical design and floorplanning using Cadence Innovus

**📈 Performance**

* 4×4 multiplication: ~3,000 ns (150 cycles)

* 8×8 tiled multiplication: ~17,000 ns (850 cycles)

* Supports pipelined operation across matrix blocks

* Estimated for edge-level ASIC feasibility

**🛠️ Tools Used**

* Verilog HDL

* Xilinx Vivado (simulation and power analysis)

* Cadence Innovus (physical layout and DRC)

* Adobe Illustrator (for diagrams and documentation)

📁 Project Structure

├── src/                   
:Verilog source files for all modules

├── testbenches/           
:Simulation testbenches

├── doc/                   
:Project report and architectural diagrams

├── results/               
:Simulation waveforms and power reports

└── README.md

**📚 Documentation**

For a deep dive into the architecture, control flow, FSM diagrams, and simulation results, please refer to the full Graduation Project Report (PDF).

**🧪 How to Simulate**

1. Open Xilinx Vivado.

2. Import source files and testbenches.

3. Run behavioral simulation for tmmu_top.v.

4. Use waveform viewer to inspect matrix results, timing, and FSM transitions.

**🧩 Future Work**

* Add support for larger matrix sizes with multi-core TMMU integration

* Implement more activation functions (e.g., Sigmoid, Tanh)

* Explore ASIC fabrication

* Optimize control FSMs and eliminate logic redundancy

**👨‍💻 Author**

Chao-Jia Liu (Peter)
M.S. in Electrical Engineering
The University of Texas at San Antonio
http://www.linkedin.com/in/chaojialiu615 | peterliu880615@gmail.com
