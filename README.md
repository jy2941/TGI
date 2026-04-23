# TGI — Tensor-Guided Integration for Dense Community Detection

MATLAB implementation of the dense community detection algorithm accompanying our academic paper.

## Overview

This repository provides greedy peeling algorithms for detecting dense subgraphs/communities from multi-modal data represented as:
- **X** (m×m): symmetric covariance/correlation matrix for data type 1
- **Y** (n×n): symmetric covariance/correlation matrix for data type 2
- **XY** (m×n): cross-association matrix between data types

The generalized density objective is controlled by penalty parameters λ₁, λ₂, λ₃ ∈ [1, 2], allowing flexible control over detected community size.

## Files

### Core Detection (3-Matrix)
| File | Description |
|------|-------------|
| `detect_one.m` | Detect one community jointly from X, Y, XY |
| `detect_all.m` | Iteratively detect all communities from X, Y, XY |
| `greedy_3step.m` | 3-step greedy algorithm on combined p-value and correlation matrices |

### Greedy Peeling (X-Y bipartite)
| File | Description |
|------|-------------|
| `greedy_peeling_XY_one.m` | Find one dense submatrix from a bipartite X-Y matrix |
| `greedy_peeling_XY_all.m` | Find all dense submatrices from a bipartite X-Y matrix |

### Greedy Peeling (X-X symmetric)
| File | Description |
|------|-------------|
| `greedy_peeling_X_one.m` | Find one dense subgraph from a symmetric matrix |
| `greedy_peeling_X_all.m` | Find all dense subgraphs from a symmetric matrix |

### Visualization
| File | Description |
|------|-------------|
| `plot3in1_v2.m` | Main visualization: plots X, Y, XY with detected communities |
| `plot3in1_v1.m` | Alternate layout version |
| `plot_all_result.m` | Plot all detected regions from greedy peeling |

### Utilities
| File | Description |
|------|-------------|
| `sort_result.m` | Sort detected communities by internal density |
| `sort_result_XandY.m` | Sort using X and Y covariance matrices |
| `remove_duplicate.m` | Remove duplicate columns from a matrix |
| `checkIntersectionAndSubsetMultiple.m` | Set intersection/subset check |
| `nice_ticks.m` | Generate clean axis ticks for plots |

## Usage

```matlab
% Detect all communities from X, Y, XY matrices
% lambda1, lambda2, lambda3 control penalty for X, Y, XY size respectively
result = detect_all(X, Y, XY, lambda1, lambda2, lambda3);

% Visualize
plot3in1_v2(X, Y, XY, result, true, true);
```

```matlab
% Simpler: detect from X-Y matrix only
result = greedy_peeling_XY_all(XY, lambda);
```

## Parameters

- **λ (lambda)**: penalty exponent in [1, 2]. Higher values favor smaller, denser communities. Default: 1.5.
- **X_size / Y_size**: `[min, max]` bounds on community size.

## Requirements

- MATLAB (tested on R2023a and later)
- No additional toolboxes required
