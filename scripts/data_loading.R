# data_loading.R

library(kagglehub)       # For downloading from Kaggle
library(huggingfaceR)    # For loading datasets from Hugging Face
library(magick)          # For image loading

# Function to load the Kaggle financial document image dataset
load_kaggle_data <- function() {
  if (!dir.exists("data")) {
    dir.create("data")
  }
  
  # Download the Kaggle dataset to the 'data/' folder
  kaggle_path <- kagglehub::dataset_download("mehaksingal/personal-financial-dataset-for-india", path = "data/")
  cat("Downloaded Kaggle dataset to:", kaggle_path, "\n")
  
  # Load image files from the downloaded directory
  # This assumes all images are stored in a specific folder within the downloaded path
  image_files <- list.files(kaggle_path, pattern = "\\.(png|jpg|jpeg)$", full.names = TRUE)
  
  # Load all images using magick
  images <- lapply(image_files, image_read)
  
  return(images)
}

# Function to load the Hugging Face financial phrase bank dataset
load_huggingface_data <- function() {
  # Load and cache the Hugging Face dataset to 'data/financial_phrasebank'
  dataset <- hf_load_dataset("takala/financial_phrasebank", cache_dir = "data/financial_phrasebank")
  cat("Loaded Hugging Face dataset and cached it.\n")
  return(dataset$train)
}

# Function to load image files from a given path
load_image <- function(image_path) {
  image <- image_read(image_path)
  return(image)
}
