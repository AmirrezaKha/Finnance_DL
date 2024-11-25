library(magick)  # For image loading

# Function to load the Kaggle financial news dataset using kagglehub
load_kaggle_financial_news <- function(save_dir = "data") {
    # Import the reticulate library to interface with Python
    library(reticulate)
    
    # Ensure the save directory exists
    if (!dir.exists(save_dir)) {
        dir.create(save_dir, recursive = TRUE)
    }
    
    # Import kagglehub Python module using reticulate
    kagglehub <- import("kagglehub")
    
    # Download the dataset
    cat("Downloading dataset from Kaggle...\n")
    dataset_path <- kagglehub$dataset_download("clovisdalmolinvieira/news-sentiment-analysis")
    
    # Define the target path to save the dataset
    csv_files <- list.files(dataset_path, pattern = "\\.csv$", full.names = TRUE)
    if (length(csv_files) == 0) {
        stop("No CSV files found in the downloaded dataset.")
    }
    
    # Move the CSV file to the save directory
    saved_paths <- sapply(csv_files, function(file) {
        target_path <- file.path(save_dir, basename(file))
        file.copy(file, target_path, overwrite = TRUE)
        target_path
    })
    
    # Print and return the paths to the saved CSV files
    cat("Dataset files saved to:\n", paste(saved_paths, collapse = "\n"), "\n")
    return(saved_paths)
}
