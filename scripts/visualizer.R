# visualizer.R

# Load required libraries
library(ggplot2)     # For data visualization
library(magick)      # For image manipulation
library(gridExtra)   # For arranging multiple grobs
library(grid)        # For using rasterGrob

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
visualize_images <- function(image_directory, title, max_images = 10) {
    cat("\nDisplaying images for:", title, "\n")

    image_folders <- list.dirs(image_directory, full.names = TRUE, recursive = FALSE)

    for (folder in image_folders) {
        cat("Folder:", basename(folder), "- Number of images:", length(list.files(folder, pattern = "\\.(png|jpg|jpeg|webp)$")), "\n")

        # Limit the number of images loaded
        image_files <- list.files(folder, pattern = "\\.(png|jpg|jpeg|webp)$", full.names = TRUE)
        image_files <- image_files[1:min(max_images, length(image_files))]  # Load only up to 'max_images'
        images <- lapply(image_files, image_read)

        cat("Number of images:", length(images), "\n")

        if (length(images) > 0) {
            image_info <- image_info(images[[1]])
            cat("Image details (first image):\n")
            print(image_info)

            # Create ggplot objects for the first few images
            ggplots <- lapply(images, function(img) {
                ggplot() + 
                  annotation_custom(rasterGrob(as.raster(img)), xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
                  theme_void()
            })
            gridExtra::grid.arrange(grobs = ggplots, ncol = 2)
        }
    }
}

# General function to visualize both datasets
visualize_datasets <- function(image_directory, text_data_path) {
    # Load text data from CSV
    text_data <- read.csv(text_data_path)
    
    # Visualize images
    visualize_images(image_directory, "Image Data")
    
    # Visualize text data structure
    visualize_text_data_structure(text_data, "Text Data")
}
