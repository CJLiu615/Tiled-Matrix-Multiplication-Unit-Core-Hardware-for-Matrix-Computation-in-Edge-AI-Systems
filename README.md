**Tiled Matrix Multiplication Unit (TMMU)**

This project presents the design and implementation of a Tiled Matrix Multiplication Unit (TMMU)—a hardware accelerator built using Verilog for efficient matrix computation in edge AI systems. Developed as a Master’s thesis at The University of Texas at San Antonio, this project provides a practical and open reference for custom AI hardware based on systolic array architecture.

**📌 Overview**

Matrix multiplication is a cornerstone operation in deep learning. While cloud systems often rely on GPUs or TPUs, edge devices require lightweight, efficient alternatives. The TMMU meets this need by:

* Supporting basic and tiled matrix multiplication

![image](https://github.com/user-attachments/assets/828bfb23-6e80-4936-87ee-bd5197526a65)

![image](https://github.com/user-attachments/assets/d0a48ad2-c289-4cfe-8faf-fe088b2031c6)

* Using an INT8 data format for optimal energy efficiency

* Integrating a 4×4 systolic Tensor Processing Unit (TPU)

* Employing a CISC instruction set for control flexibility

![image](https://github.com/user-attachments/assets/6d7119c5-aa1e-4bd5-95b7-747b0647b96d)

![image](https://github.com/user-attachments/assets/58e5fa0f-a868-4e2b-8328-38f15cb0c185)

**🧱 Architecture**

The TMMU consists of two main layers:

* **Level 2 Controller (TMMU)**: Top-level unit handling data flow and instruction sequencing

* **Level 1 Controller (TPU)**: Manages fine-grained execution of matrix operations

![image](https://github.com/user-attachments/assets/46108636-a93c-4b4c-9cb8-ca449013b03d)

![image](https://github.com/user-attachments/assets/56e014fb-8429-4a72-a7ac-3dab64d19d4c)

![image](https://github.com/user-attachments/assets/b6ed5375-8939-4b79-8cd7-20ef9c347c19)

Key components include:

* Instruction decoders

* Host memory modules

* Activation normalization unit (with ReLU)

* Systolic data setup and MMU

![image](https://github.com/user-attachments/assets/9b9f8721-8d0a-4333-a87b-f9067cac618d)

**⚙️ Features**

* Supports matrix sizes from 1×1 to 8×8 via tiling

* Tiled matrix computation strategy improves memory locality and parallelism

* Cycle-accurate simulation using Verilog testbenches

![image](https://github.com/user-attachments/assets/3b1c3e91-69ad-41a5-860c-212ef8a19327)

![image](https://github.com/user-attachments/assets/8b55f9c6-56f2-498b-941f-46ced4e610aa)

![image](https://github.com/user-attachments/assets/1090c2b1-75ad-4bfa-bb3c-2b3a5627d070)

![image](https://github.com/user-attachments/assets/eb651e9f-3399-474b-8da8-22de953694c0)

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
