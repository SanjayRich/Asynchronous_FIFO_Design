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
  ### WAVEFORM
  ![OUTPUT1](IMAGES/waveform_1.png)
  #
  ![OUTPUT2](IMAGES/waveform_2.png)
  #
  ![OUTPUT3](IMAGES/waveform_3.png)
  #
  ![OUTPUT4](IMAGES/waveform_4.png)
  
  
