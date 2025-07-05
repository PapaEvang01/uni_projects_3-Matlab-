# MATLAB Projects – University Coursework Portfolio

Throughout my university studies, I had the opportunity to work on several MATLAB projects across different courses.  
This repository showcases selected assignments from:

- 🧠 Computer Intelligence  
- 🕹️ Controllers  
- 🖼️ Digital Image Processing  

Each folder represents a standalone project or homework assignment, complete with code, results, and documentation.

---

## 1. Computer Intelligence – MATLAB Projects
Projects developed during the **Computer Intelligence** course. Each assignment focuses on intelligent algorithms such as Genetic Algorithms (GA) and Neural Networks (NN).

### 📘 HW1 – Genetic Algorithm Applications
Three optimization problems solved using MATLAB’s `ga()` and custom fitness functions:

- `ga_kna.m`: Solves a 0/1 knapsack problem  
- `cards_using_ga.m`: Partitions 15 cards into 3 sets under constraints  
- `solve_cubic_ga.m`: Finds a real root of a cubic equation with 3-digit precision

### 📘 HW2 – Traveling Salesman Problem (TSP) via GA
Implements a custom GA with permutation encoding to solve TSP.  
Includes custom crossover, mutation, fitness, and plotting:

- `tsp_main.m`, `tsp_fitness.m`, `tsp_mutate_permutation.m`, etc.

### 📘 HW3 – Neural Network Applications
Two feedforward NN tasks:

- `function_approx_nn.m`: Approximates a 2D mathematical function  
- `parity_classifier_nn.m`: Classifies binary sequences for even/odd parity

---

## 2. Controllers – MATLAB Projects
Completed as part of the **Controllers** course. These projects involve designing feedback controllers for second-order systems.

### 📘 HW1 – SPSA-Based PID Controller Optimization
Designs and tunes a PID controller using the **Simultaneous Perturbation Stochastic Approximation (SPSA)** algorithm.

- `spsa_optimize_pid.m`: Main script
- `simulate_pid_response.m`: System simulation
- `spsa.m`: SPSA algorithm
- `pid_results.txt`: Saved gains and final cost

📌 Output:
- Optimized PID gains
- Step response plot
- Log file of results

### 📘 HW2 – LQR Controller Design
Uses **Linear Quadratic Regulation (LQR)** to design an optimal state-feedback controller.

- `lqr_controller_design.m`: Main script
- `simulate_lqr_response.m`: Closed-loop simulation
- `save_lqr_results.m`: Logs results
- `lqr_results.txt`: Gain matrix K and final state

📌 Key Learning Contrast:
- HW1 uses SPSA (model-free tuning)
- HW2 uses full state-space model and optimal control theory

---

## 3. Digital Image Processing – MATLAB Projects
Projects developed during the **Digital Image Processing** course, focused on wavelet-based fusion and image segmentation.

### 📘 HW1 – Image Fusion (YCbCr & HSV)
Fuses three images of the same scene taken at different times using wavelet decomposition.

- YCbCr Method: Fusion on Cr channel using max rules  
- HSV Method: Fusion on S channel  
- Uses custom and textbook-inspired logic

### 📘 HW2 – Progressive Fusion using `wfusimg`
Fuses four images progressively using MATLAB’s built-in `wfusimg`.

- Includes both YCbCr and HSV methods  
- Wavelet: `db6`, max-max fusion strategy

### 📘 HW3 – Otsu Thresholding: Custom vs Built-in
Applies and compares two implementations of Otsu’s thresholding:

- Part 1: Custom implementation (manual thresholding)  
- Part 2: MATLAB built-in (`graythresh`, `imbinarize`)  
- Part 3: Comparison using MSE, SSIM, and histograms

📌 Skills Gained:
- Color space conversion (RGB ↔ YCbCr / HSV)
- Wavelet fusion (manual + automatic)
- Image segmentation metrics and visualization

---

## 📦 Summary of Tools & Concepts Used

| Domain | Topics Covered |
|--------|----------------|
| Optimization | SPSA, GA, cost functions, fitness penalties |
| Control Systems | PID control, LQR design, state-space modeling |
| Simulation | `ode45`, closed-loop dynamics, logging |
| Neural Networks | Function approximation, binary classification |
| Image Processing | Wavelets, thresholding, segmentation evaluation |

---

📁 All projects are modular, commented, and include relevant `.txt` logs and visual outputs.  
Feel free to explore individual folders for more details!
