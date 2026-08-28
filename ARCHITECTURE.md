# AGNI-X Architecture

## Top-Level Architecture

AGNI-X v2.0 is organized as a tiled AI accelerator architecture.

### Compute Array

- 16 compute tiles
- 4,096 MACs per tile
- 65,536 MACs total
- 8-bit fixed-point multiplication
- 16-bit accumulation
- Target core voltage: 0.55 V

### Tile Architecture

Each compute tile contains:

- MAC clusters
- 2 MB L1 SRAM
- Tile controller
- Local Network-on-Chip (NoC) router

### Memory Hierarchy

- L1: 2 MB per tile
- L2: 32 MB shared
- L3: 256 MB eDRAM on separate stacked dies
- HBM3e interface

### External Interfaces

- HBM3e PHY
- PCIe Gen6 x16

## Architecture Flow

Input Data
    ↓
HBM3e / Memory
    ↓
L2 Cache
    ↓
Compute Tiles
    ↓
MAC Clusters
    ↓
L1 SRAM
    ↓
Output

## Current Validation Status

This document describes the proposed architecture from the AGNI-X v2.0 design.

The architecture and numerical specifications are design specifications/projections unless independently reproduced or experimentally validated.
