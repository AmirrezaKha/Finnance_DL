# Source data loading and visualization scripts
source('scripts/data_loading.R')
source('scripts/visualizer.R')

# Define the main pipeline function
run_pipeline <- function() {
    cat("Starting pipeline...\n")


    # Load the new Kaggle financial news dataset
    news_data <- load_kaggle_financial_news()

    text_file_path <- "data/news_sentiment_analysis.csv"

    visualize_datasets(text_file_path)

    cat("\nPipeline completed successfully.\n")
}

# Run the pipeline
run_pipeline()
