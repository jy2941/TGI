# TGI — Dense Community Detection for Multi-Omics Integration

MATLAB implementation of the dense subgraph detection algorithm accompanying our academic paper.

## Overview

This repository provides greedy peeling algorithms for detecting dense communities from multi-modal omics data. The method operates on three correlation matrices simultaneously:
- **X** (m×m): symmetric correlation matrix for data type 1 (e.g., transcriptomics)
- **Y** (n×n): symmetric correlation matrix for data type 2 (e.g., metabolomics)
- **XY** (m×n): cross-association matrix between the two data types

Community size is controlled by a penalty parameter λ ∈ [1, 2]: higher values favor smaller, denser communities.

## Repository Structure

```
TGI/
├── methods/          # Core detection and sorting algorithms
└── visualization/    # Plotting functions for results
```

## Methods

### Greedy Peeling — Bipartite (X-Y)

| File | Description |
|------|-------------|
| `greedy_peeling_XY_all.m` | Iteratively extract all dense submatrices from an X-Y matrix |
| `greedy_peeling_XY_one.m` | Extract one dense submatrix from an X-Y matrix |

### Greedy Peeling — Symmetric (X-X)

| File | Description |
|------|-------------|
| `greedy_peeling_X_all.m` | Iteratively extract all dense subgraphs from a symmetric matrix |
| `greedy_peeling_X_one.m` | Extract one dense subgraph from a symmetric matrix |

### Sorting

| File | Description |
|------|-------------|
| `sort_result.m` | Reorder detected communities by internal density |
| `sort_result_XandY.m` | Reorder using separate X and Y correlation matrices |

## Visualization

| File | Description |
|------|-------------|
| `plot3in1_v1.m` | Three-panel plot of X, Y, XY matrices with detected communities (extra panels top/right) |
| `plot3in1_v2.m` | Three-panel plot, alternate layout (extra panels bottom/left) |
| `plot_all_result.m` | Plot all detected communities on the full or subsetted matrix |
| `nice_ticks.m` | Helper to generate clean axis tick marks |

## Usage

```matlab
% Add both folders to MATLAB path
addpath('methods/')
addpath('visualization/')

% Detect dense communities from an X-Y association matrix
% lambda controls community size penalty (typical range: 1.3–1.8)
result = greedy_peeling_XY_all(XY, lambda);

% Sort communities by internal correlation
result = sort_result(XY, result);

% Visualize
plot_all_result(XY, result, false, true, [-1, 1]);
plot3in1_v1(X, Y, XY, result, true);
```

```matlab
% Refine each X community further using symmetric peeling
for i = 1:size(result, 1)
    if ~isempty(result{i,1})
        idx = result{i,1};
        subX = X(idx, idx);
        subX = (subX + subX') / 2;
        sub_result = greedy_peeling_X_all(subX, lambda);
        result{i,1} = idx(cat(2, sub_result{:,1}));
    end
end
```

## Parameters

- **λ (lambda)**: penalty exponent in [1, 2]. Controls the trade-off between community size and density. Higher values enforce smaller, denser communities. Typical values: 1.4–1.6 for X-Y detection, 1.8–1.9 for X-X refinement.

## Requirements

- MATLAB (tested on R2023a and later)
- No additional toolboxes required
