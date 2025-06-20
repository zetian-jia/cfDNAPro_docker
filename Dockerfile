# 基于 micromamba 的官方镜像
FROM mambaorg/micromamba:latest

# 设置环境变量
ENV PATH="/opt/conda/bin:${PATH}"

# 复制自定义 conda channels 配置
COPY .condarc /root/.condarc

# 安装基本依赖和R
RUN micromamba install -y -n base \
    -c conda-forge -c bioconda \
    r-base=4.3.3 r-devtools bioconductor-rtracklayer=1.62.0 r-s2=1.1.6 make gcc gxx gfortran pkg-config libcurl libxml2 openssl unzip zlib libpng libjpeg-turbo libtiff readline xorg-libx11 xorg-libxt tzdata libblas liblapack udunits2 cmake libxml2-devel-conda-x86_64  xz && \
    micromamba clean --all --yes

# 通过 micromamba run 执行R安装包命令
RUN micromamba run -n base R -e "install.packages(c('devtools', 'pacman'), repos='https://cloud.r-project.org')" 
RUN micromamba run -n base R -e "devtools::install_version('Matrix', version = '1.6-5', repos = 'https://cloud.r-project.org')"
RUN micromamba run -n base R -e "devtools::install_version('MASS', version = '7.3-58.3', repos = 'https://cloud.r-project.org')"
RUN micromamba run -n base R -e "devtools::install_version('units', version = '0.8-2', repos = 'https://cloud.r-project.org')"
RUN micromamba run -n base R -e "pacman::p_load(xml2, curl, httpuv, shiny, gh, gert, usethis, pkgdown, rcmdcheck, roxygen2, rversions, urlchecker, BiocManager)"
RUN micromamba run -n base R -e "options(timeout=3600); BiocManager::install(c('OrganismDbi', 'GenomicAlignments', 'GenomicFeatures', 'BSgenome', 'BSgenome.Hsapiens.UCSC.hg38', 'BSgenome.Hsapiens.UCSC.hg19', 'BSgenome.Hsapiens.NCBI.GRCh38', 'Homo.sapiens', 'plyranges', 'TxDb.Hsapiens.UCSC.hg19.knownGene'))"
RUN micromamba run -n base R -e "pacman::p_load(car, mgcv, pbkrtest, quantreg, lme4, ggplot2, ggrepel, ggsci, cowplot, ggsignif, rstatix, ggpubr, patchwork, ggpattern)"
RUN micromamba run -n base R -e "devtools::install_github('asntech/QDNAseq.hg38@main')"
RUN micromamba run -n base R -e "devtools::install_github('hw538/cfDNAPro', build_vignettes = FALSE, force = TRUE)"
RUN micromamba run -n base R -e "packageVersion('cfDNAPro')"

# 默认执行bash，方便调试
CMD ["/bin/bash"]

