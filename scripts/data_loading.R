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

# Function to load the Kaggle financial news dataset using kagglehub
load_kaggle_financial_news <- function() {
    # Import the kagglehub library in your script using reticulate
    library(reticulate)
    
    # Import kagglehub from Python
    kagglehub <- import("kagglehub")
    
    # Use the kagglehub function to download the dataset
    path <- kagglehub$dataset_download("ankurzing/sentiment-analysis-for-financial-news")
    
    # Print the path to where the dataset is downloaded
    cat("Path to dataset files:", path, "\n")
}


# Function to load image files from a given path
load_image <- function(image_path) {
    image <- image_read(image_path)
    return(image)
}
