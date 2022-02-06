FROM ubuntu:20.04

# Set versions and platforms
ARG R_VERSION=4.1.1
ARG OS_IDENTIFIER=ubuntu-2004
ARG RSTUDIO_VERSION=2021.09.1-372
#ARG RSTUDIO_VERSION=2021.09.2-382

# Install system dependencies -------------------------------------------------#
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    curl \
    fontconfig \
    libcurl4-openssl-dev \
    locales \
    perl \
    sudo \
    tzdata \
    wget \
    git \
    # Rstudio server
    gdebi-core \
    # Tidyverse
    libicu-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    pandoc \
    libxml2-dev \
    # Rpostgres
    libpq-dev \
    # mongolite
    libssl-dev \
    libsasl2-dev \
    # etc
    libsodium-dev && \
    rm -rf /var/lib/apt/lists/*
    

# Install R -------------------------------------------------------------------#
RUN wget https://cdn.rstudio.com/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_amd64.deb && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ./r-${R_VERSION}_1_amd64.deb && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm r-${R_VERSION}_1_amd64.deb && \
    rm -rf /var/lib/apt/lists/*
    
ENV R_HOME=/opt/R/${R_VERSION}/lib/R


# Set RStudio binary repo globaly ---------------------------------------------#
RUN echo 'options(repos = c(REPO_NAME = "https://packagemanager.rstudio.com/all/__linux__/focal/latest"))' > ${R_HOME}/etc/Rprofile.site
ENV RENV_CONFIG_REPOS_OVERRIDE=https://packagemanager.rstudio.com/all/__linux__/focal/latest


# Locale configuration --------------------------------------------------------#
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV TZ=UTC


# Rstudio Server Installation -------------------------------------------------#
ARG FILE=rstudio-server-${RSTUDIO_VERSION}-amd64.deb
RUN wget -nv https://download2.rstudio.org/server/bionic/amd64/${FILE}
RUN apt-get update -qq && gdebi --non-interactive ${FILE} #TODO: delete apt lists
RUN rm ${FILE}

RUN echo "auth-none=1" >> /etc/rstudio/rserver.conf
RUN echo "server-daemonize=0" >> /etc/rstudio/rserver.conf

RUN useradd rstudio
RUN echo "rstudio:rstudio" | chpasswd
RUN mkdir /home/rstudio
RUN chown rstudio:rstudio /home/rstudio
ENV USER=rstudio


# R Packages Installation -----------------------------------------------------#
RUN R -e 'install.packages(c("tidyverse","markdown","styler","miniUI","renv"))'
RUN R -e 'tinytex::install_tinytex(dir = "/opt/tinytex")'
ENV PATH=/opt/tinytex/bin/x86_64-linux:$PATH


RUN echo "PATH=${PATH}" >> ${R_HOME}/etc/Renviron.site

CMD ["rstudio-server", "start"]