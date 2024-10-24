# pipeline.R

# Source data loading and visualization scripts
source('scripts/data_loading.R')
source('scripts/visualizer.R')

# Define the main pipeline function
run_pipeline <- function() {
  cat("Starting pipeline...\n")
  
  # Step 1: Load the Kaggle dataset
  financial_data <- load_kaggle_data()
  
  # Step 2: Load the Hugging Face dataset
  ocr_data <- load_huggingface_data()
  
  # Step 3: Load an image file (hardcoded or parameterized in future)
  ocr_image <- load_image("data/ocr_image_sample.png")  # Dummy image, can be replaced
  
  # Step 4: Visualize data and image
  visualize_data_structure(financial_data, "Financial Dataset (Kaggle)")
  visualize_data_structure(ocr_data, "OCR Dataset (Hugging Face)")
  visualize_image(ocr_image, "Sample OCR Image")
  
  cat("\nPipeline completed successfully.\n")
}
