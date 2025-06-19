FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/opt/conda/envs/cfdnapro/bin:/opt/conda/bin:$PATH

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates bzip2 libglib2.0-0 libxext6 libsm6 libxrender1 \
    git less libssl-dev libxml2-dev libfontconfig1-dev libfreetype6-dev \
    libharfbuzz-dev libfribidi-dev libpng-dev libtiff5-dev libjpeg-dev \
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
RUN conda create -n cfdnapro -c conda-forge -y \
    r-base=4.3.3 r-xml2 r-curl libgdal r-libgeos udunits2 r-devtools

# Activate environment by default
SHELL ["conda", "run", "-n", "cfdnapro", "/bin/bash", "-c"]

RUN echo "source /opt/conda/etc/profile.d/conda.sh && conda activate cfdnapro" >> /root/.bashrc
SHELL ["conda", "run", "-n", "cfdnapro", "/bin/bash", "-c"]

RUN R -e "if (!requireNamespace('devtools', quietly = TRUE)) install.packages('devtools', repos = 'https://cloud.r-project.org')"

RUN R -e "devtools::install_version('Matrix', version = '1.6-5', repos = 'https://cloud.r-project.org')"
RUN R -e "devtools::install_version('MASS', version = '7.3-58.3', repos = 'https://cloud.r-project.org')"
RUN R -e "devtools::install_version('units', version = '0.8-2', repos = 'https://cloud.r-project.org')"
RUN R -e "if (!requireNamespace('pacman', quietly = TRUE)) install.packages('pacman', repos = 'https://cloud.r-project.org'); pacman::p_load(xml2, curl, httpuv, shiny, gh, gert, usethis, pkgdown, rcmdcheck, roxygen2, rversions, urlchecker, BiocManager)"

RUN R -e "options(timeout=3600); if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager'); BiocManager::install('OrganismDbi')"

RUN R -e "options(timeout=3600); pkgs <- c('GenomicAlignments', 'rtracklayer', 'GenomicFeatures', 'BSgenome', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.NCBI.GRCh38', 'Homo.sapiens', 'plyranges', 'TxDb.Hsapiens.UCSC.hg19.knownGene'); new <- pkgs[!pkgs %in% installed.packages()[,'Package']]; if(length(new)) BiocManager::install(new)"

RUN R -e "pacman::p_load(car, mgcv, pbkrtest, quantreg, lme4, ggplot2, ggrepel, ggsci, cowplot, ggsignif, rstatix, ggpubr, patchwork, ggpattern)"

RUN R -e "devtools::install_github('asntech/QDNAseq.hg38@main')"
RUN R -e "devtools::install_github('hw538/cfDNAPro', build_vignettes = FALSE, force = TRUE)"

RUN R -e "packageVersion('cfDNAPro')"

# Set default command
CMD ["conda", "run", "-n", "cfdnapro", "R"]

