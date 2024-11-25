# visualizer.R

# Load required libraries
library(ggplot2)
library(magick)
library(gridExtra)
library(grid)
library(dplyr)
library(readr)

# Function to compute descriptive statistics for a multilabel dataset
compute_multilabel_stats <- function(data, output_file = NULL) {
    cat("\n--- Dataset Statistics ---\n")
    
    # Number of rows and features
    num_rows <- nrow(data)
    num_features <- ncol(data)
    cat("Number of rows:", num_rows, "\n")
    cat("Number of features (columns):", num_features, "\n")
    
    # Assuming labels are in columns (e.g., one-hot encoded or binary multilabel format)
    label_columns <- names(data)[!sapply(data, is.numeric)]
    num_labels <- length(label_columns)
    cat("Number of labels:", num_labels, "\n")
    
    # Unique classes per label
    label_stats <- sapply(data[label_columns], function(col) length(unique(col)))
    min_classes <- min(label_stats)
    max_classes <- max(label_stats)
    avg_classes <- mean(label_stats)
    cat("Min classes per label:", min_classes, "\n")
    cat("Max classes per label:", max_classes, "\n")
    cat("Average classes per label:", round(avg_classes, 2), "\n")
    
    # Labels per instance (number of non-zero or non-empty entries per row in label columns)
    labels_per_instance <- rowSums(data[label_columns] != 0)
    min_labels <- min(labels_per_instance)
    max_labels <- max(labels_per_instance)
    avg_labels <- mean(labels_per_instance)
    cat("Min labels per instance:", min_labels, "\n")
    cat("Max labels per instance:", max_labels, "\n")
    cat("Average labels per instance:", round(avg_labels, 2), "\n")
    
    # Collect all stats in a table
    stats <- data.frame(
        Metric = c("Number of rows", "Number of features", "Number of labels",
                   "Min classes per label", "Max classes per label", "Average classes per label",
                   "Min labels per instance", "Max labels per instance", "Average labels per instance"),
        Value = c(num_rows, num_features, num_labels,
                  min_classes, max_classes, avg_classes,
                  min_labels, max_labels, avg_labels)
    )
    
    # Save statistics to a CSV file if output_file is provided
    if (!is.null(output_file)) {
        write_csv(stats, output_file)
        cat("\nStatistics saved to", output_file, "\n")
    }
    
    return(stats)
}

# Function to visualize text data structure and descriptive statistics
visualize_text_data_structure <- function(data, title, output_file = "output.csv") {
    cat("\nVisualizing text data structure for:", title, "\n")
    
    # Print structure of the dataset
    print(str(data))  
    
    # Print the first few rows to understand the data
    print(head(data))
    
    # Show number of samples
    cat("\nNumber of samples in", title, ":", nrow(data), "\n")
    
    # Compute and display descriptive statistics
    stats <- compute_multilabel_stats(data, output_file)
    
    return(stats)
}

# General function to visualize both datasets
visualize_datasets <- function(text_data_path) {
    # Load text data from CSV
    text_data <- read.csv(text_data_path)
    
    # Visualize text data structure
    visualize_text_data_structure(text_data, "Text Data")
}
