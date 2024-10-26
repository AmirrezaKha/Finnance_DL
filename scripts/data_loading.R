library(magick)  # For image loading

# Function to load the Kaggle financial document image dataset using the Python 'kaggle' API
load_kaggle_data <- function() {
    if (!dir.exists("data")) {
        dir.create("data")
    }

    # Use system call to download the Kaggle dataset using Python API
    system('kaggle datasets download -d mehaksingal/personal-financial-dataset-for-india -p data/ --unzip')
    cat("Downloaded Kaggle dataset to 'data/' directory\n")

    # Load image files from the 'data/' folder
    image_files <- list.files("data", pattern = "\\.(png|jpg|jpeg)$", full.names = TRUE)

    # Load all images using magick
    images <- lapply(image_files, image_read)

    return(images)
}

# Function to load the new Kaggle financial news dataset
load_huggingface_data <- function() {
    # Assuming that you are downloading this via the same Kaggle API
    # Replace with the correct command if using Hugging Face API in the future
    system('kaggle datasets download -d sayelabualigah/high-quality-financial-news-dataset-for-nlp-tasks -p data/ --unzip')
    cat("Downloaded Kaggle financial news dataset to 'data/' directory\n")
}

# Function to load image files from a given path
load_image <- function(image_path) {
    image <- image_read(image_path)
    return(image)
}
