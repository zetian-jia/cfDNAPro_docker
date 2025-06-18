FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/opt/conda/envs/cfDNAenv/bin:/opt/conda/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates bzip2 libglib2.0-0 libxext6 libsm6 libxrender1 git less \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniforge (lightweight Conda)
RUN curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniforge3-Linux-x86_64.sh

# Update Conda and setup channels
RUN conda update -n base -c defaults conda && \
    conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict

# Create conda environment and install R and cfDNAPro
RUN conda create -n cfDNAenv -y \
    r-base=4.4 \
    bioconductor-cfdnapro=1.12.0 \
    r-ggpubr=0.6.0

# Activate environment by default
SHELL ["conda", "run", "-n", "cfDNAenv", "/bin/bash", "-c"]

RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate cfDNAenv" >> /root/.bashrc

# Verify install
RUN R -e "packageVersion('cfDNAPro')"

# Set default command
CMD ["conda", "run", "-n", "cfDNAenv", "R"]

