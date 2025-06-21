# cfDNAPro Dockerized Version <img src="figures/cfdnaprologo.png" width="150" align="right">

This repository provides a **Dockerized version of [cfDNAPro](https://github.com/hw538/cfDNAPro)**, designed to address the challenge of complex dependencies and installation difficulties in the original project. It enables users to quickly deploy a ready-to-use environment for cfDNA fragmentomics analysis.

---

## About the Original Repository

cfDNAPro is a Bioconductor R package developed for standardized and robust analysis of cell-free DNA (cfDNA) fragmentomic features.

Original repository:  
https://github.com/hw538/cfDNAPro

Official documentation:  
https://cfdnapro.readthedocs.io/en/latest/

---

## Why Use This Docker Image?

The original cfDNAPro requires a large number of R and Bioconductor dependencies, which are often difficult to install. This image provides:

- Pre-installed cfDNAPro version 1.12.0
- Pre-configured R 4.4.3 environment with all dependencies resolved


---

## Quick Start (Recommended)

### Step 1: Pull the Docker Image

```bash
docker pull zetianjia/cfdnapro:1.7.3
```

### Step 2: Launch R inside the Container

```bash
docker run -it zetianjia/cfdnapro:1.7.3 R --no-save
```

## Citation

Please cite this paper:

Wang, H., Mennea, P.D., Chan, Y.K.E. et al. A standardized framework for robust fragmentomic feature extraction from cell-free DNA sequencing data. Genome Biol 26, 141 (2025). https://doi.org/10.1186/s13059-025-03607-5

