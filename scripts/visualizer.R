# visualizer.R

library(ggplot2)
library(magick)

# Visualize the structure and basic information of the dataset
visualize_data_structure <- function(data, dataset_name) {
  cat("\n", dataset_name, "Structure:\n")
  str(data)
  cat("\nNumber of Rows in", dataset_name, ":", nrow(data))
  cat("\nNumber of Columns (Features) in", dataset_name, ":", ncol(data))
  cat("\n\nPreview of", dataset_name, ":\n")
  print(head(data))
}

# Function to visualize an image
visualize_image <- function(image, image_name) {
  cat("\nDisplaying image:", image_name, "\n")
  image_info(image)
  
  # Display the original image
  print(image)
  
  # Convert to grayscale and display
  gray_image <- image_convert(image, colorspace = 'gray')
  print(gray_image)
}

# Example Usage (these will be called in the pipeline):
# visualize_data_structure(financial_data, "Financial Document Dataset")
# visualize_image(ocr_image, "OCR Image 1")
