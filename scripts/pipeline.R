# Source data loading and visualization scripts
source('scripts/data_loading.R')
source('scripts/visualizer.R')

# Define the main pipeline function
run_pipeline <- function() {
    cat("Starting pipeline...\n")

    # Step 1: Load the Kaggle financial document dataset
    financial_data <- load_kaggle_data()

    # Step 2: Load the new Kaggle financial news dataset
    news_data <- load_huggingface_data()

    # Step 3: Define the image directory and CSV file path
    image_directory <- "data/"  # Directory where image folders are located
    text_file_path <- "data/dataset.csv"  # Path to the CSV file for text data

    # Step 4: Visualize text and image datasets
    visualize_datasets(image_directory, text_file_path)  # This will call the appropriate functions for visualization

    cat("\nPipeline completed successfully.\n")
}

# Run the pipeline
run_pipeline()
