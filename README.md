# Asynchronous FIFO Design

## Overview

An Asynchronous FIFO is used to safely transfer data between two clock domains that are asynchronous to each other (different frequencies, no phase relationship).

This design uses:

- Gray code pointers for safe CDC (Clock Domain Crossing)
- 2 Flip-Flop synchronizers to pass pointers across clock domains
- N+1 bit pointers to distinguish between full and empty conditions 
- Dual port RAM for simultaneous read and write

  ## Architecture
