# visualizer.R

library(ggplot2)     # For data visualization
library(magick)      # For image manipulation

# Function to visualize the structure of text data
visualize_text_data_structure <- function(data, title) {
  cat("\nVisualizing text data structure for:", title, "\n")
  
  # Print structure of the dataset
  print(str(data))  
  
  # Print the first few rows to understand the data
  print(head(data))
  
  # Show number of samples and unique labels (if applicable)
  cat("\nNumber of samples in", title, ":", nrow(data), "\n")
  
  if ("label" %in% colnames(data)) {
    cat("Unique labels in", title, ":", length(unique(data$label)), "\n")
  }
}

# Function to visualize images
visualize_images <- function(images, title) {
  cat("\nDisplaying images for:", title, "\n")
  
  # Display basic information about images
  cat("Number of images:", length(images), "\n")
  
  # Print information about the first image
  if (length(images) > 0) {
    image_info <- image_info(images[[1]])
    cat("Image details (first image):\n")
    print(image_info)
  }
  
  # Plot the first few images
  if (length(images) > 0) {
    gridExtra::grid.arrange(grobs = images[1:min(4, length(images))], ncol = 2)
  }
}

# General function to visualize both datasets
visualize_datasets <- function(images, text_data, title) {
  visualize_images(images, paste(title, "Images"))
  visualize_text_data_structure(text_data, paste(title, "Text Data"))
}
