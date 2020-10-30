FROM rocker/tidyverse@sha256:e60ef005f0c79b368c447a4ad28e67a71d96d980e3527adeeb87d5656ad97a11
#FROM nfcore/base:1.10.2

LABEL authors="Salvador Romero" \
      description="Docker image containing all software requirements for the gwas tools"


# Install the conda environment
#COPY environment.yml /


# Add conda installation dir to PATH (instead of doing 'conda activate')
#ENV PATH /opt/conda/envs/gwas/bin:$PATH

#RUN R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org')"
RUN R -e "library(devtools)"
RUN R -e "devtools::install_github('dongjunchung/GGPA')"
RUN R -e "install.packages('BiocManager')"
RUN R -e "BiocManager::install('GWASTools')"
RUN R -e "BiocManager::install('remotes', dependencies=T)"
RUN R -e "install.packages('BiocInstaller')"
RUN apt-get update
RUN sudo yes | apt-get install libboost-all-dev
RUN sudo yes | apt-get install libbz2-dev
RUN sudo apt-get install -y liblzma-dev

RUN apt-get update && apt-get -y install tcl8.6-dev tk8.6-dev
RUN R -e "devtools::install_github('cran/PredictABEL')"
RUN R -e "devtools::install_github('tshmak/lassosum')"


RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        graphviz \
        wget \
        build-essential \
        libopenblas-dev \
        libgsl0-dev \
        procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN R -e "install.packages('network')"
RUN R -e "install.packages('sna')"
RUN R -e "install.packages('scales')"
RUN R -e "BiocManager::install('GWASdata')"
RUN R -e "install.packages('R.utils')"




# Instruct R processes to use these empty files instead of clashing with a local version
RUN touch .Rprofile
RUN touch .Renviron