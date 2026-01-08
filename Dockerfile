# Use an official R image
FROM rocker/r-ver:4.2.2

# Install system dependencies for R packages and Python pip
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmagick++-dev \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Kaggle API and kagglehub using pip
RUN pip install kaggle kagglehub

# Set the working directory
WORKDIR /usr/src/app

# Install R packages including reticulate, remotes, magick, ggplot2, gridExtra, dplyr, readr
RUN R -e "install.packages(c('reticulate', 'remotes', 'magick', 'ggplot2', 'gridExtra', 'dplyr', 'readr', 'text2vec', 'tidyverse', 'text', 'data.table', 'tidytext'))"

# Copy the R scripts and other necessary files
COPY ./main.R ./main.R
COPY ./scripts ./scripts
COPY ./.env ./.env

# Ensure that the 'data' directory exists
RUN mkdir -p /usr/src/app/data

# Run the main script
CMD ["Rscript", "main.R"]
