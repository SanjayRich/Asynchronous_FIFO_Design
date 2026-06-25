# Asynchronous FIFO Design

## Overview

An Asynchronous FIFO is used to safely transfer data between two clock domains that are asynchronous to each other (different frequencies, no phase relationship).

This design uses:

- Gray code pointers for safe CDC (Clock Domain Crossing)
- 2 Flip-Flop synchronizers to pass pointers across clock domains
- N+1 bit pointers to distinguish between full and empty conditions 
- Dual port RAM for simultaneous read and write

  ## Architecture
  ![Async FIFO Architecture](IMAGES/Architecture.png)

  ## OUTPUT
  ![OUTPUT](IMAGES/Output.png)
  
  ## WAVEFORM
  - When Reset is Asserted, Empty goes high and Full flag goes low.
  
  ![OUTPUT1](IMAGES/waveform_1.png)

  #
  - empty flag goes high once all data is read from the fifo memory
  ![OUTPUT2](IMAGES/waveform_2.png)
  #
  - Full flag goes high when data is loaded into all locations, and after full condition reaches even if we try to load data it is not getting loaded.
  ![OUTPUT3](IMAGES/waveform_3.png)
  #
  - Read flag goes high once data is read from all location.
  ![OUTPUT4](IMAGES/waveform_4.png)
  
  
