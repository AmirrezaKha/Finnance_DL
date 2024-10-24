# data_loading.R

library(readr)
library(magick)

# Function to load CSV data
load_csv_data <- function(file_path) {
  data <- read_csv(file_path)
  return(data)
}

# Function to load image data
load_image <- function(image_path) {
  image <- image_read(image_path)
  return(image)
}

# Example Usage (can be called in the pipeline):
# financial_data <- load_csv_data('data/financial_dataset.csv')
# ocr_data <- load_csv_data('data/ocr_dataset.csv')
# ocr_image <- load_image('images/ocr_image_1.png')
