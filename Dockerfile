FROM rocker/r-base:4.3.3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2-dev libssl-dev libcurl4-openssl-dev git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装必要的 R 包
RUN R -e "install.packages(c('devtools', 'pacman'), repos='https://cloud.r-project.org')"

RUN R -e "devtools::install_version('Matrix', version = '1.6-5', repos = 'https://cloud.r-project.org')"
RUN R -e "devtools::install_version('MASS', version = '7.3-58.3', repos = 'https://cloud.r-project.org')"
RUN R -e "devtools::install_version('units', version = '0.8-2', repos = 'https://cloud.r-project.org')"

RUN R -e "pacman::p_load(xml2, curl, httpuv, shiny, gh, gert, usethis, pkgdown, rcmdcheck, roxygen2, rversions, urlchecker, BiocManager)"

RUN R -e "options(timeout=3600); BiocManager::install(c('OrganismDbi', 'GenomicAlignments', 'rtracklayer', 'GenomicFeatures', 'BSgenome', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.NCBI.GRCh38', 'Homo.sapiens', 'plyranges', 'TxDb.Hsapiens.UCSC.hg19.knownGene'))"

RUN R -e "pacman::p_load(car, mgcv, pbkrtest, quantreg, lme4, ggplot2, ggrepel, ggsci, cowplot, ggsignif, rstatix, ggpubr, patchwork, ggpattern)"

RUN R -e "devtools::install_github('asntech/QDNAseq.hg38@main')"
RUN R -e "devtools::install_github('hw538/cfDNAPro', build_vignettes = FALSE, force = TRUE)"

CMD ["R"]
