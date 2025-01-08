# Local Binary Patterns (LBP) Algorithm Digital Circuit Design

## Overview

This project implements the Local Binary Patterns (LBP) algorithm using Verilog and deploys it on the Xilinx Zynq-7000 platform. LBP is an image processing technique for extracting local texture features efficiently in hardware.

## Features

- **LBP Algorithm**: Processes each pixel in a grayscale image based on its 3x3 neighborhood.
- **Hardware Implementation**: Developed in Verilog, tested with NC-Verilog, and deployed using Vivado.
- **Visualization**: Displays results via VGA on FPGA.

## System Architecture

- **Input**: Grayscale images stored in memory (`gray_mem`).
- **Processing**: Computes LBP for each pixel and stores results in `lbp_mem`.
- **Output**: Processed image shown on VGA display.

### LBP Computation

1. Compare each neighbor's value with the central pixel.
2. Assign binary values (1 or 0) based on the comparison.
3. Calculate the LBP value by summing binary weights.

## Tools

- **Development and Hardware**: Verilog HDL, NC-Verilog, Vivado 2018.3, Python, Xilinx Zynq-7000 ZedBoard (7z020).

## Results

- **Input Image**: Original color images are preprocessed using Python to convert them to grayscale before loading into the memory module (`gray_mem`) on FPGA.
- **Output Image**: Grayscale images are processed using the LBP algorithm implemented in Verilog, and the results are displayed via VGA, highlighting texture features. This output provides a visual verification of the implemented hardware functionality.
