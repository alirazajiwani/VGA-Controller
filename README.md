# VGA-Controller
This project implements a simulation-based VGA controller that follows the XGA video standard (1024x768 @ 60Hz). The entire system is written in Verilog/SystemVerilog and tested using ModelSim. It provides a simplified yet functional VGA pipeline intended for educational use, pixel-based visual testing, and image display simulation.

## Module Overview

### 1. vga_timing
This module generates the horizontal and vertical synchronization signals (HSYNC and VSYNC) as per XGA specifications:
Handles all timing phases: front porch, sync pulse, back porch, and visible area.
Maintains pixel counters (h_count, v_count) for coordinate tracking.
Outputs a signal indicating the active display region.

<img width="940" height="160" alt="Timing_signal(1)" src="https://github.com/user-attachments/assets/5df862e4-42de-4e96-a1e0-586e1d09b475" />


### 2. mem_interfacing
Responsible for managing a simulated frame buffer (2D memory array) that stores pixel RGB data.
Input image: a JPG file is converted into hex values using a Python script.
The memory stores RGB values, accessed based on current pixel coordinates from vga_timing.
Image is reconstructed on-screen via RGB output.

### 3. top_module
The top-level integration module that combines:
VGA timing signals
Memory read access
Final RGB output and sync signals (vga_red, vga_green, vga_blue, vga_hsync, vga_vsync, video_enable)

## Simulation
Testbench: Provided to verify functionality and visualize pixel output over time.
Simulation shows VGA timing and correct pixel regeneration based on stored JPG image data.

#### Source Image:
![SourceImage](https://github.com/user-attachments/assets/01b7f0ce-cc65-4a03-836a-53499b0f35a2)

#### Reconstruced Image:
![ReconstructedImage](https://github.com/user-attachments/assets/f5381ac8-3473-4dd6-970a-810f506efda4)


## Image Pipeline
A JPG image is converted into hex using a Python script.
The hex values are stored in memory and accessed pixel-by-pixel during simulation.
No artificial patterns—just pure reconstruction of the original image from memory.

#### Workflow
<img width="942" height="442" alt="image" src="https://github.com/user-attachments/assets/468646c7-cbf5-49b9-8802-053682e50902" />

