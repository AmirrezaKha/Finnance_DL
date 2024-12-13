# Source data loading and visualization scripts
source('scripts/data_loading.R')
source('scripts/visualizer.R')
source('scripts/feature_engineering.R')

# Define the main pipeline function
run_pipeline <- function() {
    cat("Starting pipeline...\n")

    # Load the new Kaggle financial news dataset
    news_data <- load_kaggle_financial_news()

    text_file_path <- "data/news_sentiment_analysis.csv"

    glove_path <- load_and_save_other_datasets("watts2/glove6b50dtxt")

    visualize_datasets(text_file_path)

    df <- feature_engineering(text_file_path, glove_path)

    cat("\nTop rows of the processed dataset:\n")
    print(head(df))

    cat("\nPipeline completed successfully.\n")
    
}


# Run the pipeline
run_pipeline()
