# FIFO Design and Verification using SystemVerilog

## Overview

This project implements a **Synchronous FIFO (First-In-First-Out) buffer** using **SystemVerilog** and verifies its functionality using a **class-based verification environment**.

A FIFO is a memory buffer where the **first data written into the buffer is the first data read out**, ensuring correct data ordering between producer and consumer modules.

The verification environment uses the following components:

* Transaction
* Generator
* Driver
* Monitor
* Scoreboard

The **scoreboard uses a SystemVerilog queue as a reference model** to verify FIFO ordering.

---

# FIFO Concept

FIFO follows the rule:

```
First In → First Out
```

Example:

```
Write sequence : 10 → 20 → 30
Read sequence  : 10 → 20 → 30
```

The first data written into the FIFO is the first data read.

---

# FIFO Architecture

```
           +-------------------+
 data_in → |                   |
           |       FIFO        | → data_out
 wr_en  →  |                   | → full
 rd_en  →  |                   | → empty
           +-------------------+
                  |       |
                  |       |
             Write Ptr  Read Ptr
                  |
                Memory
```

---


# Where FIFOs Are Used

FIFOs are widely used in digital systems to **buffer and synchronize data between modules**.

### Processor–Peripheral Communication

```
CPU → FIFO → UART
```

Prevents data loss when processor speed is higher than peripheral speed.

---

### Clock Domain Crossing (CDC)

FIFOs are used when data moves between different clock domains.

```
100 MHz domain → FIFO → 50 MHz domain
```

Asynchronous FIFOs are commonly used here.

---

### Network Routers

Routers use FIFOs to buffer packets before processing.

```
Network Input → FIFO → Packet Processor
```

---

### Video and Audio Streaming

```
Camera Sensor → FIFO → Image Processor
```

Helps maintain continuous data flow.

---

### DMA Controllers

DMA engines use FIFOs to buffer transfers between memory and peripherals.

---

# Verification Architecture

The verification environment follows a **class-based structure**.

```
        +-----------+
        | Generator |
        +-----------+
              |
              v
        +-----------+
        |  Driver   |
        +-----------+
              |
              v
        +-----------+
        |  FIFO DUT |
        +-----------+
              |
              v
        +-----------+
        |  Monitor  |
        +-----------+
              |
              v
        +-------------+
        | Scoreboard  |
        | (Queue Ref) |
        +-------------+
```

---

# Verification Components

### Transaction

Represents a FIFO operation containing:

* `wr_en`
* `rd_en`
* `data_in`
* `data_out`

---

### Generator

Creates transactions and sends them to the driver using a **mailbox**.

---

### Driver

Drives signals to the FIFO interface.

---

### Monitor

Observes DUT signals and sends them to the scoreboard.

---

### Scoreboard

Uses a **SystemVerilog queue as a reference model**.

```
queue.push_back(data) → write operation
queue.pop_front()     → read operation
```

This verifies correct FIFO ordering.

---

# Example Simulation Output

```
GEN WRITE data=45
SB PUSH 45

GEN WRITE data=23
SB PUSH 23

GEN READ
PASS exp=45 act=45

GEN READ
PASS exp=23 act=23
```

---

# Simulation

Simulation is performed using **EDA Playground**.

### EDA Playground Link

```
https://www.edaplayground.com/x/Anmd
```

---

# How to Run

1. Open the EDA Playground link
2. Select **SystemVerilog**
3. Choose simulator (Riviera / Questa / Icarus)
4. Click **Run**
5. Enable **EPWave** to view waveforms

---

# Waveform Signals

Useful signals to observe in EPWave:


```
clk
wr_en
rd_en
data_in
data_out
full
empty
```

---

# Key Features

* SystemVerilog **class-based verification**
* FIFO **reference model using queue**
* Modular verification architecture
* Random data generation
* Waveform visualization with EPWave

---

# Future Improvements

Possible enhancements:

* Constrained random verification
* Functional coverage
* Assertions for FIFO properties
* Full **UVM-based verification environment**

---

# Author
Anusha Sanapathi

---

1️⃣ **Badges (SystemVerilog / Verification / VLSI)**
2️⃣ **A waveform screenshot section**

These make recruiters notice your project immediately.
