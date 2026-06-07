# Design and Implementation of a Modulo Unit for the Posit Number System

## Overview
This repository contains the RTL design and implementation of a sequential modulo (MOD) arithmetic unit tailored for the Posit number system.

The project was developed during a research training program at the CSIR-Central Electronics Engineering Research Institute (CEERI), Pilani.

The primary objective of this project is to explore advanced number systems that offer improved dynamic range and accuracy compared to the conventional IEEE-754 floating-point standard. By translating complex mathematical algorithms into hardware-oriented finite state machine (FSM) architectures, this work establishes a foundation for efficient modular arithmetic, which is particularly relevant in the context of Post-Quantum Cryptography (PQC) standards like FIPS 203.

## Project Architecture & Modules

All designs were developed at the Register Transfer Level (RTL) using Verilog HDL, emphasizing sequential, FSM-based control.

### 1. Foundational Arithmetic Blocks

#### Sequential Adder
An FSM-based adder designed to perform step-by-step addition. The design was experimentally verified on a Boolean Algebra Board to observe sequential operations under real hardware constraints.

#### Wallace Tree Multiplier
Designed to minimize sequential addition stages by reducing partial products in parallel using a tree of carry-save adders, thereby improving computational speed.

### 2. Sequential Posit Modulo Unit

The core of this project is the modulo unit, which utilizes a shift-and-subtract algorithm controlled by an FSM. It is divided into three main operational stages:

#### A. Field Extraction (`data_extract`)
Before arithmetic operations occur, the Posit bitstream is decoded.

- **Regime Detection:** Utilizes a Hierarchical Leading One Detector (LOD) operating in stages (LOD8 → LOD16 → LOD32 → LOD64) to determine regime length.
- **Field Parsing:** A Barrel Shifter left-shifts the Posit word to align and correctly extract the Exponent and Mantissa fields.

#### B. Core Modulus Logic (`mod_fsm`)
The modulus operation utilizes a Restoring Division algorithm managed by an FSM.

- **Initial Comparison:** If operand A is smaller than operand B, the FSM bypasses computation and outputs A.
- **Iterative Subtraction:** The FSM repeatedly subtracts the divisor from the remainder and left-shifts, running for cycles equal to the exponent difference.
- **Normalization:** The remainder is shifted to reach the standard mantissa format, adjusting the exponent accordingly.

#### C. Reconstruction (`posit_mod`)
The normalized result is converted back into a valid Posit format.

- **Descaling:** Decomposes the mantissa and scale into the Posit-specific Regime (`k`) and Exponent (`e`) values.
- **Bit Packing:** Concatenates the fields (`Sign | Regime | Exponent | Mantissa`) to form the final bitstream.
- **Sign Handling:** Applies two's complement if the original operand was negative to preserve the correct sign.

## Technologies & Skills

- **Hardware Description Language:** Verilog HDL
- **Design Methodology:** RTL Coding, Parameterized Design, FSM Architecture, Datapath Separation
- **Key Concepts:** Posit Arithmetic, Variable-Length Field Hardware Parsing, Restoring Division, Run-Length Encoding

## Acknowledgments

This work was conducted at CSIR-CEERI, Pilani, under the mentorship of **Dr. Jai Gopal Pandey**, Senior Principal Scientist, Societal Electronics Group (SEG).
