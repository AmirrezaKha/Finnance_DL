# main.R

source('scripts/pipeline.R')

# Run the pipeline with the paths to the datasets and the image file
run_pipeline(
  financial_data_file = 'data/financial_dataset.csv', 
  ocr_data_file = 'data/ocr_dataset.csv', 
  ocr_image_file = 'images/ocr_image_1.png'
)
